//
//  AchievementsViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 05/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import UIKit
import GameKit

class AchievementsViewController: UIViewController{

    var gameVC: GameViewController!
    var achievementList = [Achievement]()
    var db:DBHelper = DBHelper()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fillAchievementArray()

        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        self.collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        
        self.collectionView.reloadData()
        
    }
    
    override func loadView() {
        super.loadView()

        self.view.addSubview(collectionView)
        self.collectionView.reloadData()

    }
    
    @IBAction func back(_ sender: Any) {
        //dismiss VC
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
    
    func fillAchievementArray(){
           
        achievementList = db.read(statement: "SELECT * FROM achievement;")
        print(achievementList)
        
    }
    
   
    
   
}

extension AchievementsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievementList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.achievementName.text = String(achievementList[indexPath.item].name)
        print(achievementList[indexPath.item].progress)
        if achievementList[indexPath.item].percentage == 100{
            cell.achievementProgress.text = "completed!"
        }
        else if achievementList[indexPath.item].id == 5 || achievementList[indexPath.item].id == 6 || achievementList[indexPath.item].id == 7 || achievementList[indexPath.item].id == 8 || achievementList[indexPath.item].id == 9{
            cell.achievementProgress.text = "locked"
        }
        else{
            cell.achievementProgress.text = String(achievementList[indexPath.item].percentage) + "%"
        }
        cell.achievementDescription.text = String(achievementList[indexPath.item].description)

        return cell
    }
}

extension AchievementsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //get cell tapped on
        let cell = collectionView.cellForItem(at: indexPath) as! MyCell
        print(cell.achievementName.text!)
    }
}

extension AchievementsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width/4 - 10, height: collectionView.frame.size.width/4 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}

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
    var achievementList = [GKAchievement]()
    weak var collectionView: UICollectionView!

        
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
        
    }
    
    override func loadView() {
        super.loadView()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.sizeThatFits(CGSize(width: self.view.frame.width - 64, height: self.view.frame.height - 20))
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        self.collectionView = collectionView
    }
    
    @IBAction func back(_ sender: Any) {
        //dismiss VC
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
    
    func fillAchievementArray(){
           
        achievementList.append(GKAchievement(identifier: "play100games"))
        achievementList.append(GKAchievement(identifier: "play200games"))
        
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
        cell.achievementName.text = String(achievementList[indexPath.item].identifier)
        return cell
    }
}

extension AchievementsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
}

extension AchievementsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width/4 - 10, height: collectionView.bounds.size.width/4 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}

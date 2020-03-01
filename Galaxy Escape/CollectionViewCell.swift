//
//  CollectionViewCell.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 05/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
        
    weak var achievementName: UILabel!
    weak var achievementProgress: UILabel!
    weak var achievementDescription: UILabel!
    
   override init(frame: CGRect) {
        super.init(frame: frame)

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
    
        let progressLB = UILabel(frame: .zero)
        progressLB.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(progressLB)
    
        let descriptionLB = UILabel(frame: .zero)
        descriptionLB.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(descriptionLB)
        descriptionLB.numberOfLines = 2
        descriptionLB.adjustsFontSizeToFitWidth = true
    
        NSLayoutConstraint.activate([
            textLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: self.contentView.frame.height-80),
            progressLB.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            progressLB.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            progressLB.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            progressLB.heightAnchor.constraint(equalToConstant: self.contentView.frame.height),
            descriptionLB.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            descriptionLB.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            descriptionLB.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            descriptionLB.heightAnchor.constraint(equalToConstant: self.contentView.frame.height+80),
            self.contentView.widthAnchor.constraint(equalToConstant: 200),

        ])
    
        self.achievementName = textLabel
        self.achievementProgress = progressLB
        self.achievementDescription = descriptionLB

        self.contentView.backgroundColor = .white
        self.contentView.alpha = 0.3
        self.achievementName.textAlignment = .center
        self.achievementProgress.textAlignment = .center
        self.achievementDescription.textAlignment = .center

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.achievementName.text = nil
        self.achievementProgress.text = nil
        self.achievementDescription.text = nil


    }
    
}

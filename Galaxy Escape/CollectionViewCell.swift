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

    override init(frame: CGRect) {
        super.init(frame: frame)

        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.achievementName = textLabel

        self.contentView.backgroundColor = .lightGray
        self.achievementName.textAlignment = .center
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
    }
    
}

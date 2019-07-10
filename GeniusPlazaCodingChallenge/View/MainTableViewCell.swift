//
//  MainTableViewCell.swift
//  GeniusPlazaCodingChallenge
//
//  Created by Duy Le 2 on 7/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    let imageview = UIImageView(frame: .zero)
    let nameLabel = UILabel(frame: .zero)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupNameLabel()
        setupImageView()
    }
    
    private func setupNameLabel(){
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func setupImageView(){
        contentView.addSubview(imageview)
        
        imageview.contentMode = .scaleAspectFit
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 5/6).isActive = true
        imageview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageview.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

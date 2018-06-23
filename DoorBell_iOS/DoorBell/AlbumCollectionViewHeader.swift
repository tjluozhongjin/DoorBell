//
//  AlbumCollectionViewHeader.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/22/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class AlbumCollectionViewHeader: UICollectionReusableView {
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.addSubview(textLabel)
        
        textLabel.font = UIFont(name: "Apple Color Emoji", size: 16)
        textLabel.textAlignment = .center
        textLabel.backgroundColor = .white
        textLabel.textColor = .black
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    
}

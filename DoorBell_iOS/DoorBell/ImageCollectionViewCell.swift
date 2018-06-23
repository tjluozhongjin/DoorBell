//
//  ImageCollectionViewCell.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/6/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

// Creating a custom UICollectionViewCell programmatically
class ImageCollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    let errorView = UIImageView()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(activityIndicatorView)
        self.contentView.addSubview(errorView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        
        errorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
        errorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5).isActive = true
        errorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        errorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        errorView.image = #imageLiteral(resourceName: "warning_image_black")
        errorView.isHidden = true
    }
    
}

//
//  DetailView.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/8/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

// Creating a view using a .xib file
class DetailView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("DetailView", owner: self, options: nil)
        self.addSubview(contentView)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    
}

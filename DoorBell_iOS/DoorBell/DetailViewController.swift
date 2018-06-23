//
//  DetailViewController.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/11/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let dataStore = DataStore.sharedInstance
    var delegate: GetPhotoDataDelegate!
    var albumIndex = 0
    var photoIndex = 0
    @IBOutlet var detailView: DetailView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        setGestureRecognizers()
    }
    
    // Download image and Update UI to show selected (or swiped to) photo info
    func setImage() {
        let photo = dataStore.albums[albumIndex].photos[photoIndex]
        detailView.imageView.image = photo.thumbnail
        detailView.detailLabel.text = photo.title
        
        if photo.largeImage == nil {
            photo.downloadlargeImage {
                DispatchQueue.main.async {
                    if photo.largeImage != nil {
                        self.detailView.imageView.image = photo.largeImage!
                    } else {
                        self.detailView.errorView.isHidden = false
                        self.detailView.imageView.isHidden = true
                    }
                    self.detailView.activityIndicator.stopAnimating()
                    
                }
            }
        } else {
            self.detailView.errorView.isHidden = true
            self.detailView.imageView.isHidden = false
            detailView.imageView.image = photo.largeImage
            detailView.activityIndicator.stopAnimating()
        }
    }
    
    // Logic for swiping left or right to view new photo in detail view
    func changeImage(_ sender: UISwipeGestureRecognizer) {
        
        let photo = dataStore.albums[albumIndex].photos[photoIndex]
        
        if sender.direction == .right {
            if photoIndex == 0 && albumIndex > 0 {
                albumIndex -= 1
                photoIndex = dataStore.albums[albumIndex].photos.count - 1
                setImage()
            } else if photoIndex != 0 {
                photoIndex -= 1
                setImage()
            }
        }
        
        if sender.direction == .left {
            if photoIndex == dataStore.albums[albumIndex].photos.count - 1 && photo.photoID < dataStore.photoCount {
                photoIndex = 0
                albumIndex += 1
                setImage()
            } else if photoIndex < dataStore.albums[albumIndex].photos.count - 1 {
                photoIndex += 1
                setImage()
            } else if photo.photoID < dataStore.serializedJSON.count - 1 {
                delegate.getNextBatch { success in
                    if success {
                        self.photoIndex += 1
                        self.setImage()
                    }
                }
            }
        }
    }
    
    // Dismiss view controller when tapping X or swiping up/down
    func xButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Hide or shows text and X button when tapping screen
    func hideLabelAndX() {
        if detailView.xButton.alpha == 1 {
            UIView.animate(withDuration: 0.3) {
                self.detailView.xButton.alpha = 0
                self.detailView.detailLabel.alpha = 0
                self.view.layoutIfNeeded()
            }
            
        } else {
            UIView.animate(withDuration: 0.3) {
                self.detailView.xButton.alpha = 1
                self.detailView.detailLabel.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Add swipe and tap gesture recognizers
    func setGestureRecognizers() {
        detailView.xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(xButtonTapped))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(xButtonTapped))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(changeImage))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(changeImage))
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(hideLabelAndX))
        
        downSwipe.direction = .down
        upSwipe.direction = .up
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        detailView.addGestureRecognizer(downSwipe)
        detailView.addGestureRecognizer(upSwipe)
        detailView.addGestureRecognizer(leftSwipe)
        detailView.addGestureRecognizer(rightSwipe)
        detailView.addGestureRecognizer(tapGR)
    }
    
}

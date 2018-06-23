//
//  Photo.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/6/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit


class Photo {
    
    let thumbnailURLString: String
    let imageURLString: String
    let title: String
    let albumID: Int
    let photoID: Int
    var thumbnail: UIImage?
    var largeImage: UIImage?
    
    

    // Init with item from JSON
    init(with dict: [String : Any]) {
        self.thumbnailURLString = dict["thumbnailUrl"] as! String
        self.imageURLString = dict["url"] as! String
        self.title = dict["title"] as! String
        self.albumID = dict["albumId"] as! Int
        self.photoID = dict["id"] as! Int
    }
    
    // Download thumbnail image from thumbnail URL
    func downloadThumbnail(with completion: @escaping () -> Void) {
        downloadImage(fromURL: thumbnailURLString) { (thumbnail) in
            self.thumbnail = thumbnail
            completion()
        }
    }
    
    // Download detail view Image from image URL
    func downloadlargeImage(with completion: @escaping () -> Void) {
        downloadImage(fromURL: imageURLString) { (largeImage) in
            self.largeImage = largeImage
            completion()
        }
    }
    
    private func downloadImage(fromURL string: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: string)
        let session = URLSession.shared
        
        if let url = url {
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    let responseImageData = UIImage(data: data)
                    if let image = responseImageData {
                        completion(image)
                    } else {
                        print("could not convert data to image")
                    }
                } else {
                    completion(nil)
                }
            }).resume()
        }
    }
    
    
}

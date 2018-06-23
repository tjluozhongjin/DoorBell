//
//  Album.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/22/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation

class Album {
    let albumID: Int
    var photos: [Photo] = []
    
    init(albumID: Int) {
        self.albumID = albumID
    }
}

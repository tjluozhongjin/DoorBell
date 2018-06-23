//
//  DataStore.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/6/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation

class DataStore {
    
    // Create Singleton
    static let sharedInstance = DataStore()
    private init() {}
    let sampleURL = "http://10.0.1.13:8080/"
    var serializedJSON: [[String : Any]] = []
    var albums: [Album] = []
    
    var photoCount: Int {
        var count = 0
        for album in albums {
            count += album.photos.count
        }
        return count
    }
    
    
    
    // Gets photo info and saves it to the datastore
    func getJSON(with completion: @escaping (Bool) -> Void) {
        APIClient.getPhotoInfo(fromURL: sampleURL) { (JSON) in
            if JSON.count == 0 {
                completion(false)
            } else {
                self.serializedJSON = JSON
                completion(true)
            }
        }
    }
    
    // Initializes 30 photos at a time depending on collection view scrolling
    func appendNext30Photos(with completion: () -> Void) {
        if photoCount == 0 && !serializedJSON.isEmpty && photoCount > 29 {
            initializePhotos(formStartingIndex: photoCount, toEndingIndex: photoCount + 29)
        } else if photoCount + 29 < serializedJSON.count {
            initializePhotos(formStartingIndex: photoCount, toEndingIndex: photoCount + 29)
        } else if photoCount < serializedJSON.count {
            initializePhotos(formStartingIndex: photoCount, toEndingIndex: serializedJSON.count - 1)
        }
        completion()
    }
    
    func initializePhotos(formStartingIndex starting: Int, toEndingIndex ending: Int) {
        for i in starting...ending {
            let photoInfo = serializedJSON[i]
            let photo = Photo(with: photoInfo)
            
            if photo.albumID > albums.count {
                let album = Album(albumID: photo.albumID)
                album.photos.append(photo)
                albums.append(album)
            } else {
                albums[photo.albumID - 1].photos.append(photo)
            }
            
        }
    }
    
    
}



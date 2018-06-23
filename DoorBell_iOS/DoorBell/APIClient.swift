//
//  APIClient.swift
//  SamplePhotoApp
//
//  Created by Douglas Galante on 4/6/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class APIClient {
    
    class func getPhotoInfo(fromURL string: String, completion: @escaping ([[String : Any]]) -> Void) {
        let url = URL(string: string)
        let session = URLSession.shared
        
        // If url is valid attemt to obtain JSON with Photo Info and pass it to the completion
        if let url = url {
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [[String : Any]]
                        print(responseJSON)
                        completion(responseJSON)
                        
                    } catch {
                        if let response = response {
                            print("Could not serialize data into JSON\nERROR: \(error)\nRESPONSE: \(response)")
                        }
                    }
                } else {
                    completion([])
                }
            }).resume()
        }
    }
    
    
}

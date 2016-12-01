//
//  ValleyGramImage.swift
//  ValleyGram
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 01/12/16.
//  Copyright © 2016 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

import UIKit
import Foundation
import AwesomeData
import CoreData

class ValleyGramImage: NSManagedObject {

    var format: String?
    var filename: String?
    var author: String?
    var authorUrl: String?
    var postUrl: String?
    var width: NSNumber?
    var height: NSNumber?
    var objectId: NSNumber?
    
    
    func imageUrl(_ size: CGSize = CGSize(width: 0, height: 0)) -> String {
        guard let objectId = objectId else {
            return ""
        }
        
        var customSize = size
        if customSize.width == 0 {
            customSize.width = CGFloat(self.width!.int32Value)
        }
        if customSize.height == 0 {
            customSize.height = CGFloat(self.height!.int32Value)
        }
        
        return String(format:"https://unsplash.it/%d/%d?image=%d", Int(customSize.width), Int(customSize.height), objectId.int32Value)
    }
    
    //MARK: - JSON PARSING
    
    static func parseJSONArray(_ jsonArray: AnyObject?) -> [ValleyGramImage] {
        var objects = [ValleyGramImage]()
        
        if let jsonArray = jsonArray as? [[String: AnyObject]] {
            for object in jsonArray {
                if let parsedObject = parseJSONObject(object){
                    objects.append(parsedObject)
                }
            }
        }
        
        return objects
    }
    
    static func parseJSONObject(_ jsonObject: [String: AnyObject]) -> ValleyGramImage? {
        
        let objectId = parseInt(jsonObject, key: "id")
        let unsplashImage:ValleyGramImage = ValleyGramImage()
        
        unsplashImage.objectId = objectId
        unsplashImage.width = parseDouble(jsonObject, key: "width")
        unsplashImage.height = parseInt(jsonObject, key: "height")
        unsplashImage.format = parseString(jsonObject, key: "format")
        unsplashImage.filename = parseString(jsonObject, key: "filename")
        unsplashImage.author = parseString(jsonObject, key: "author")
        unsplashImage.authorUrl = parseString(jsonObject, key: "author_url")
        unsplashImage.postUrl = parseString(jsonObject, key: "post_url")
        
        return unsplashImage
        
    }
    
}

//
//  ValleyGramInteractorAPI.swift
//  ValleyGram
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 01/12/16.
//  Copyright © 2016 Leonardo Vinicius Kaminski Ferreira. All rights reserved.
//

import UIKit
import AwesomeData

class ValleyGramInteractorAPI: NSObject {

    static let unsplashListUrl = "https://unsplash.it/list"
    
    static func fetchUnsplashImages(_ success:@escaping (_ unsplashImages: [ValleyGramImage])->Void, failure:@escaping (_ message: String?)->Void){
        _ = AwesomeRequester.performRequest(unsplashListUrl, method: .GET) { (data) in
            if let jsonObject = AwesomeParser.jsonObject(data) {
                let unsplashImages = ValleyGramImage.parseJSONArray(jsonObject)
                
                success(unsplashImages)
            }else{
                if let data = data {
                    if let message = String(data: data,encoding: String.Encoding.utf8) {
                        failure(message)
                    }else{
                        failure("Error parsing data")
                    }
                }
            }
        }
    }
    
}

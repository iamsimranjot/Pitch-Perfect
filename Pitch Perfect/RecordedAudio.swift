//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by SimranJot Singh on 14/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

import Foundation

//We can think of this class acting as a Model

class RecordedAudio: NSObject {
    
    //Properties
    
    var filePathUrl: NSURL!
    var title: String! {
        
        get{

            return filePathUrl.lastPathComponent
        }
    }
 
    //Initializer
    
    init(filePathUrl: NSURL) {
        self.filePathUrl = filePathUrl
    }
    
}

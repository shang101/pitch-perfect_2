//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Shirley Hang on 3/26/15.
//  Copyright (c) 2015 shirley. All rights reserved.
//

import Foundation

class RecordedAudio
{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}


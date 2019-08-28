//
//  Video.swift
//  Youtube
//
//  Created by Junyu Lin on 26/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

struct Video{
    var imageName: String?
    var title: String?
    var des: String?
    var numberOfViews: Int?
    var date: Date?
    
    var channel: Channel?
}

struct Channel{
    var name: String?
    var image: String?
}

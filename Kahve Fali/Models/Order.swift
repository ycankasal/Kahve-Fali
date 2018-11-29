//
//  Order.swift
//  Kahve Fali
//
//  Created by ycankasal on 28.11.2018.
//  Copyright © 2018 ycankasal. All rights reserved.
//

import Foundation
import Parse



struct Order {
    var userId : String!
    var subject : Int!
    var status : Int!
    var text : String!
    var image1 : String?
    var image2 : String?
    var name : String!
    var createdAt : Date?

}

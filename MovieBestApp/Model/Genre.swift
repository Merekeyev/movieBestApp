//
//  File.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/19/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import ObjectMapper

private enum Keys: String{
    case id
    case name
}

struct Genre: Mappable {
    
    var id : Int?
    var name : String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map[Keys.id.rawValue]
        name <- map[Keys.name.rawValue]
    }
    
    
}

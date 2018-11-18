//
//  Actor.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import ObjectMapper

private enum Keys: String, CodingKey{
    case name = "name"
    case profilePath = "profile_path"
}

class Actor: Mappable{
    
    var name : String?
    var profilePath : String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map[Keys.name.rawValue]
        profilePath <- map[Keys.profilePath.rawValue]
    }
    
    
}

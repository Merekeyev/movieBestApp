//
//  MoviePreview.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import ObjectMapper

private enum Keys: String, CodingKey{
    case id = "id"
    case title = "title"
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
    case overview = "overview"
}

class Movie: Mappable{
    
    var id : Int?
    var title : String?
    var posterPath: String?
    var backdropPath: String?
    var overview : String?
    var actors : [Actor]?
    var similarMovies : [Movie]?
    
    required init?(map: Map) {}
    
     func mapping(map: Map) {
        id <- map[Keys.id.rawValue]
        title <- map[Keys.title.rawValue]
        posterPath <- map[Keys.posterPath.rawValue]
        backdropPath <- map[Keys.backdropPath.rawValue]
        overview <- map[Keys.overview.rawValue]
    }
    
    
}

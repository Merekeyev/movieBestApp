//
//  MovieService.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/16/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import Moya

public enum Urls {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "02da584cad2ae31b564d940582770598"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
}

public enum MovieService{
    
    case getPopular(Int)
    
}


extension MovieService: TargetType{
    public var baseURL: URL {
        return URL(string: Urls.baseURL)!
    }
    
    public var path: String {
        switch self{
        case .getPopular:
            return "/movie/popular"
        }
    }
    
    public var method: Method {
        switch self{
        case .getPopular:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self{
        case .getPopular:
            return Data()
        }
    }
    
    public var task: Task {
        switch self{
        case .getPopular(let page):
            return .requestParameters(parameters: ["api_key" : Urls.apiKey,
                                                   "page" : page], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}

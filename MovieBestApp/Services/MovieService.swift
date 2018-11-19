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
    case getMovieDetail(Int)
    case getActors(Int)
    case getSimilarMovies(Int)
    case getUpcoming(Int)
    case getGenres
    case getMoviesByGenre(Int)
    case getSearchMovies(String)
}


extension MovieService: TargetType{
    public var baseURL: URL {
        return URL(string: Urls.baseURL)!
    }
    
    public var path: String {
        switch self{
        case .getPopular:
            return "/movie/popular"
        case .getMovieDetail(let movieId):
            return "/movie/\(movieId)"
        case .getActors(let movieId):
            return "/movie/\(movieId)/credits"
        case .getSimilarMovies(let movieId):
            return "/movie/\(movieId)/similar"
        case .getUpcoming:
            return "/movie/upcoming"
        case .getGenres:
            return "/genre/movie/list"
        case .getMoviesByGenre:
            return "/discover/movie"
        case .getSearchMovies:
            return "/search/movie"
            
        }
    }
    
    public var method: Method {
        switch self{
        case .getPopular:
            return .get
        case .getMovieDetail:
            return .get
        case .getActors:
            return .get
        case .getSimilarMovies:
            return .get
        case .getUpcoming:
            return .get
        case .getGenres:
            return .get
        case .getMoviesByGenre:
            return .get
        case .getSearchMovies:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self{
        case .getPopular:
            return Data()
        case .getMovieDetail:
            return Data()
        case .getActors:
            return Data()
        case .getSimilarMovies:
            return Data()
        case .getUpcoming:
            return Data()
        case .getGenres:
            return Data()
        case .getMoviesByGenre:
            return Data()
        case .getSearchMovies:
            return Data()
        }
    }
    
    public var task: Task {
        switch self{
        case .getPopular(let page), .getUpcoming(let page):
            return .requestParameters(parameters: ["api_key" : Urls.apiKey,
                                                   "page" : page], encoding: URLEncoding.default)
        case .getActors, .getSimilarMovies, .getMovieDetail, .getGenres:
            return .requestParameters(parameters: ["api_key" : Urls.apiKey], encoding: URLEncoding.default)
            
        case .getMoviesByGenre(let genreId):
            return .requestParameters(parameters: ["api_key": Urls.apiKey,
                                                   "with_genres":genreId], encoding: URLEncoding.default)
        case .getSearchMovies(let searchText):
            return .requestParameters(parameters: ["api_key" : Urls.apiKey,
                                                   "query" : searchText], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}

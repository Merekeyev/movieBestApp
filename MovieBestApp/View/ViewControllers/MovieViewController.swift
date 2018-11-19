//
//  MovieViewController.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/16/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import Moya
class MovieViewController: UIViewController {
    
    enum MovieType {
        case popular
        case upcoming
        
    }
    
    @IBOutlet weak var movieTableView: UITableView!
    private let provider = MoyaProvider<MovieService>()
    fileprivate var popularMovies = [Movie]()
    fileprivate var upcomingMovies = [Movie]()
    fileprivate var filtredMovies = [Movie]()
    fileprivate var isSearching = false{
        didSet{
            movieTableView.reloadData()
        }
    }
    fileprivate var timer = Timer()
    fileprivate var searchBar = UISearchBar()
    fileprivate var type = MovieType.popular{
        didSet{
            movieTableView.reloadData()
            movieTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadPopularMovies(page: 1)
        loadUpcomingMovies(page: 1)
    }
    
    private func setupView(){
        setupNavigationBar()
        setupMovieTableView()
    }
    
    private func setupMovieTableView(){
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    private func setupNavigationBar(){
        searchBar.placeholder = "Поиск фильмов"
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["Популярное", "Скоро на экранах"]
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.3058823529, alpha: 1)
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        self.navigationItem.titleView = searchBar
        
        
    }
    
    private func loadPopularMovies(page: Int){
        provider.request(.getPopular(page)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResult = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonMoviePreviews = jsonResult["results"] as? [[String: Any]] else {return}
                    self?.popularMovies = jsonMoviePreviews.map({Movie(JSON: $0)!})
                    self?.movieTableView.reloadData()
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server problem \(error.localizedDescription)")
            }
        }
        
    }
    
    private func loadUpcomingMovies(page: Int){
        
        provider.request(.getUpcoming(page)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResult = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonMoviePreviews = jsonResult["results"] as? [[String: Any]] else {return}
                    self?.upcomingMovies = jsonMoviePreviews.map({Movie(JSON: $0)!})
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server problem \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func searchMovies(){
        searchBar.resignFirstResponder()
        if timer.userInfo != nil{
            self.filtredMovies.removeAll()
            provider.request(.getSearchMovies(timer.userInfo as! String)) { [weak self](result) in
                switch result{
                case .success(let response):
                    do{
                        guard let jsonResult = try response.mapJSON() as? [String: Any] else {return}
                        guard let jsonMoviePreviews = jsonResult["results"] as? [[String: Any]] else {return}
                        self?.filtredMovies = jsonMoviePreviews.map({Movie(JSON: $0)!})
                        self?.isSearching = true
                    }catch{
                        print("Mapping problem")
                    }
                case .failure(let error):
                    print("Server problem \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    
    
    
}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return filtredMovies.count
        }
        return type == .popular ?  popularMovies.count : upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {fatalError("Movie tableview cell problem")}
        if isSearching{
            cell.moviePreview = filtredMovies[indexPath.row]
        }else {
            cell.moviePreview = type == .popular ?  popularMovies[indexPath.row] : upcomingMovies[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController else {return}
        if isSearching{
            vc.movie = filtredMovies[indexPath.row]
        }else {
            vc.movie = type == .popular ?  popularMovies[indexPath.row] : upcomingMovies[indexPath.row]
        }
        self.present(vc, animated: true)
    }
    
}



extension MovieViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            type = .popular
        case 1:
            type = .upcoming
        default:
            break
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        //        self.filtredMovies.removeAll()
//        if searchText == ""{
//            isSearching = false
//            movieTableView.reloadData()
//        }else {
//            isSearching = true
//        }
//        switch type {
//        case .popular:
//            for movie in popularMovies{
//                guard let contains = movie.title?.lowercased().contains(searchText.lowercased()) else {return}
//                if contains{
//                    self.filtredMovies.append(movie)
//                }
//            }
//            print(filtredMovies.count)
//            movieTableView.reloadData()
//        case .upcoming:
//            for movie in upcomingMovies{
//                guard let contains = movie.title?.lowercased().contains(searchText.lowercased()) else {return}
//                if contains{
//                    self.filtredMovies.append(movie)
//                }
//            }
//            movieTableView.reloadData()
//        }
        if searchText == ""{
            isSearching = false
            searchBar.resignFirstResponder()
        }
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(searchMovies), userInfo: searchText, repeats: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



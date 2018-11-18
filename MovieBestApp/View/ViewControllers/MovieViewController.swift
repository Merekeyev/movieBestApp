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

    @IBOutlet weak var movieTableView: UITableView!
    private let provider = MoyaProvider<MovieService>()
    fileprivate var moviePreviews = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData(page: 1)
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
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск фильмов"
        searchBar.showsScopeBar = true
        searchBar.delegate = self
        searchBar.scopeButtonTitles = ["Популярное", "Скоро на экранах"]
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = #colorLiteral(red: 0.168627451, green: 0.2705882353, blue: 0.3058823529, alpha: 1)
        UISegmentedControl.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        searchBar.barTintColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        self.navigationItem.titleView = searchBar
    }
    
    private func loadData(page: Int){
        provider.request(.getPopular(page)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResult = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonMoviePreviews = jsonResult["results"] as? [[String: Any]] else {return}
                    self?.moviePreviews = jsonMoviePreviews.map({Movie(JSON: $0)!})
                    self?.movieTableView.reloadData()
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server problem \(error.localizedDescription)")
            }
        }
    }
   

}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviePreviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {fatalError("Movie tableview cell problem")}
        cell.moviePreview = moviePreviews[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController else {return}
        vc.movie = moviePreviews[indexPath.row]
        self.present(vc, animated: true)
    }
    
}

extension MovieViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}



//
//  GenresViewController.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/19/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import Moya
class GenresViewController: UIViewController {

    @IBOutlet weak var genresTableView: UITableView!
    var genres = [Genre]()
    private var provider = MoyaProvider<MovieService>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadGenres()
    }
    
    private func setupView(){
        genresTableView.register(UINib(nibName: "GenresTableViewCell", bundle: nil), forCellReuseIdentifier: "GenresTableViewCell")
        genresTableView.delegate = self
        genresTableView.dataSource = self
    }
    
    private func loadGenres(){
        provider.request(.getGenres) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResponse = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonGenres = jsonResponse["genres"] as? [[String: Any]] else {return}
                    self?.genres = jsonGenres.map({Genre(JSON: $0)!})
                    self?.genresTableView.reloadData()
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server error \(error.localizedDescription)")
            }
        }
    }
    
  
}

extension GenresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenresTableViewCell", for: indexPath) as? GenresTableViewCell else {fatalError()}
        cell.genre = genres[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieByGenreViewController") as? MovieByGenreViewController else {return}
        vc.genre = self.genres[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

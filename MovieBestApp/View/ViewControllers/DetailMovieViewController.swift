//
//  DetailMovieViewController.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/18/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import Moya
class DetailMovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movie : Movie?
    
    var provider = MoyaProvider<MovieService>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
    }
    
    private func setupView(){
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.register(UINib(nibName: "DetailMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailMovieTableViewCell")
        tableView.register(UINib(nibName: "MovieCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCollectionViewTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func loadData(){
        guard let movie = movie, let id = movie.id else {return}
        
        provider.request(.getMovieDetail(id)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonMovie = try response.mapJSON() as? [String: Any] else {return}
                    self?.movie = Movie(JSON: jsonMovie)
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.fade)
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server error \(error.localizedDescription)")
            }
        }
        
        provider.request(.getActors(id)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResponse = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonActors = jsonResponse["cast"] as? [[String: Any]] else {return}
                    self?.movie?.actors = jsonActors.map({Actor(JSON: $0)!})
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableView.RowAnimation.fade)
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server error \(error.localizedDescription)")
            }
        }
        
        provider.request(.getSimilarMovies(id)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResult = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonMoviePreviews = jsonResult["results"] as? [[String: Any]] else {return}
                    self?.movie?.similarMovies = jsonMoviePreviews.map({Movie(JSON: $0)!})
                    self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: UITableView.RowAnimation.fade)
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server problem \(error.localizedDescription)")
            }
        }
        
    }

}

extension DetailMovieViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMovieTableViewCell", for: indexPath) as? DetailMovieTableViewCell else {fatalError()}
            cell.movie = movie
            cell.closeCompletion = { [weak self]()-> () in
                self?.dismiss(animated: true)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCollectionViewTableViewCell", for: indexPath) as? MovieCollectionViewTableViewCell else {fatalError()}
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = 0
            cell.cellType = .actors
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCollectionViewTableViewCell", for: indexPath) as? MovieCollectionViewTableViewCell else {fatalError()}
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.collectionView.tag = 1
            cell.cellType = .similarMovies
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 350
        case 2:
            return 350
        default:
            return 450
        }
    }
    
    
}

extension DetailMovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            guard let movie = movie,let actors = movie.actors else {return 0}
            return actors.count
        case 1:
            guard let movie = movie,let similarMovies = movie.similarMovies else {return 0}
            return similarMovies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            guard let movie = movie, let actors = movie.actors, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActorCollectionViewCell", for: indexPath) as? ActorCollectionViewCell else {return UICollectionViewCell()}
            cell.actor = actors[indexPath.row]
            return cell
        case 1:
            guard let movie = movie, let movies = movie.similarMovies, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMovieCollectionViewCell", for: indexPath) as? SimilarMovieCollectionViewCell else {return UICollectionViewCell()}
            cell.movie = movies[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width * 0.75 , height: 240)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width * 0.75 , height: 240)
        default:
            return CGSize(width: 100, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController else {fatalError()}
            guard let movie = movie , let similarMovies = movie.similarMovies else {return}
            vc.movie = similarMovies[indexPath.row]
            self.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
  
    
}

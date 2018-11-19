//
//  MoviewByGenreViewController.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/19/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit
import Moya
class MovieByGenreViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var genre: Genre?
    fileprivate var movies = [Movie]()
    private var provider = MoyaProvider<MovieService>()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        guard let genre = genre, let id = genre.id else {return}
        loadMovies(genreId: id, page: 1)
        
    }
    
    private func loadMovies(genreId: Int, page: Int){
        provider.request(.getMoviesByGenre(genreId)) { [weak self](result) in
            switch result{
            case .success(let response):
                do{
                    guard let jsonResponse = try response.mapJSON() as? [String: Any] else {return}
                    guard let jsonMovies = jsonResponse["results"] as? [[String : Any]] else {return}
                    self?.movies = jsonMovies.map({Movie(JSON: $0)!})
                    self?.collectionView.reloadData()
                }catch{
                    print("Mapping problem")
                }
            case .failure(let error):
                print("Server error \(error.localizedDescription)")
            }
        }
    }
    
    private func setupView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MovieByGenreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieByGenreCollectionViewCell")
        collectionView.register(UINib(nibName: "GenreHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GenreHeaderCollectionReusableView")
        
    }

}

extension MovieByGenreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieByGenreCollectionViewCell", for: indexPath) as? MovieByGenreCollectionViewCell else {fatalError()}
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 32, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailMovieViewController") as? DetailMovieViewController else {return}
        vc.movie = movies[indexPath.row]
        self.present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "GenreHeaderCollectionReusableView", for: indexPath) as? GenreHeaderCollectionReusableView else {fatalError()}
            view.genre = genre
            return view
        default:
        return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 60)
    }
    
}

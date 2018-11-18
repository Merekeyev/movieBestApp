//
//  MovieViewController.swift
//  MovieBestApp
//
//  Created by Temirlan Merekeyev on 11/16/18.
//  Copyright © 2018 TemirlanMerekeyev. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var movieTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView(){
        setupNavigationBar()
        setupMovieTableView()
    }
    
    private func setupMovieTableView(){
        movieTableView.delegate = self
        movieTableView.dataSource = self
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
   

}

extension MovieViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension MovieViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}



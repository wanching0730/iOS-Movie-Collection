//
//  MasterTableViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {
    
    var movies = [CinemaMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie1 = CinemaMovie(id: 1, title: "Mission Impossible", category: "Action", director: "Johnson", releaseDate: Date(), rating: 5) {
            movies.append(movie1)
        }
        if let movie2 = CinemaMovie(id: 2, title: "Polis Story", category: "Action", director: "Jackie Chan", releaseDate: Date(), rating: 5) {
            movies.append(movie2)
        }
        if let movie3 = CinemaMovie(id: 3, title: "Anabelle", category: "Horror", director: "Lilly", releaseDate: Date(),
            rating: 4){
            movies.append(movie3)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let detailVC = segue.destination as! DetailViewController
            detailVC.selectedMovie = movies[indexPath.row]
        }
    }
    
}

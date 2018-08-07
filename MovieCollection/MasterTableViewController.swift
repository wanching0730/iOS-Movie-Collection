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
    var newMovie = CinemaMovie(id: 0, title: "", category: "", director: "", releaseDate: Date(), rating: 0)
    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "MovieCell")
        }
        
        let image = UIImage(named: "starBlue")
        
        cell!.imageView?.image = image
        cell!.textLabel!.text = movies[indexPath.row].title
        cell!.detailTextLabel?.text = movies[indexPath.row].category
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let detailVC = segue.destination as! DetailViewController
                    detailVC.selectedMovie = movies[indexPath.row]
                }
            } else {
                newMovie = nil
            }
        }
        
    }
    
}

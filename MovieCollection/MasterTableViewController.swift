//
//  MasterTableViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import ChameleonFramework

class MasterTableViewController: UITableViewController {
    
    var movies = [CinemaMovie]()
    var newMovie = CinemaMovie(id: NSUUID() as UUID, title: "", category: "", director: "", releaseDate: Date(), rating: 0, watched: false)
    
    var selectedMovie: CinemaMovie!
    var selectedMovieIndex: Int = 0
    
    override func viewDidLoad() {
        if let movie1 = CinemaMovie(id: NSUUID() as UUID, title: "Mission Impossible", category: "Action", director: "Johnson", releaseDate: Date(), rating: 5, watched: true) {
            movies.append(movie1)
        }
        if let movie2 = CinemaMovie(id: NSUUID() as UUID, title: "Polis Story", category: "Action", director: "Jackie Chan", releaseDate: Date(), rating: 5, watched: false) {
            movies.append(movie2)
        }
        if let movie3 = CinemaMovie(id: NSUUID() as UUID, title: "Anabelle", category: "Horror", director: "Lilly", releaseDate: Date(), rating: 4, watched: true){
            movies.append(movie3)
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectedMovie != nil {
            movies[selectedMovieIndex] = selectedMovie!
        }
        
        tableView.reloadData()
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
        
        let movie = movies[indexPath.row]
        let image = UIImage(named: "starBlue")
        
        cell!.imageView?.image = image
        cell!.textLabel!.text = movie.title
        cell!.detailTextLabel?.text = movie.category
        cell!.accessoryType = movie.watched ? .checkmark : .none
        
        if let colour = UIColor(hexString: "#ff7373")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(movies.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
             cell.detailTextLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let detailVC = segue.destination as! DetailViewController
                    selectedMovieIndex = indexPath.row
                    selectedMovie = movies[indexPath.row]
                    detailVC.selectedMovie = selectedMovie
                }
            } else {
                newMovie = nil
            }
        }
        
    }
    
    @IBAction func returnFromAdd(segue: UIStoryboardSegue) {
        if newMovie != nil {
            movies.append(newMovie!)
        }
        
        let indexPath = IndexPath(row: movies.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
}

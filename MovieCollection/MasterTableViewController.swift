//
//  MasterTableViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreData

class MasterTableViewController: UITableViewController {
    
    var movies = [Movie]()
    var selectedMovie: Movie!
    var selectedMovieIndex: Int = 0
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        setupContext()
        fetchData()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
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
        
        cell.imageView?.image = image
        cell.textLabel!.text = movie.title
        cell.detailTextLabel?.text = movie.category
        cell.accessoryType = movie.watched ? .checkmark : .none
        
        // Create the list view with gradient colour (from dark to light)
        if let colour = UIColor(hexString: "#ff7373")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(movies.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            cell.detailTextLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
            fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", movies[indexPath.row].id! as CVarArg)
            
            do {
                let movies = try managedContext.fetch(fetchRequest) as! [Movie]
                
                if !movies.isEmpty {
                    let foundMovie = movies[0]
                    managedContext.delete(foundMovie as NSManagedObject)
                    self.movies.remove(at: indexPath.row)
                    
                    do {
                        try managedContext.save()
                        print("Status: Movie deleted")
                    } catch {
                        print("Status: Could not delete movie")
                    }
                    
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    print("Status: Movie found")
                } else {
                    print("Status: Movie not found")
                }
            } catch {
                print("Status: could not retrieve searched data")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Set up connection to core data
    func setupContext() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Status: Error in app")
            return
        }
        appDelegate = delegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func fetchData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
            movies = movies.sorted(by: {($0.title?.lowercased())! < ($1.title?.lowercased())!})
        } catch {
            print("Status: Could not retrieve data")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let detailVC = segue.destination as! DetailViewController
                    selectedMovie = movies[indexPath.row]
                    detailVC.selectedMovie = selectedMovie
                }
            }
        }
        
        // To ensure that the list of movies is always updated after each change
        tableView.reloadData()
    }
    
    @IBAction func returnFromAdd(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
}

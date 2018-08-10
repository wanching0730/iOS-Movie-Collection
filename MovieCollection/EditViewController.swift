//
//  EditViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class EditViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var directorField: UITextField!
    @IBOutlet weak var posterField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var watchedSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
    let categoryDropDown = DropDown()
    let ratingDropDown = DropDown()
    
    var rating: Int = -1
    var category: String = ""
    
    var foundMovie: Movie!
    var selectedMovie: Movie!
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDropDown,
            self.ratingDropDown
        ]
    }()
    
    override func viewDidLoad() {
        setupContext()
        setupDropDowns()
        updateUI()
    }
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        categoryDropDown.show()
    }
    
    @IBAction func selectRatingPressed(_ sender: UIButton) {
        ratingDropDown.show()
    }
    
    func setupContext() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Status: Error in app")
            return
        }
        appDelegate = delegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func updateUI() {
        if let movie = selectedMovie {
            titleField.text = movie.title
            directorField.text = movie.director
            posterField.text = movie.posterLink
            
            categoryButton.setTitle(movie.category, for: .normal)
            ratingButton.setTitle("\(movie.rating)", for: .normal)
            
            datePicker.setDate(movie.releaseDate!, animated: true)
            
            watchedSwitch.isOn = movie.watched
        }
    }
    
    func setupDropDown(_ dropdown: DropDown, _ button: UIButton, _ options: [String]) {
        dropdown.anchorView = button
        dropdown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        dropdown.dataSource = options
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            button.setTitle(item, for: .normal)
            
            if button == self.categoryButton {
                self.category = item
                print("Selected category: \(item) at index: \(index)")
            } else {
                self.rating = Int(item)!
                print("Selected rating: \(item) at index: \(index)")
            }
            
        }
    }
    
    func setupDropDowns() {
        dropDowns.forEach { $0.width = 120 }
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
        let categories = ["Action", "Comedy", "Horror", "Romance"]
        let ratings = ["0", "1", "2", "3", "4", "5"]
        
        setupDropDown(categoryDropDown, categoryButton, categories)
        setupDropDown(ratingDropDown, ratingButton, ratings)
    }
    
    func searchMovie() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", selectedMovie.id! as CVarArg)
        
        do {
            let movies = try managedContext.fetch(fetchRequest) as! [Movie]
            
            if !movies.isEmpty {
                foundMovie = movies[0]
                print("Status: Movie found")
            } else {
                print("Status: Movie not found")
            }
        } catch {
            print("Status: could not retrieve searched data")
        }
    }
    
    func updateDatabase() {
        foundMovie.setValue(titleField.text!, forKey: "title")
        foundMovie.setValue(directorField.text!, forKey: "director")
        foundMovie.setValue(posterField.text!, forKey: "posterLink")
        foundMovie.setValue(datePicker.date, forKey: "releaseDate")
        foundMovie.setValue(watchedSwitch.isOn, forKey: "watched")
        
        if category.isEmpty {
            foundMovie.setValue(categoryButton.currentTitle!, forKey: "category")
        } else {
            foundMovie.setValue(category, forKey: "category")
        }
        
        if rating == -1 {
            if let rating = Int32(ratingButton.currentTitle!) {
                foundMovie.setValue(rating, forKey: "rating")
            }
        } else {
            foundMovie.setValue(Int32(rating), forKey: "rating")
        }
        
        do {
            try managedContext.save()
            print("Status: Movie updated")
        } catch {
            print("Status: Could not update movie")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        searchMovie()
        updateDatabase()
        selectedMovie = foundMovie
    }
    
}

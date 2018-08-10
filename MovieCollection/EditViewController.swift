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
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var cinemaButton: UIButton!
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBOutlet weak var watchedSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
    let categoryDropDown = DropDown()
    let cinemaDropDown = DropDown()
    
    var category: String = ""
    var cinema: String = ""
    var rating: Int = -1
    
    var foundMovie: Movie!
    var selectedMovie: Movie!
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDropDown,
            self.cinemaDropDown
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

    @IBAction func selectCinemaPressed(_ sender: UIButton) {
        cinemaDropDown.show()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        rating = lroundf(sender.value)
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
            
            categoryButton.setTitle(movie.category, for: .normal)
            cinemaButton.setTitle(movie.cinema, for: .normal)
            
            datePicker.setDate(movie.releaseDate!, animated: true)
            
            ratingSlider.value = Float(movie.rating)
            
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
                self.cinema = item
                print("Selected cinema: \(item) at index: \(index)")
            }
            
        }
    }
    
    func setupDropDowns() {
        dropDowns.forEach { $0.width = 140 }
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
        let categories = ["Action", "Comedy", "Horror", "Romance"]
        let cinemas = ["Cheras Selatan", "Cheras Sentral", "Pavillion", "Sunway Pyramid"]
        
        setupDropDown(categoryDropDown, categoryButton, categories)
        setupDropDown(cinemaDropDown, cinemaButton, cinemas)
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
        foundMovie.setValue(datePicker.date, forKey: "releaseDate")
        foundMovie.setValue(ratingSlider.value, forKey: "rating")
        foundMovie.setValue(watchedSwitch.isOn, forKey: "watched")
        
        if category.isEmpty {
            foundMovie.setValue(categoryButton.currentTitle!, forKey: "category")
        } else {
            foundMovie.setValue(category, forKey: "category")
        }
        
        if cinema.isEmpty {
                foundMovie.setValue(cinemaButton.currentTitle!, forKey: "cinema")
        } else {
            foundMovie.setValue(cinema, forKey: "cinema")
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleField.text!.isEmpty || directorField.text!.isEmpty  {
            let alertController = UIAlertController (
                title: "Invalid Submission",
                message: "Please complete all fields before proceed",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let cancelAction = UIAlertAction (
                title: "Cancel",
                style: UIAlertActionStyle.cancel,
                handler: nil
            )
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        } else {
            return true
        }
    }
    
}

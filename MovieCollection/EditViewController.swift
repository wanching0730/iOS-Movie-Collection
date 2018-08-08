//
//  EditViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import DropDown

class EditViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var directorField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var watchedSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let categoryDropDown = DropDown()
    let ratingDropDown = DropDown()
    
    var category: String = ""
    var rating: Int = -1
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDropDown,
            self.ratingDropDown
        ]
    }()
    
    var selectedMovie: CinemaMovie!
    
    override func viewDidLoad() {
        setupDropDowns()
        
        dropDowns.forEach { $0.width = 120 }
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
        if let movie = selectedMovie {
            titleField.text = movie.title
            directorField.text = movie.director
            
            categoryButton.setTitle(movie.category, for: .normal)
            ratingButton.setTitle("\(movie.rating)", for: .normal)
            
            datePicker.setDate(movie.releaseDate, animated: true)
            
            watchedSwitch.isOn = movie.watched
        }
    }
    
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        categoryDropDown.show()
    }
    
    
    @IBAction func selectRatingPressed(_ sender: UIButton) {
        ratingDropDown.show()
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
        let categories = ["Action", "Comedy", "Horror", "Romance"]
        let ratings = ["0", "1", "2", "3", "4", "5"]
        
        setupDropDown(categoryDropDown, categoryButton, categories)
        setupDropDown(ratingDropDown, ratingButton, ratings)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if category.isEmpty {
            selectedMovie.category = categoryButton.currentTitle!
        } else {
            selectedMovie.category = category
        }
        
        if rating == -1 {
            if let rating = Int(ratingButton.currentTitle!) {
                selectedMovie.rating = rating
            }
        } else {
            selectedMovie.rating = rating
        }
    
        selectedMovie.title = titleField.text!
        selectedMovie.director = directorField.text!
        selectedMovie.releaseDate = datePicker.date
        selectedMovie.watched = watchedSwitch.isOn
        
    }
    
}

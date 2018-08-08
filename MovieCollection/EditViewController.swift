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
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var directorField: UITextField!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let categoryDropDown = DropDown()
    let ratingDropDown = DropDown()
    
    var category: String = ""
    var rating: Int = 0
    
    let movieCategories: [String: Int] = ["Action":0, "Comedy": 1, "Horror": 2, "Romance": 3]
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDropDown,
            self.ratingDropDown
        ]
    }()
    
    var selectedMovie: CinemaMovie!
    
    override func viewDidLoad() {
        setupDropDown()
        dropDowns.forEach { $0.width = 120 }
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
        
        if let movie = selectedMovie {
            idField.text = "\(movie.id)"
            titleField.text = movie.title
            directorField.text = movie.director
            
            categoryDropDown.selectRow(movieCategories[movie.category]!)
            print(movieCategories[movie.category]!)
            print(movie.rating - 1)
            ratingDropDown.selectRow(movie.rating - 1)
        }
       
    }
    
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        categoryDropDown.show()
    }
    
    
    @IBAction func selectRatingPressed(_ sender: UIButton) {
        ratingDropDown.show()
    }
    
    func setupDropDown() {
        setupCategoryDropDown()
        setupRatingDropDown()
    }
    
    func setupCategoryDropDown() {
        categoryDropDown.anchorView = categoryButton
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: categoryButton.bounds.height)
        categoryDropDown.dataSource = [String](movieCategories.keys)
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.categoryButton.setTitle(item, for: .normal)
            self.category = item
            print("Selected category: \(item) at index: \(index)")
        }
    }
    
    func setupRatingDropDown() {
        ratingDropDown.anchorView = ratingButton
        ratingDropDown.bottomOffset = CGPoint(x: 0, y: ratingButton.bounds.height)
        ratingDropDown.dataSource = ["1", "2", "3", "4", "5"]
        ratingDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.ratingButton.setTitle(item, for: .normal)
            self.rating = Int(item)!
            print("Selected rating: \(item) at index: \(index)")
        }
    }
    
}

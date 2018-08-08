//
//  ViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 28/07/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import DropDown

class AddViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var directorField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var watchedSwitch: UISwitch!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    let categoryDropDown = DropDown()
    let ratingDropDown = DropDown()
    
    var category: String = ""
    var rating: Int = 0
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.categoryDropDown,
            self.ratingDropDown
        ]
    }()
    
    override func viewDidLoad() {
        let now = Date()
        datePicker.setDate(now, animated: true)
        
        setupDropDown()
        dropDowns.forEach { $0.width = 120 }
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .bottom }
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
        categoryDropDown.dataSource = ["Action", "Comedy", "Horror", "Romance"]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var newMovie: CinemaMovie
        
        // Usage of UUID is to ensure every movie ID is unique
        newMovie = CinemaMovie(id: NSUUID() as UUID, title: titleField.text!, category: category, director: directorField.text!, releaseDate: datePicker.date, rating: rating, watched: watchedSwitch.isOn)!
        
        let masterVC = segue.destination as! MasterTableViewController
        masterVC.newMovie = newMovie
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleField.text!.isEmpty || directorField.text!.isEmpty  || category.isEmpty || rating == 0 {
            let alertController = UIAlertController (
                title: "Empty Field",
                message: "Please fill in all fields before proceed",
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


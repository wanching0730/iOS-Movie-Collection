//
//  ViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 28/07/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import DropDown
import CoreData

class AddViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var directorField: UITextField!
    @IBOutlet weak var posterField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var watchedSwitch: UISwitch!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!
    
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
    
    override func viewDidLoad() {
        setupContext()
        
        let now = Date()
        datePicker.setDate(now, animated: true)
        
        watchedSwitch.setOn(false, animated: true)
        
        setupDropDowns()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movie.setValue(NSUUID() as UUID, forKey: "id")
        movie.setValue(titleField.text!, forKey: "title")
        movie.setValue(category, forKey: "category")
        movie.setValue(directorField.text!, forKey: "director")
        movie.setValue(posterField.text!, forKey: "posterLink")
        movie.setValue(datePicker.date, forKey: "releaseDate")
        movie.setValue(rating, forKey: "rating")
        movie.setValue(watchedSwitch.isOn, forKey: "watched")
        
        do {
            try managedContext.save()
            print("Status: Data saved")
        } catch {
            print("Status: Could not save data")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleField.text!.isEmpty || directorField.text!.isEmpty  || category.isEmpty || rating == -1 {
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


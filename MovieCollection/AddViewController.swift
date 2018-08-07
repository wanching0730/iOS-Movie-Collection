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

    @IBOutlet weak var categoryButton: UIButton!
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        dropDown.anchorView = categoryButton
        dropDown.dataSource = ["Action", "Comedy", "Horror", "Romance"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                self.categoryButton.setTitle(item, for: .normal)
                print("Selected item: \(item) at index: \(index)")

        }
        dropDown.width = 120
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.bottomOffset = CGPoint(x: 0, y: categoryButton.bounds.height)
        
    }
    
    
    @IBAction func selectCategoryPressed(_ sender: UIButton) {
        dropDown.show()
    }
}


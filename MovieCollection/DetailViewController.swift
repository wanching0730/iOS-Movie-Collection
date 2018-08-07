//
//  DetailViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var selectedMovie: CinemaMovie!
    
    override func viewDidLoad() {
        
        if let movie = selectedMovie {
            idLabel.text = "\(movie.id)"
            categoryLabel.text = movie.category
            directorLabel.text = movie.director
            dateLabel.text = "\(movie.releaseDate)"
            ratingLabel.text = "\(movie.rating)"
        }
        
    }
    
}

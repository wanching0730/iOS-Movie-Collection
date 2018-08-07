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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    var selectedMovie: CinemaMovie!
    
    override func viewDidLoad() {
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let movie = selectedMovie {
            idLabel.text = "\(movie.id)"
            titleLabel.text = movie.title
            categoryLabel.text = movie.category
            directorLabel.text = movie.director
            dateLabel.text = "\(dateFormatter.string(from: movie.releaseDate))"
            ratingLabel.text = "\(movie.rating)"
        }
        
    }
    
}

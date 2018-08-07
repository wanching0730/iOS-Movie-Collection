//
//  Movie.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import Foundation

class CinemaMovie {
    var id: Int
    var title: String
    var category: String
    var director: String
    var releaseDate: Date
    var rating: Int
    
    init?(id: Int, title: String, category: String, director: String, releaseDate: Date, rating: Int) {
        
        if id == nil || title == nil || category == nil || director == nil || releaseDate == nil
            || rating == nil {
            return nil
        }
        
        self.id = id
        self.title = title
        self.category = category
        self.director = director
        self.releaseDate = releaseDate
        self.rating = rating
        
    }
}

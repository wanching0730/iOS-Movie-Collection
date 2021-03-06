//
//  Movie.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import Foundation

// Testing purpose
class CinemaMovie {
    var id: UUID
    var title: String
    var category: String
    var director: String
    var releaseDate: Date
    var rating: Int
    var watched: Bool
    
    init?(id: UUID, title: String, category: String, director: String, releaseDate: Date, rating: Int, watched: Bool) {
        
        if title.isEmpty || category.isEmpty || director.isEmpty || rating == -1 {
            return nil
        }
        
        self.id = id
        self.title = title
        self.category = category
        self.director = director
        self.releaseDate = releaseDate
        self.rating = rating
        self.watched = watched
    }
}

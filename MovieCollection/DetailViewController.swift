//
//  DetailViewController.swift
//  MovieCollection
//
//  Created by Wan Ching on 07/08/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cinemaLabel: UILabel!
    @IBOutlet weak var watchedLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    
    var selectedMovie: Movie!
    
    override func viewDidLoad() {
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        setUpInterface()
        
        if let url = URL(string: "https://giornaledilecco.it/media/2018/07/filmes-de-empresas-e-empresarios-de-sucesso.jpg") {
            imageView.contentMode = .scaleAspectFit
            downloadImage(url: url)
        }
    }
    
    func setUpInterface() {
        if let movie = selectedMovie {
            titleLabel.text = movie.title
            categoryLabel.text = movie.category
            directorLabel.text = movie.director
            cinemaLabel.text = movie.cinema
            dateLabel.text = "\(dateFormatter.string(from: movie.releaseDate!))"
            ratingLabel.text = "\(movie.rating)"
            
            if movie.watched {
                watchedLabel.text = "Watched"
                watchedLabel.textColor = UIColor.flatGreenDark
            } else {
                watchedLabel.text = "Unwatched"
                watchedLabel.textColor = UIColor.red
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! EditViewController
        editVC.selectedMovie = selectedMovie
    }
    
    @IBAction func returnFromEdit(segue: UIStoryboardSegue) {
        setUpInterface()
    }
    
}

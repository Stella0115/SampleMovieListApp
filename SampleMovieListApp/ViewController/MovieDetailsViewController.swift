//
//  MovieDetailsViewController.swift
//  MovieListApp
//
//  Created by Stella Lei on 12/10/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeToClose = UISwipeGestureRecognizer()
        swipeToClose.addTarget(self, action: #selector(goBack) )
        swipeToClose.direction = .right
        self.view!.addGestureRecognizer(swipeToClose)

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = selectedMovie.title
        
        overviewTextView.text = selectedMovie.overview
        
        voteAverageLabel.text = "Vote Average:" + String(format:"%.2f", selectedMovie.vote_average!)
        
        popularityLabel.text = "Popularity:" + String(format:"%.2f", selectedMovie.popularity!)

        imageView.image = selectedMoviePoster.poster
        
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
}

//
//  VariablesHelper.swift
//  MovieApp
//
//  Created by Stella Lei on 12/10/21.
//

import Foundation
import UIKit

struct Movie: Decodable{
    var page: Int?
    var results: [Results]?
    var total_pages: Int?
    var total_results: Int?
}

struct Results: Decodable{
    var id: Int?
    var title: String?
    var vote_average: Float?
    var overview: String?
    var release_date: String?
    var original_title: String?
    var original_language: String?
    var backdrop_path: String?
    var poster_path: String?
    var adult: Bool?
    var video: Bool?
    var vote_count: Int?
    var popularity: Float?
}

struct MoviePoster{
    var id: Int?
    var poster : UIImage?
}

var movieArray = [Results]()
var filteredMovieArray = [Results]()
var moviePosterArray = [MoviePoster]()

var selectedMovie = Results()
var selectedMoviePoster = MoviePoster()


let movieDataUrl = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-us&page="
let imageUrl = "https://image.tmdb.org/t/p/w500"
let apiKey = "***************"

var viewControllerInstance = ViewController()

var estimateWidth = 180
var cellMarginSize = 15

var pageNum = 1

var resultsCount: Int = 0 


var searchActive : Bool = false
let searchController = UISearchController(searchResultsController: nil)



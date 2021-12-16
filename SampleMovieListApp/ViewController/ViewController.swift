//
//  ViewController.swift
//  MovieListApp
//
//  Created by Stella Lei on 12/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Loading..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.isUserInteractionEnabled = false
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        viewControllerInstance = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieCell",bundle: nil), forCellReuseIdentifier: "MovieCell")
       
        
        self.loadMoreButton.layer.masksToBounds = true
        self.loadMoreButton.layer.cornerRadius = self.loadMoreButton.frame.width/15.0
        
        getMovieData(page: pageNum)
        
    }
       
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
 

    @IBAction func loadMoreButtonTap(_ sender: UIButton) {
        
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.placeholder = "Loading..."

        pageNum = pageNum + 1
        getMovieData(page: pageNum)
        
        let item = self.tableView(self.tableView, numberOfRowsInSection: 0) - 1
        let lastItemIndex = IndexPath(row: item, section: 0)
        self.tableView.scrollToRow(at: lastItemIndex, at: .top, animated: true)
        
    }

}




extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredMovieArray.count
        }
        else{
            return moviePosterArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)  as! MovieCell
        DispatchQueue.main.async {
            if searchActive{
                cell.setData(
                    image: moviePosterArray[getPosterWithId(id: filteredMovieArray[indexPath.row].id!)!].poster!,
                    text:  filteredMovieArray[indexPath.row].title!,
                    overview: movieArray[indexPath.row].overview!)
            }
            else{
                cell.setData(
                    image: moviePosterArray[indexPath.row].poster!,
                    text:  movieArray[indexPath.row].title!,
                    overview: movieArray[indexPath.row].overview!)
            }
          }
          return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive{
            selectedMovie = filteredMovieArray[indexPath.row]
            selectedMoviePoster.poster = moviePosterArray[getPosterWithId(id: filteredMovieArray[indexPath.row].id!)!].poster!
        }
        else{
            selectedMovie = movieArray[indexPath.row]
            selectedMoviePoster.poster = moviePosterArray[indexPath.row].poster!
        }

        if let resultController = storyboard!.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController {
            let navController = UINavigationController(rootViewController: resultController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated:true, completion: nil)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}



extension ViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
//
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchActive = false
        self.dismiss(animated: true, completion: nil)

    }

    func updateSearchResults(for searchController: UISearchController)
    {
        if searchController.searchBar.text!.count >= 3 {
            searchActive = true
            let searchString = searchController.searchBar.text
            filteredMovieArray = movieArray.filter({ (item) -> Bool in
                let countryText: NSString = item.title! as NSString
                return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

        }else if searchController.searchBar.text!.count == 0 {
            searchActive = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        searchActive = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchActive = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {

        if !searchActive {
            searchActive = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        searchController.searchBar.resignFirstResponder()
    }

}

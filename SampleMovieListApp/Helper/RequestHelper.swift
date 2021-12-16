//
//  RequestHelper.swift
//  MovieApp
//
//  Created by Stella Lei on 12/10/21.
//

import Foundation
import UIKit

public func getMovieData(page:Int){
    
    let urlString =  movieDataUrl + String(page)
    let urlStringg = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: urlStringg!)
    
    URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
        guard let data = data, error == nil else {
            print("URLSession Error : \(String(describing: error))")
            return
        }
        let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        print(convertToJsonData(data: obj))
        do
        {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            let movies : [Movie] = [movie]
            resultsCount +=  movies[0].results!.count
            for items in movies{
                for i in 0...items.results!.count - 1{
                    
                    movieArray.append(items.results![i])
                    setImage(path:(items.results?[i].poster_path)!, id: items.results![i].id!)
                    
                }
            }
        }
        catch let error{
            print("Json Parse Error : \(error)")
        }
    }).resume()
    
}
func convertToJsonData(data:Any) -> String {
    if (data is NSDictionary) == false &&  (data is NSArray) == false{
        return "{\"error\":\"json format error\"}"
    }
    var jsonData = Data()
    do{
        try  jsonData = JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
    }catch{
        print(error)
        return "{\"error\":\"json format error\"}"
    }
    var jsonString =  String(data: jsonData, encoding: String.Encoding.utf8) ?? "{\"error\":\"json format error\"}"
    jsonString = jsonString.replacingOccurrences(of: " ", with: "", options: String.CompareOptions.literal, range: jsonString.startIndex..<jsonString.endIndex)
    jsonString = jsonString.replacingOccurrences(of: "\n", with: "", options: String.CompareOptions.literal, range: jsonString.startIndex..<jsonString.endIndex)
    return jsonString
}
func setImage(path: String, id : Int) {
    
    let imageURL = URL(string: imageUrl + path)
    
    let group = DispatchGroup()
    group.enter()
    
    DispatchQueue.global().async {
        
        guard let imageData = try? Data(contentsOf: imageURL!) else {
            print("Image Data Error")
            return
        }
        let image = UIImage(data: imageData)
        
        DispatchQueue.main.async {
            moviePosterArray.append(MoviePoster(id: id, poster: image))
            viewControllerInstance.tableView.reloadData()
            if moviePosterArray.count == resultsCount{
                searchController.searchBar.isUserInteractionEnabled = true
                searchController.searchBar.placeholder = "Search..."
            }
            group.leave()
            
        }
        group.wait()
        
    }
    group.wait()
}

func getPosterWithId(id: Int) -> Int? {
    return movieArray.firstIndex { $0.id == id }
}


//
//  SearchViewController.swift
//  favorite-movies-app
//
//  Created by Leon Sacks on 9/21/17.
//  Copyright © 2017 Leon Sacks. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var searchText: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var searchResults: [Movie] = []
    
    @IBAction func search (sender: UIButton){
        var searchTerm = searchText.text!
        if searchTerm.characters.count > 2 {
            retrieveMoviesByTerm(searchTerm: searchTerm)
        }
    }
    
    func retrieveMoviesByTerm(searchTerm: String) {
        let url = "https://api.themoviedb.org/3/search/movie?api_key=1d0d951ffb3f9e762152ae3f24757c15&query=\(searchTerm)"
        HttpHandler.getJson(urlString: url, completionHandler: parseDataIntoMovies)
    }
    
    func parseDataIntoMovies(data: Data?) -> Void {
        if let data = data {
            let object = JsonParser.parse(data: data)
            if let object = object {
                self.searchResults = MovieDataProcessor.mapJsonToMovies(object: object, moviesKey: "results")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search Results"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCell(withIdentifier: "customcell",
                                                      for: indexPath) as! CustomTableViewCell
        
        let idx: Int = indexPath.row
        
        movieCell.movieTitle?.text = searchResults[idx].title
        movieCell.movieYear?.text = searchResults[idx].year
        displayMovieImage(idx, movieCell: movieCell)
        return movieCell
    }
    
    func displayMovieImage(_ row: Int, movieCell: CustomTableViewCell){
        let url: String = (URL(string: searchResults[row].imageUrl)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
            (data, response, error) -> Void in
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let image = UIImage(data: data!)
                movieCell.movieImageView?.image = image
            })
        }).resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

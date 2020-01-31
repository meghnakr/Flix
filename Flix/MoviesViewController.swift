//
//  MoviesViewController.swift
//  Flix
//
//  Created by user162638 on 1/22/20.
//  Copyright © 2020 user162638. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //you can now access movies from anywhere in the program
    //An array of dictionaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        //print("Hello")
        
        // TODO: Get the array of movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // TODO: Store the movies in a property to use elsewhere
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.movies = dataDictionary["results"] as! [[String:Any]] //movies is now an array of the data in results
                //looking for the results section
                //as! casts dataDictionary to an array of dictionaries
                // TODO: Reload your table view data
                self.tableView.reloadData()
                
                //print(dataDictionary); //dataDictionary is the info from the link
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this is called to generate the rows in the table view
        return movies.count //number of items (movies) in the movies array
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //this method is called for each row in the table view to generate the cells
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies[indexPath.row] //accesses the movie from the movies array corresponding to the index of the row
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        //identifies the key of the data we need, gets the data with that key
        //at first, the data if of type Any, but then we say as! String to cast it to a String (necessary to make it the text of a Label
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        
        cell.posterView.af_setImage(withURL: posterURL!)
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading new screen")
        
        //Find out which movie was selected
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for:
            cell)!
        let movie = movies[indexPath.row]
        
        //Pass the movie to the movie details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

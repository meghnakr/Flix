//
//  MovieGridViewController.swift
//  Flix
//
//  Created by user162638 on 1/31/20.
//  Copyright © 2020 user162638. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var movies = [[String:Any]]()
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - 2*layout.minimumInteritemSpacing) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5)

        // Do any additional setup after loading the view.
        // TODO: Get the array of movies
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
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
                
                print(self.movies)
                self.collectionView.reloadData()
                
                //print(dataDictionary); //dataDictionary is the info from the link
            }
        }
        task.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        
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
        
        //Find out which movie was selected
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for:
            cell)!
        let movie = movies[indexPath.item]
        
        //Pass the movie to the movie details view controller
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
    
        //Deselect item (the cell) in the grid
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}

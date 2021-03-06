//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by Danna on 1/30/16.
//  Copyright © 2016 Dan. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var searched: [NSDictionary]!
    var endPoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0);
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(named: "movies"), forBarMetrics: .Default)
            //navigationBar.tintColor = UIColor(red: 1.0, green: 0.25, blue: 0.25, alpha: 0.3)
            
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
            shadow.shadowOffset = CGSizeMake(2, 2);
            shadow.shadowBlurRadius = 4;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFontOfSize(22),
                NSForegroundColorAttributeName : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.8),
                //NSShadowAttributeName : shadow
            ]
        }
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.searched = self.movies;
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)

                            
                            self.tableView.reloadData()
                    }
                }
        })
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        self.tableView.reloadData();
        refreshControl.endRefreshing();
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searched = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
        */
        if let searchedMovies = searched {
            return searchedMovies.count;
        } else {
            return 0;
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        // No color when the user selects cell
        //cell.selectionStyle = .None
        
        // Use a red color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.blueColor()
        cell.selectedBackgroundView = backgroundView

        let movie = searched![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        //let baseUrl = "http://image.tmdb.org/t/p/w500"
        let smallImageUrl = "http://image.tmdb.org/t/p/w45"
        let largeImageUrl = "http://image.tmdb.org/t/p/original"
        
        if let posterPath = movie["poster_path"] as? String {
            //let imageUrl = NSURL(string: baseUrl + posterPath)
            //cell.posterView.setImageWithURL(imageUrl!)
            
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallImageUrl + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeImageUrl + posterPath)!)
            
            cell.posterView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        cell.posterView.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                            // per ImageView. This code must be in the completion block.
                            cell.posterView.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                                    cell.posterView.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    // possibly setting the ImageView's image to a default image
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
        }
        
        //let size: CGSize = cell.sizeThatFits(CGSizeMake(cell.frame.size.width, CGFloat.max));
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        //cell.titleLabel.sizeToFit()
        //cell.overviewLabel.sizeThatFits(size)
        
        
        //cell.textLabel!.text = title
        //print("row \(indexPath.row)")
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        
        
        
        print("prepare for segue called")
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    
    
}

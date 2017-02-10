 //
//  TumblrFeedViewController.swift
//  Tumblr Feed
//
//  Created by samman on 2/2/17.
//  Copyright © 2017 Samman Thapa. All rights reserved.
//

import UIKit
 import AFNetworking

class TumblrFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var feeds: [NSDictionary]? = []
    
    // initially know that the app has already made a network request
    var isMoreDataLoading = false
    
    // for indicator for infinite scrolling
    var loadingMoreView:InfiniteScrollIndicatorView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for infinity scroll
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollIndicatorView.defaultHeight)
        loadingMoreView = InfiniteScrollIndicatorView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollIndicatorView.defaultHeight;
        tableView.contentInset = insets
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 240
        
        // make an api call
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        

    let request = URLRequest(url: url!)
    let session = URLSession(
        configuration: URLSessionConfiguration.default,
        delegate:nil,
        delegateQueue:OperationQueue.main
    )
    
    let task : URLSessionDataTask = session.dataTask(
        with: request as URLRequest,
        completionHandler: { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? NSDictionary {
                    //print("responseDictionary: \(responseDictionary)")
                    
                    // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                    // This is how we get the 'response' field
                    let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                    
                    // This is where you will store the returned array of posts in your posts property
                    self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    
                    self.tableView.reloadData()
                }
            }
    });
    task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (feeds?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        let feed = feeds?[indexPath.row]
        
        // get photos
        if let photos = feed?.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
                
                cell.posterView.setImageWith(imageUrl)
                //self.tableView.reloadData()
                
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
                print("imageUrlString is nil")
            }
            
            
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
            print("photos is nil")
        }
        
        return cell
    }
    
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // make an api call
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        
        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        
                        self.tableView.reloadData()
                        
                        // Tell the refreshControl to stop spinning
                        refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }
    
    
    func loadMoreData() {
        // make an api call
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
                
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        // update the flag to stop making network call
                        self.isMoreDataLoading = false
                        
                        // Stop the loading indicator
                        self.loadingMoreView!.stopAnimating()
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        
                        print("data \(self.feeds )")
                        self.tableView.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    
    // For everytime we scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                print("<>><><>><><><><><><>><><><><><>< making network calls here")
                
                self.isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollIndicatorView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results through network call
                loadMoreData()
                
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        var indexPath = tableView.indexPath(for: cell)
        
        let feed = self.feeds![indexPath!.row]
        print ("segue")
        
        let detailedViewController = segue.destination as! PhotoDetailsViewController
        
        detailedViewController.feed = feed
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

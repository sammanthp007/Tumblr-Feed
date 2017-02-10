//
//  PhotoDetailsViewController.swift
//  Tumblr Feed
//
//  Created by samman on 2/9/17.
//  Copyright © 2017 Samman Thapa. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    var feed: NSDictionary!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get photos
        let photos = feed?.value(forKeyPath: "photos") as? [NSDictionary]
        
        if let photos = feed?.value(forKeyPath: "photos") as? [NSDictionary] {
            // photos is NOT nil, go ahead and access element 0 and run the code in the curly braces
            //print("received photos")
            let imageUrlString = photos[0].value(forKeyPath: "original_size.url") as? String
            
            if let imageUrl = URL(string: imageUrlString!) {
                // URL(string: imageUrlString!) is NOT nil, go ahead and unwrap it and assign it to imageUrl and run the code in the curly braces
                print ("receied image url: \(imageUrl)")
                
                posterImageView.setImageWith(imageUrl)
                //self.tableView.reloadData()
                
            } else {
                // URL(string: imageUrlString!) is nil. Good thing we didn't try to unwrap it!
                print("imageUrlString is nil")
            }
            
            
        } else {
            // photos is nil. Good thing we didn't try to unwrap it!
            print("photos is nil")
        }
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

//
//  ImageCell.swift
//  Flick Pic
//
//  Created by ibn Adam on 18/10/18.
//  Copyright © 2018 aslam. All rights reserved.
//

import UIKit

// global declaration of the cache variable.
let imageCache = NSCache<NSString, UIImage>()

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    func setImage(_ photo: Photo) {
        // add default image to the image view untill actual image loads asynchronously.
       self.imageView.image = UIImage(named: "ImagePlaceholder")
       self.imageView.downloadImage(photo, indicator)
    }
}

// MARK: - Extension
extension UIImageView {
    
    func downloadImage(_ photo: Photo, _ activityIndicator: UIActivityIndicatorView) {
        
        var serverImageURL : String?
        activityIndicator.startAnimating()

        let imgURL = "http://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(Constants.APIDetails.ImageSizeMedium).jpg"
        // generate url from string.
        let url = URLRequest(url: URL(string: imgURL)!)
        
        // storing the url temporarily for comparision.
        serverImageURL = imgURL
        
        // check if the image is already in the cache, if yes load in the image view.
        if let imageToCache = imageCache.object(forKey: imgURL as NSString) {
            self.image = imageToCache
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        
        // call server to get the images.
         URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error",error!)
                return
            }
            DispatchQueue.main.async {
                
                if let imageData = data
                {
                    print("loading images to collectionview")
                    // convert data value in image.
                    let imageToCache = UIImage(data: imageData) ?? UIImage()
                    // store the image and URL in the cache.
                    imageCache.setObject(imageToCache, forKey: imgURL as NSString)
                    // check if the URL response is same as previous call.
                    if(imgURL == serverImageURL){
                        // assign the image to image view and stop the activity indicator.
                        self.image = imageToCache
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                    }
                }
            }
        }.resume()
    }
}

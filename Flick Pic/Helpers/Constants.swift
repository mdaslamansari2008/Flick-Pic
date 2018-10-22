//
//  Constants.swift
//  Flick Pic
//
//  Created by ibn Adam on 19/10/18.
//  Copyright © 2018 aslam. All rights reserved.
//

import Foundation



import Foundation


struct Constants {
    
    struct Navigation {
        static let Heading = "Images"
    }
    
    struct Messages {
        static let Warning = "⚠️ Warning!"
        static let NoInternet = "No internet. Please check your internet connectivity."
        static let TryAgain = "Try Again!"
        static let Cancel = "Cancel"
        static let InitialSearchText = "Kittens"
    }
    
    struct APIDetails {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest/"
        static let APIKey = "3e7cc266ae2b0e0d78e279ce8e361736"
        // as per the API it can send data based on the request. For more details : https://www.flickr.com/services/api/misc.urls.html
        static let ImageSizeMedium = "m"
    }
    
}



//
//  Network.swift
//  Flick Pic
//
//  Created by ibn Adam on 18/10/18.
//  Copyright © 2018 aslam. All rights reserved.
//

import Foundation

class Network: NSObject {
    
    /**
     Gets the list of images from Flicker server. Data is received page wise which can contain 98 to 100
     - Parameter query: Pass a search string whose images you want to get. For ex: Puppy
     - Parameter pageNo: Pass page number.
     - Returns: Sucess or error object after the server call.
     */
    public  func getDataFromServer(query : String, pageNo:Int, onSuccess successHandler:@escaping (PhotosAPIResponse)-> Void, onError errorHandler:@escaping (Error)-> Void) {
        
        // generate the URL component based on the search string.
        let urlComponent = generateComponents(searchString: query, pageNo: pageNo)
        
        // check if url is in correct or empty
        guard let url = urlComponent.url else {
            print("URL incorrect or empty");
            return
        }
        
        // initiate the API call to the server.
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // check if the error found
            if error != nil {
                print("Error",error!.localizedDescription)
                errorHandler(error!)
                return
            }
            
            do {
                // dataResponse received from a network request
                let decoder = JSONDecoder()
                // Using codable feature to parse the JSON data
                let model = try decoder.decode(PhotosAPIResponse.self, from: data!)
                // callback the data through closure.
                successHandler(model)
                
            } catch let parsingError {
                print("Error", parsingError)
                errorHandler(parsingError)
                return 
            }
            
        }.resume()
        
    }
    
    
    /**
     Generates the query string
     - Parameter searchString: Pass the search text
     - Parameter searchString: Pass page number.
     - Returns: component object and you can access url with component.url
     */
    private func generateComponents(searchString: String, pageNo: Int) -> URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.APIDetails.APIScheme
        urlComponents.host   = Constants.APIDetails.APIHost
        urlComponents.path   = Constants.APIDetails.APIPath
        
        urlComponents.queryItems = [
            URLQueryItem(name: "method", value: String("flickr.photos.search")),
            URLQueryItem(name: "api_key", value: String(Constants.APIDetails.APIKey)),
            URLQueryItem(name: "format", value: String("json")),
            URLQueryItem(name: "nojsoncallback", value: String(1)),
            URLQueryItem(name: "safe_search", value: String(1)),
            URLQueryItem(name: "text", value: String(searchString)),
            URLQueryItem(name: "page", value: String(pageNo))
        ]
        
        return urlComponents
    }
}

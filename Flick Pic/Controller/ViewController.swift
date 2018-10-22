//
//  ViewController.swift
//  Flick Pic
//
//  Created by ibn Adam on 18/10/18.
//  Copyright © 2018 aslam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Properties and variables declaration
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [Photo] = []
    var pageNo: Int = 0
    var searchString: String = Constants.Messages.InitialSearchText
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup the navigation bar
        setUp()
        
        // generate default data
        self.getImagesData()
    }
    
    /// Set up all the changes before screen is loaded.
    func setUp(){
        navigationItem.title = Constants.Navigation.Heading
        navigationController?.navigationBar.prefersLargeTitles = true
        // add a search bar in the navigation header
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Ex: Puppy"
        // by default adding Kittens as search string.
        searchController.searchBar.text = searchString
        definesPresentationContext = true
        navigationItem.searchController = searchController
      
        
        // calculating the space and fitting the 3 columns based on margin.
        let width = (view.frame.size.width - 2 ) / 3
        let layout  = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        // adding prefetch feature
        collectionView.prefetchDataSource = self
    }
    
    
    //MARK: - Show on initial load for the search text and hide when start scrolling.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    
    /// Gets the Image list data from the server
    func getImagesData() {
        // initiating the network service
        let networkCall = Network()
        // updating the page number
        self.pageNo = pageNo + 1
        // calling webservice to get the list of the images.
        networkCall.getDataFromServer(query: searchString, pageNo: pageNo, onSuccess: { (response) in
            
            print(self.photos.count)
            // appending the images to the list.
            self.photos = (self.photos) + response.photos.photo
            // transfering the control to main thread.
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }

        }) { (Error) in
            print(Error)
            DispatchQueue.main.async {
                self.showAlert(message: Error.localizedDescription)
            }
            
        }
    }
    
     /**
     prepare cell for the collection view and also initiate image downloading process.
     - Parameter indexPath: Pass the indexPath from collection view delegates.
     - Returns: A custom cell from ImageCollectionViewCell type.
     */
    func getCustomCell(_ indexPath: IndexPath) -> ImageCollectionViewCell {
        
        let photo = photos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.tag = indexPath.row
        cell.setImage(photo)
        return cell
    }
    

    /**
     Showing alert message to the user
     - Parameter message: Any instruction which you need to show it to users.
     */
    func showAlert(message : String) {
        let alert = UIAlertController(title: Constants.Messages.Warning, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.Messages.TryAgain, style: .default, handler: { action in
            print("Try connecting again")
            self.getImagesData()
        }))
        alert.addAction(UIAlertAction(title: Constants.Messages.Cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




//MARK: - Collection view delegates and extension
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    // prefetch helps in getting image data from server before we scroll bottom. This helps in loading images quickly and gives smooth experience to users.
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            _ = getCustomCell(indexPath)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // call and load images from server.
        let cell = getCustomCell(indexPath)
        
        // get more image list of data from the server.
        if indexPath.row == photos.count - 1 {
            getImagesData()
        }
        
        return cell
    }
    
}

//MARK: - SearchBar delegates and extension
extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("searchBar")
    }
}

extension ViewController: UISearchResultsUpdating {
    // starts searching immediately on typing the work.
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    // works after enter button is pressed.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // clear the old data
        self.photos.removeAll()
        // remove the white space.
        searchString = searchBar.text!.trimmingCharacters(in: .whitespaces)
        // not allowing the empty strings.
        if searchString == "" {
          searchBar.text = ""
          return
        }
        // get data from server
        self.getImagesData()
    }
    
}

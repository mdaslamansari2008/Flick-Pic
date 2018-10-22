//
//  Flick_PicTests.swift
//  Flick PicTests
//
//  Created by ibn Adam on 18/10/18.
//  Copyright © 2018 aslam. All rights reserved.
//

import XCTest
@testable import Flick_Pic

class Flick_PicTests: XCTestCase {
    
    var networkCall: Network?
    var sessionUnderTest: URLSession!

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkCall = Network()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkCall = nil
        sessionUnderTest = nil
        super.tearDown()
    }
    
    /// Check if able to get image list from server.
    func testCheckMultipleCallCount() {
        
        // 1. given
        let pageNo: Int = 1
        let promise = expectation(description: "Count matches")
        
        
        // 2. when
            networkCall!.getDataFromServer(query: Constants.Messages.InitialSearchText, pageNo: pageNo, onSuccess: { (response) in
                
                // 3. then
                let photoDetails =  response.photos.photo
                let count = photoDetails.count
                
                if count < 90 {
                    XCTFail("Error: Images count not returned as per count")
                }
                
                XCTAssertEqual("ok", response.stat, "The response failed with stat")
                promise.fulfill()
                
                
            }) { (error) in
                XCTFail("Error: \(error.localizedDescription)")
            }
    
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    /// Check if the images are able to download from server.
    func testGetPhotoDownload() {
        
        // given
        let photo = Photo(id: "23451156376", owner: "28017113@N08", secret: "8983a8ebc7", server: "578", farm: 1, title: "Merry Christmas!", ispublic: 1, isfriend: 0, isfamily: 0)
        
        let imgURL = "http://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_\(Constants.APIDetails.ImageSizeMedium)_m.jpg"
        
        let url = URL(string: imgURL)
        
        
        // 1
        let promise = expectation(description: "Images is downloaded")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
                
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}

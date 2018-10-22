//
//  Images.swift
//  Flick Pic
//
//  Created by ibn Adam on 19/10/18.
//  Copyright © 2018 aslam. All rights reserved.
//


//MARK: Flicker API response structure for codable.
struct PhotosAPIResponse: Codable {
    var photos: Photos
    var stat: String
}

struct Photos: Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo:[Photo]
}

struct Photo: Codable{
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
}

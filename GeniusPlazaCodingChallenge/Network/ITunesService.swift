//
//  ITunesService.swift
//  GeniusPlazaCodingChallenge
//
//  Created by Duy Le 2 on 7/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

class ITunesService{
    private let bookGETURL = "https://rss.itunes.apple.com/api/v1/us/books/top-free/all/100/non-explicit.json"
    private let musicGETURL = "https://rss.itunes.apple.com/api/v1/us/itunes-music/hot-tracks/all/100/non-explicit.json"
    
    private let networkService = NetworkService()
    
    func fetchMusic(success: (([Item]) -> Void)?, failure: ((_ error:String) -> Void)?){
        
        guard let url = URL(string: musicGETURL) else{
            failure?("Wrong Base URL")
            return
        }
        networkService.request(url: url, method: .GET, params: nil, headers: nil, success: { (data) in
            
            success?(ITunesJSONMapper.process(data: data, type: .Music))
            
        }) { (data, error, statusCode) in
            
            if let error = error{
                failure?(error.localizedDescription)
            }
            else{
                failure?("Request failed with code \(statusCode)")
            }
        }
    }
    
    func fetchBooks(success: (([Item]) -> Void)?, failure: ((_ error:String) -> Void)?){
        guard let url = URL(string: bookGETURL) else{
            failure?("Wrong Base URL")
            return
        }
        networkService.request(url: url, method: .GET, params: nil, headers: nil, success: { (data) in
            
            success?(ITunesJSONMapper.process(data: data, type: .Book))
            
        }) { (data, error, statusCode) in
            
            if let error = error{
                failure?(error.localizedDescription)
            }
            else{
                failure?("Request failed with code \(statusCode)")
            }
        }
    }
}

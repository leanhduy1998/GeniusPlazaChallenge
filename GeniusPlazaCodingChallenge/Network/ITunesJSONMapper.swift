//
//  ITunesJSONMapper.swift
//  GeniusPlazaCodingChallenge
//
//  Created by Duy Le 2 on 7/10/19.
//  Copyright © 2019 Duy Le 2. All rights reserved.
//

import Foundation

class ITunesJSONMapper{
    static func process(data:Data?,type:MediaType)->[Item]{
        guard let jsonData = data else{
            return []
        }
        var json:[String:Any]!
        do{
            json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
        }
        catch{
            return []
        }
        
        
        guard let feed = json["feed"] as? [String:Any] else{
            return []
        }
        guard let results = feed["results"] as? [[String:Any]] else{
            return []
        }
        
        var items = [Item]()
        
        for result in results{
            guard let name = result["name"] as? String else{
                continue
            }
            guard let imageUrl = result["artworkUrl100"] as? String else{
                continue
            }
            let item = Item(name: name, imageUrl: imageUrl, type: type)
            items.append(item)
        }
        
        return items
    }
}

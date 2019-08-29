//
//  ApiService.swift
//  Youtube
//
//  Created by Junyu Lin on 29/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class ApiService: NSObject{
    
    static let shard = ApiService()
    
    func fetchData(_ completion: @escaping ([Video]) -> (Void)){
        var videos = [Video]()
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                for dictionary in json as! [[String: AnyObject]]{
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    var video = Video()
                    var channel = Channel()
                    
                    channel.image = dictionary["channel"]?["profile_image_name"] as? String
                    channel.name = dictionary["channel"]?["name"] as? String
                    
                    video.channel = channel
                    video.title = dictionary["title"] as? String
                    video.duration = dictionary["duration"] as? Int
                    video.numberOfViews = dictionary["number_of_views"] as? Int
                    video.imageName = dictionary["thumbnail_image_name"] as? String
                    if let channelName = video.channel?.name, let views = formatter.string(for: video.numberOfViews){
                        video.des = "\(channelName) - \(views)"
                    }
                    videos.append(video)
                }
                
                completion(videos)
                
            } catch let jsonError{
                print(jsonError)
            }
            }.resume()
    }
}

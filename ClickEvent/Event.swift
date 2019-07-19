//
//  Event.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/4.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding{
    
    var title,time,date,location,url: String!
    
    func encode(with aCoder: NSCoder) {
        if let date = date { aCoder.encode(date, forKey: "date") }
        if let time = time { aCoder.encode(time, forKey: "time") }
        if let title = title { aCoder.encode(title, forKey: "title") }
        if let location = location { aCoder.encode(location, forKey: "location") }
        if let url = url { aCoder.encode(url, forKey: "url") }
    }

    convenience init(title: String,time: String,date: String,location: String,url: String){
        self.init()
        self.title = title
        self.time = time
        self.date = date
        self.location = location
        self.url = url
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.time = aDecoder.decodeObject(forKey: "time") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.url = aDecoder.decodeObject(forKey: "url") as! String
    }
}

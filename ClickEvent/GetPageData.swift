//
//  GetPageData.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/5.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import Foundation

class GetPageData{
    
    class func getData(urlText:String) ->[Event]{
        var events = [Event]()
        let url = URL(string: urlText)
        do {
            let contents = try String(contentsOf: url!)
            events = ParseHtml.Parser(data: contents)
            return events
        } catch {
            // contents could not be loaded
        }
        return events
    }
    
    class func getData2(urlText:String) ->[Event]{
        var events = [Event]()
        let url = URL(string: urlText)
        do {
            let contents = try String(contentsOf: url!)
            events = ParseHtml.Parser2(data: contents)
            return events
        } catch {
            // contents could not be loaded
        }
        return events
    }
}

//
//  ParseHtml.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/5.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import Foundation
import SwiftSoup

class ParseHtml{
    
    class subEvent{
        var infoString, data: String?
        init(infoString: String, data: String){
            self.infoString = infoString
            self.data = data
        }
    }
    
    class func Parser(data: String) -> [Event]{
        var events = [Event]()
        do{
            let doc: Document = try SwiftSoup.parse(data)
            
            let links: Elements = try doc.select("a")
            let infos: Elements = try doc.select("li")
            //var subEvents = [ParseHtml.subEvent]()
            var count: Int = 0
            
            for link in links {
                let linkHref: String = try link.attr("href")
                let linkText: String = try link.text()
                
                if linkText.hasSuffix("追加") || linkText == ""
                    || linkHref.hasPrefix("https://www.waseda.jp/top"){
                    
                }else if linkHref.hasPrefix("https://www.waseda.jp"){
                    //print(linkHref)
                    //print(linkText)
                    let item: Event = Event(title: linkText,time: "",date: "",location: "", url: linkHref)
                    events.append(item)
                    count = count+1
                }
            }
            //Get the useful data of time,date,spot
            var temData = [subEvent]()
            //var k: Int = 0
            for info in infos {
                let infoClass:String = try info.attr("class")
                if infoClass == "cal-icon cal-icon-time"{
                    let time: String = try info.text()
                    let item: subEvent = subEvent(infoString: infoClass, data: time)
                    temData.append(item)
                }else if infoClass == "cal-icon cal-icon-date"{
                    let date: String = try info.text()
                    let item: subEvent = subEvent(infoString: infoClass, data: date)
                    temData.append(item)
                }else if infoClass == "cal-icon cal-icon-spot"{
                    let spot: String = try info.text()
                    let item: subEvent = subEvent(infoString: infoClass, data: spot)
                    temData.append(item)
                }
            }
            
            var i: Int = 0
            var j: Int = 0
            
            let num: Int = temData.count
            
            while j < num {
                //Get the time
                let item: subEvent = temData[j]
                if item.infoString == "cal-icon cal-icon-time"{
                    if i < count{
                        events[i].time = item.data!
                        //print(item.data!)
                        j += 1
                        //Get the date
                        let itemDate: subEvent = temData[j]
                        if itemDate.infoString == "cal-icon cal-icon-date"{
                            events[i].date = itemDate.data!
                            //print(itemDate.data!)
                            j += 1
                        }
                        //Get the spot
                        let itemSpot: subEvent = temData[j]
                        if itemSpot.infoString == "cal-icon cal-icon-spot"{
                            events[i].location = itemSpot.data!
                            //print(itemSpot.data!)
                            j += 1
                        }
                    }else { j += 1 }
                    //i += 1
                }else if item.infoString == "cal-icon cal-icon-date"{
                    if i < count{
                        events[i].date = item.data!
                        //print(item.data!)
                        j += 1
                        //Get the spot
                        let itemSpot: subEvent = temData[j]
                        if itemSpot.infoString == "cal-icon cal-icon-spot"{
                            events[i].location = itemSpot.data!
                            //print(itemSpot.data!)
                            j += 1
                        }
                    }else { j += 1 }
                    
                }else if item.infoString == "cal-icon cal-icon-spot"{
                    if i < count{
                        events[i].location = item.data!
                        //print(item.data!)
                        j += 1
                    }else { j += 1 }
                }
                i += 1
            }
            return events
        } catch Exception.Error( _, let message) {
            print(message)
        }catch{
            print("error")
        }
        return events
    }
    
    class func Parser2(data: String) -> [Event]{
        var events = [Event]()
        do{
            let doc: Document = try SwiftSoup.parse(data)
            let links: Elements = try doc.select("a")
            
            for link in links {
                let linkHref: String = try link.attr("href")
                let linkText: String = try link.text()
                if (linkText != "") && (linkText != "ニュースNews") && (linkHref.hasPrefix("https://www.waseda.jp/fsci/news/")){
                    let indexForFirst = linkText.index(of: "/")
                    var date = linkText.suffix(from: indexForFirst!)
                    let lastIndex = date.index(date.endIndex, offsetBy: -1)
                    date.remove(at: lastIndex)
                    date.remove(at: date.startIndex)
                    let item: Event = Event(title: linkText,time: "", date: String(date), location: "", url: linkHref)
                    events.append(item)
                }
            }
            return events
        } catch Exception.Error( _, let message) {
            print(message)
        }catch{
            print("error")
        }
        return events
    }
}

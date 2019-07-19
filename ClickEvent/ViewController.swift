//
//  ViewController.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/2.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = "Home"
        // 创建只带标题的UIBarButtonItem
        //let nextItem = UIBarButtonItem(title: "next", style: .plain, target: self, action: #selector(goToNextPage));
        //self.navigationItem.rightBarButtonItem = nextItem
        
        let imageView = UIImageView(frame: CGRect(x:10, y:10, width:400, height:600))
        imageView.image = UIImage(named:"1.png")
        //imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageView)
        
        textField = UITextField(frame: CGRect(x:40, y:70, width:250, height:30))
        //设置边框样式为圆角矩形
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Input the keyword to search"
        self.view.addSubview(textField)
        
        //search function
        let searchButton:UIButton = UIButton(type: .custom)
        //设置按钮位置和大小
        searchButton.frame=CGRect(x:290, y:70, width:60, height:30)
        //设置按钮文字
        searchButton.setTitle("Seach", for:UIControlState.normal)
        searchButton.setTitleColor(UIColor.blue, for: .normal)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        self.view.addSubview(searchButton);
        
        //Events for all students
        let buttonForAS:UIButton = UIButton(type: .custom)
        //设置按钮位置和大小
        buttonForAS.frame=CGRect(x:20, y:150, width:300, height:30)
        //设置按钮文字
        buttonForAS.setTitle("Events for all students", for:UIControlState.normal)
        buttonForAS.setTitleColor(UIColor.blue, for: .normal)
        buttonForAS.addTarget(self, action: #selector(goToCalendarPageForAll(_sender:)), for: .touchUpInside)
        self.view.addSubview(buttonForAS);
        
        //Events for ICC
        let buttonForICC:UIButton = UIButton(type: .custom)
        //设置按钮位置和大小
        buttonForICC.frame=CGRect(x:20, y:200, width:300, height:30)
        //设置按钮文字
        buttonForICC.setTitle("Events for ICC", for:UIControlState.normal)
        buttonForICC.setTitleColor(UIColor.blue, for: .normal)
        buttonForICC.addTarget(self, action: #selector(goToCalendarPageForICC(_sender:)), for: .touchUpInside)
        self.view.addSubview(buttonForICC);
        
        //Events for FSE
        let buttonForFSE:UIButton = UIButton(type: .custom)
        //设置按钮位置和大小
        buttonForFSE.frame=CGRect(x:20, y:250, width:300, height:30)
        //设置按钮文字
        buttonForFSE.setTitle("Events for FSE", for:UIControlState.normal)
        buttonForFSE.setTitleColor(UIColor.blue, for: .normal)
        buttonForFSE.addTarget(self, action: #selector(goToCalendarPageForFSE(_sender:)), for: .touchUpInside)
        self.view.addSubview(buttonForFSE);
        
        let buttonForWP:UIButton = UIButton(type: .custom)
        //设置按钮位置和大小
        buttonForWP.frame=CGRect(x:20, y:300, width:300, height:30)
        //设置按钮文字
        buttonForWP.setTitle("Wasedacoop", for:UIControlState.normal)
        buttonForWP.setTitleColor(UIColor.blue, for: .normal)
        buttonForWP.addTarget(self, action: #selector(goToWcoopPage), for: .touchUpInside)
        self.view.addSubview(buttonForWP);
        
        let buttonForCC:UIButton = UIButton(type: .custom)
        //设置按钮位置和大小
        buttonForCC.frame=CGRect(x:20, y:350, width:300, height:30)
        //设置按钮文字
        buttonForCC.setTitle("Career Center", for:UIControlState.normal)
        buttonForCC.setTitleColor(UIColor.blue, for: .normal)
        buttonForCC.addTarget(self, action: #selector(goToCalendarPageForCC), for: .touchUpInside)
        self.view.addSubview(buttonForCC);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func goToCalendarPageForAll(_sender: UIButton){
        getDataFromPage(keyString: "AllStudents", url: "https://www.waseda.jp/top/event/list", timeKey: "TimeForAll")
    }
    
    @objc func goToCalendarPageForICC(_sender: UIButton){
        getDataFromPage(keyString: "ICC", url: "https://www.waseda.jp/inst/icc/events/report/", timeKey: "TimeForICC")
    }
    
    @objc func goToCalendarPageForFSE(_sender: UIButton){
        getDataFromPage2(keyString: "FSE", url: "https://www.waseda.jp/fsci/tag/events/", timeKey: "TimeForFSE")
    }
    
    @objc func goToWcoopPage(){
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        webVC.urlString = "https://twitter.com/wcoopST57P"
        webVC.pageName = "生協"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc func goToCalendarPageForCC(_sender: UIButton){
        getDataFromPage(keyString: "CC", url: "https://www.waseda.jp/inst/career/tag/job_support/", timeKey: "TimeForCC")
    }
    
    func getEnoughTime(timeKey:String)-> Bool{
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let defaults = UserDefaults.standard
        let time = defaults.integer(forKey: timeKey)
        if time != TID_NULL{
            if timeStamp - time  > 86400{
                return true
            }
        }else{
            return true
        }
        return false
    }
    
    func getDataFromPage(keyString:String, url:String, timeKey:String){
        let defaults = UserDefaults.standard
        if defaults.data(forKey: keyString) == nil{
            let events:[Event] = GetPageData.getData(urlText: url)
            let eventsData = NSKeyedArchiver.archivedData(withRootObject: events)
            defaults.set(eventsData, forKey: keyString)
            
            let now = Date()
            //当前时间的时间戳
            let timeInterval:TimeInterval = now.timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            defaults.set(timeStamp, forKey: timeKey)
        }else{
            if getEnoughTime(timeKey:timeKey){
                let events:[Event] = GetPageData.getData(urlText: url)
                let eventsData = NSKeyedArchiver.archivedData(withRootObject: events)
                defaults.set(eventsData, forKey: keyString)
                
                let now = Date()
                //当前时间的时间戳
                let timeInterval:TimeInterval = now.timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                defaults.set(timeStamp, forKey: timeKey)
            }
        }
        let calendarVC = CalendarViewController(nibName:"CalendarViewController", bundle: nil)
        calendarVC.keyString = keyString
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    func getDataFromPage2(keyString:String, url:String, timeKey:String){
        let defaults = UserDefaults.standard
        if defaults.data(forKey: keyString) == nil{
            let events:[Event] = GetPageData.getData2(urlText: url)
            let eventsData = NSKeyedArchiver.archivedData(withRootObject: events)
            defaults.set(eventsData, forKey: keyString)
            
            let now = Date()
            //当前时间的时间戳
            let timeInterval:TimeInterval = now.timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            defaults.set(timeStamp, forKey: timeKey)
        }else{
            if getEnoughTime(timeKey:timeKey){
                let events:[Event] = GetPageData.getData2(urlText: url)
                let eventsData = NSKeyedArchiver.archivedData(withRootObject: events)
                defaults.set(eventsData, forKey: keyString)
                
                let now = Date()
                //当前时间的时间戳
                let timeInterval:TimeInterval = now.timeIntervalSince1970
                let timeStamp = Int(timeInterval)
                defaults.set(timeStamp, forKey: timeKey)
            }
        }
        let calendarVC = CalendarViewController(nibName:"CalendarViewController", bundle: nil)
        calendarVC.keyString = keyString
        self.navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func search(){
        let defaults = UserDefaults.standard
        let eventsData = defaults.data(forKey: "AllStudents")
        var searchEvents = [Event]()
        if eventsData != nil{
            let events = NSKeyedUnarchiver.unarchiveObject(with: eventsData!) as! [Event]
            let text:String = textField.text!
            //print(text)
            for event in events{
                if (event.title.range(of:text) != nil){
                    searchEvents.append(event)
                }
            }
            if searchEvents.count > 0{
                let eventsData = NSKeyedArchiver.archivedData(withRootObject: searchEvents)
                defaults.set(eventsData, forKey:"searchEvents")
                let detailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
                detailVC.keyString = "searchEvents"
                self.navigationController?.pushViewController(detailVC, animated: true)
            }else{
                showNoEvent()
            }
        }else{
            showNoEvent()
        }
    }
    
    func showNoEvent(){
        let message = "No event!"
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
     @objc func goToDetailPage(){
     let defaults = UserDefaults.standard
     if defaults.data(forKey: "AllStudents") == nil{
     let events:[Event] = GetPageData.getData(urlText: "https://www.waseda.jp/top/event/list")
     let eventsData = NSKeyedArchiver.archivedData(withRootObject: events)
     defaults.set(eventsData, forKey:"AllStudents")
     }
     let detailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
     detailVC.keyString = "AllStudents"
     self.navigationController?.pushViewController(detailVC, animated: true)
     }*/
    
    /*
    @objc func test(){
        //GetPageData.getData(urlText: "https://www.waseda.jp/top/event/list")
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        webVC.urlString = "https://www.waseda.jp/top/event/list"
        webVC.pageName = "For All Students"
        self.navigationController?.pushViewController(webVC, animated: true)
    }*/
}


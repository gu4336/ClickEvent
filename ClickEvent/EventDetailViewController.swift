//
//  EventDetailViewController.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/8.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //创建TableView
    var tableView = UITableView()
    var events = [Event]()
    var keyString: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Event list"
        
        let defaults = UserDefaults.standard
        let eventsData = defaults.data(forKey: keyString)
        events = NSKeyedUnarchiver.unarchiveObject(with: eventsData!) as! [Event]
        
        //初始化TableView
        tableView = UITableView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cell";
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellID)
        
        cell.textLabel?.text = String(events[indexPath.row].title as String)
        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.numberOfLines = 2
        cell.detailTextLabel?.text = "Date: \(events[indexPath.row].date as String) " + "Time: \(events[indexPath.row].time as String) " + "Location: \(events[indexPath.row].location as String) "
        
        return cell
    }

    //Section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    //cell点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*let alertController = UIAlertController(title: "提示", message: "这是第\(indexPath.row)个cell", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)*/
        
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        webVC.urlString = events[indexPath.row].url as String
        webVC.pageName = "Event Detail"
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

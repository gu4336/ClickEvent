//
//  CalendarViewController.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/2.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController {
    
    var keyString: String = ""
    
    //星期菜单栏
    private var menuView: CVCalendarMenuView!
    
    //日历主视图
    private var calendarView: CVCalendarView!
    
    var currentCalendar: Calendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        currentCalendar = Calendar.init(identifier: .gregorian)
        
        let currentDate = Foundation.Date()
        //初始化的时候导航栏显示当年当月
        let dateTitle: String = CVDate(date: currentDate, calendar: currentCalendar).globalDescription
        
        //设置又导航按钮（调用gotoBackView方法）
        let leftBarItem = UIBarButtonItem( title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackView))
        //将按钮添加到导航栏上
        self.navigationItem.leftBarButtonItem = leftBarItem;
        self.navigationItem.title = dateTitle
        
        //初始化星期菜单栏
        self.menuView = CVCalendarMenuView(frame: CGRect(x:0, y:70, width:self.view.frame.size.width, height:20))
        
        //初始化日历主视图
        self.calendarView = CVCalendarView(frame: CGRect(x:0, y:90, width:self.view.frame.size.width, height:400))
        
        //星期菜单栏代理
        self.menuView.menuViewDelegate = self
        
        //日历代理
        self.calendarView.calendarDelegate = self
        
        //将菜单视图和日历视图添加到主视图上
        self.view.addSubview(menuView)
        self.view.addSubview(calendarView)
    }
    
    @objc func goBackView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //更新日历frame
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
    }

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CalendarViewController: CVCalendarViewDelegate,CVCalendarMenuViewDelegate {
    //视图模式
    func presentationMode() -> CalendarMode {
        //使用月视图
        return .monthView
    }
    
    //每周的第一天
    func firstWeekday() -> Weekday {
        //从星期一开始
        return .monday
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        //导航栏显示当前日历的年月
        self.title = date.globalDescription
    }
    
    //每个日期上面是否添加横线(连在一起就形成每行的分隔线)
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    //切换月的时候日历是否自动选择某一天（本月为今天，其它月为第一天）
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    //日期选择响应
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        //获取日期
        let date = dayView.date.convertedDate()!
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM/dd"
        var dateString = dformatter.string(from: date)
        
        let offset3Index = dateString.index(dateString.startIndex, offsetBy: 3)
        if dateString[offset3Index] == "0" {
            dateString.remove(at: offset3Index)
        }
        if dateString[dateString.startIndex] == "0" {
            dateString.remove(at: dateString.startIndex)
        }
        var newEvents = [Event]()
        let defaults = UserDefaults.standard
        let eventsData = defaults.data(forKey: keyString)
        let events = NSKeyedUnarchiver.unarchiveObject(with: eventsData!) as! [Event]
        for event in events{
            if event.date.range(of:dateString) != nil{
                newEvents.append(event)
            }
        }
        if newEvents.count > 0{
            let newEventsData = NSKeyedArchiver.archivedData(withRootObject: newEvents)
            defaults.set(newEventsData, forKey:"DateEvents")
            
            let detailVC = EventDetailViewController(nibName: "EventDetailViewController", bundle: nil)
            detailVC.keyString = "DateEvents"
            self.navigationController?.pushViewController(detailVC, animated: true)
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
}

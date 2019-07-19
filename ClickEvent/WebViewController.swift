//
//  WebViewController.swift
//  ClickEvent
//
//  Created by Apple on 2018/7/4.
//  Copyright © 2018年 Zhiqiang Gu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var urlString:String = ""
    var pageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置又导航按钮（调用gotoBackView方法）
        let leftBarItem = UIBarButtonItem( title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackView))
        //将按钮添加到导航栏上
        self.navigationItem.leftBarButtonItem = leftBarItem;
        self.navigationItem.title = pageName
        
        let webView = UIWebView(frame: CGRect(x:0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height-60))
        //webView.delegate = self
        if urlString == "https://twitter.com/wcoopST57P"{
            let defaults = UserDefaults.standard
            if defaults.string(forKey: "coop") == nil{
                let url = URL(string: urlString)
                do {
                    let contents = try String(contentsOf: url!)
                    defaults.set(contents, forKey: "coop")
                    webView.loadHTMLString(contents,baseURL:nil)
                } catch {
                    // contents could not be loaded
                }
            }else{
                let html = defaults.string(forKey: "coop")
                webView.loadHTMLString(html!,baseURL:nil)
            }
        }else{
            // 发送网络请求
            let url:URL = URL(string: urlString)!
            let request:URLRequest = URLRequest(url:url)
            webView.loadRequest(request)
        }
        self.view.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goBackView(){
        //let vc = ViewController(nibName: "ViewController", bundle: nil)
        self.navigationController?.popViewController(animated: true);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

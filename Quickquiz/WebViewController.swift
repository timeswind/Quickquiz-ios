//
//  WebViewController.swift
//  Quickquiz
//
//  Created by MINGTIAN YANG on 7/11/16.
//  Copyright © 2016 MINGTIAN YANG. All rights reserved.
//

import UIKit
import WebKit

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var url:String = ""
    var requiredToken = false
    var progBar = UIProgressView()
    
    @IBOutlet var containerView : UIView! = nil
    var webView: WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpProgressBar()
        self.setUpWebView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float((webView?.estimatedProgress)!), animated: true)
        }
        if (webView?.estimatedProgress)! >= 1.0 {
            UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.progBar.alpha = 0.0

                }, completion: { (finished:Bool) in
                    self.progBar.progress = 0
            })
        }
    }
    
    func setUpWebView() {
        webView = WKWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        webView?.navigationDelegate = self
        webView?.UIDelegate = self
        view.addSubview(self.webView!)
        if requiredToken {
            if NSUserDefaults.standardUserDefaults().objectForKey("token") != nil {
                let token = NSUserDefaults.standardUserDefaults().objectForKey("token") as! String
                url = "\(url)&token=\(token)"
                print(url)
            }
        }
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.webView!.loadRequest(urlRequest)
    }
    
    func setUpProgressBar() {
        progBar = UIProgressView(frame: CGRectMake(0, 42, self.view.frame.width, 50))
        progBar.trackTintColor = UIColor.clearColor()
        progBar.progress = 0.0
        progBar.tintColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(122.0/255.0), blue: CGFloat(255.0/255.0), alpha: CGFloat(1.0))
        progBar.tag = 1000
        
        self.navigationController?.navigationBar.addSubview(progBar)
    }

    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
        let subViews = self.navigationController?.navigationBar.subviews
        for subview in subViews!{
            if subview.tag == 1000 {
                subview.removeFromSuperview()
            }
        }
    }
    
}

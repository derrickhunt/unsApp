//
//  ViewController.swift
//  UNS
//
//  Created by Student on 4/30/15.
//  Copyright (c) 2015 Derrick Hunt. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var URLHistory = NSMutableArray()

    @IBOutlet weak var myBackBtn: UIBarButtonItem!
    @IBOutlet weak var myActionBtn: UIBarButtonItem!
    @IBOutlet weak var myToolbar: UIToolbar!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "University News"
        
        //set up web view
        webView = WKWebView()
        webView.navigationDelegate = self
        resizeWebView()
        
        let url = NSURL(string: "http://www.rit.edu/news")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        view.addSubview(webView)
        webView.hidden = true
        
        //handle device rotation
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resizeWebView", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resizeWebView() {
        var navBarOffset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
        var toolBarOffset = myToolbar.frame.height + 1
        webView.frame = CGRectMake(0, navBarOffset, view.frame.width, view.frame.height - navBarOffset - toolBarOffset)
    }
    
    //MARK: - Nav Bar Actions -
    @IBAction func goBack(sender: AnyObject) {
        if (URLHistory.count <= 1) {
            return
        }
        
        //get URL
        let request = NSURLRequest(URL: URLHistory[URLHistory.count - 2] as NSURL)
        
        //update array and button
        URLHistory.removeLastObject()
        URLHistory.removeLastObject()
        if (URLHistory.count <= 1) {
            myBackBtn.enabled = false
        }
        
        //go back
        webView.loadRequest(request)
        
        println(URLHistory)
        println(request)
    }
    
    @IBAction func goShare(sender: AnyObject) {
        let urlString = URLHistory[URLHistory.count - 1] as NSURL
        //let shareString = "RIT News: " + urlString
        
        let activity = UIActivityViewController(activityItems: [urlString], applicationActivities: nil)
        activity.popoverPresentationController?.barButtonItem = sender as UIBarButtonItem //attaches view to btn
        presentViewController(activity, animated: true, completion: nil)
    }
    
    //MARK: - Toolbar Actions -
    @IBAction func goHome(sender: AnyObject) {
        let url = NSURL(string: "http://www.rit.edu/news")
        let request = NSURLRequest(URL: url!)
        
        if (request != webView.URL){
            webView.loadRequest(request)
        }
    }
    
    @IBAction func goMag(sender: AnyObject) {
        let url = NSURL(string: "http://www.rit.edu/news/magazine.php")
        let request = NSURLRequest(URL: url!)
        
        if (request != webView.URL){
            webView.loadRequest(request)
        }
    }
    
    @IBAction func goAth(sender: AnyObject) {
        let url = NSURL(string: "http://www.rit.edu/news/athenaeum.php")
        let request = NSURLRequest(URL: url!)
        
        if (request != webView.URL){
            webView.loadRequest(request)
        }
    }
    
    @IBAction func goSports(sender: AnyObject) {
        let url = NSURL(string: "http://www.ritathletics.com/")
        let request = NSURLRequest(URL: url!)
        
        if (request != webView.URL){
            webView.loadRequest(request)
        }
        
    }
    
    //MARK: - WKNavigation Methods -
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        webView.hidden = true
        myActivityIndicator.hidden = false
        myActivityIndicator.startAnimating()
        
        //update URL list and button
        URLHistory.addObject(webView.URL!)
        if (URLHistory.count > 1) {
            myBackBtn.enabled = true
        }
        
        println(URLHistory)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        myActivityIndicator.stopAnimating()
        
        //update nav title
        if (webView.URL! == "http://www.rit.edu/news") {
            self.title = "University News"
        }
        if (webView.URL! == "http://www.rit.edu/news/magazine.php") {
            self.title = "University Magazine"
        }
        if (webView.URL! == "http://www.rit.edu/athenaeum.php") {
            self.title = "Athenaeum"
        }
        if (webView.URL! == "http://www.ritathletics.com/") {
            self.title = "Athletics"
        }
        
        webView.hidden = false
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        myActivityIndicator.stopAnimating()
        
        //display error message
        let errorMsg = UIAlertView(title: "Error", message: "An error occurred while processing your request. \n\nPlease make sure you are connected to the Internet and try again.", delegate: self, cancelButtonTitle: "Okay")
        errorMsg.show()
        
        //log error to console
        println("Failed to load: \(error)")
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        myActivityIndicator.stopAnimating()
        
        //display error message
        let errorMsg = UIAlertView(title: "Error", message: "An error occurred while processing your request. \n\nPlease make sure you are connected to the Internet and try again.", delegate: self, cancelButtonTitle: "Okay")
        errorMsg.show()
        
        //log error to console
        println("Failed to load: \(error)")
    }


}


//
//  VFGWebViewController.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 7/4/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

@objc public protocol VFGWebViewDelegate: NSObjectProtocol {
    func webView(_ webview: UIWebView, didFailLoadWithError error: Error?)
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    func webViewDidStartLoad(_ webView: UIWebView)
    func webViewDidFinishLoad(_ webView: UIWebView)
}

/**
 Generic View Controller for displaying web contents on a webView
 */
open class VFGWebViewController: UIViewController  {
    
    // MARK: - Constants
    
    static private let storyboardName: String = "VFGWebViewController"
    static private let defaultURLString: String = "https://www.Vodafone.com"
    static public let urlEndString: String = "end.html"
    static fileprivate let campaignSuccessEvent : String = "campaign_success"
    static fileprivate let campaignEventNameKey : String =  "event_name"
    static fileprivate let campaignIdKey : String = "campaign_id"
    fileprivate var timer : Timer = Timer()
    fileprivate let timeoutInterval : TimeInterval = 4
    // MARK: - Outlets
    
    @IBOutlet weak var closeButtonOutlet: UIButton!
    @IBOutlet weak var webView: UIWebView!
    
    
    // MARK: - Actions
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Public Variables
    
    public var campaignId : String?
    
    /**
     The requested URL
     */
    open var url: URL? = URL(string: defaultURLString)
    
    /*
     a boolean to hide the close button in the top right for dismissing the view, default = true
     */
    open var closeButtonIsHidden: Bool = true
    
    /**
     The requested URL
     */
    open weak var delegate: VFGWebViewDelegate?
    
    
    // MARK: - Initialization
    
    /**
     Initialize View Controller of type 'VFGWebViewController'
     
     - Returns: VFGWebViewController instance
     */
    static open func viewController() -> VFGWebViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: VFGCommonUIBundle.bundle())
        return storyboard.instantiateInitialViewController() as! VFGWebViewController
    }
    
    
    // MARK: - View Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadRequest()
    }
    
    
    // MARK: - Setup
    
    private func setupView() {
        
        webView.scrollView.bounces = false
        closeButtonOutlet.isHidden = closeButtonIsHidden
    }
    
    
    // MARK: - Reqeust
    
    private func loadRequest() {
        
        guard let url: URL = self.url else { return }
        
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    
    // MARK: - Network Indicator
    
    fileprivate func shouldShowNetworkIndicator(show: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = show
    }
}

// MARK: - UIWebViewDelegate

extension VFGWebViewController: UIWebViewDelegate {
    @objc private func webviewDidTimeout(){
        DispatchQueue.main.async {
            self.webView.stopLoading()
        }
    }
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        timer = Timer.scheduledTimer(timeInterval: self.timeoutInterval, target: self, selector: #selector(webviewDidTimeout), userInfo: nil, repeats: false)
        return self.delegate?.webView(webView, shouldStartLoadWith: request, navigationType: navigationType) ?? true
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        shouldShowNetworkIndicator(show: false)
        
        timer.invalidate()
        
        self.delegate?.webView(webView, didFailLoadWithError: error)
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        shouldShowNetworkIndicator(show: true)
        self.delegate?.webViewDidStartLoad(webView)
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        timer.invalidate()
        shouldShowNetworkIndicator(show: false)
        
        // Send campaign success event
        if let url = webView.request?.url,
            let campaignId = self.campaignId {
            if url.absoluteString.range(of:VFGWebViewController.urlEndString ) != nil {
                VFGAnalytics.trackEvent(VFGWebViewController.campaignSuccessEvent, dataSources:
                    [VFGWebViewController.campaignEventNameKey : VFGWebViewController.campaignSuccessEvent,
                     VFGWebViewController.campaignIdKey : campaignId])
            }
        }
        delegate?.webViewDidFinishLoad(webView)
    }
}


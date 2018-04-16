//
//  HomeViewController.swift
//  VFGProof
//
//  Created by vodafone on 13/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGVoV

class HomeViewController: BaseViewController, VFGVoiceOfVodafoneViewDelegate {
    
    // MARK: - Properties
    fileprivate var vovDataSource : [VFGVovBaseModel] = [VFGVovBaseModel]()
    
    override var rootView: HomeView? {
        get {
            if _rootView == nil {
                let rootView:HomeView = HomeView()
                _rootView = rootView
            }
            
            return _rootView as? HomeView
        }
    }
    
    // MARK: - Data load
    
    override func viewDidLoad() {
        
        loadWelcomeMessageCell()
        
        rootView?.vovView.setup(dataArray: vovDataSource, sender: self, animated: false)
    }
    
    private func loadWelcomeMessageCell() {
        
        // fill VFGVoVModel with required data
        let username = "Jack"
        let appname = "MyVodafone POC"
        
        let firstIntervalStart = convertIntervalStringToVFGTime(timeIntervalString: "00:00")
        let firstIntervalEnd = convertIntervalStringToVFGTime(timeIntervalString:"11:59")
        
        let secondIntervalStart = convertIntervalStringToVFGTime(timeIntervalString:"12:00")
        let secondIntervalEnd = convertIntervalStringToVFGTime(timeIntervalString:"17:59")
        
        let thirdIntervalStart = convertIntervalStringToVFGTime(timeIntervalString:"18:00")
        let thirdIntervalEnd = convertIntervalStringToVFGTime(timeIntervalString:"23:59")
        
        let firstIntervalGreeting = NSLocalizedString("good_morning", comment: "")
        let secondIntervalGreeting = NSLocalizedString("good_afternoon", comment: "")
        let thirdIntervalGreeting = NSLocalizedString("good_evening", comment: "")
        let welcomeText = NSLocalizedString("welcome_to", comment: "")
        
        let welcomeMessage = VFGVovWelcomeMessage(username: username,
                                                  appname: appname,
                                                  welcomeMessage: welcomeText,
                                                  morningGreetingModel: VFGVovGreetingModel.init(startInterval: firstIntervalStart, endInterval: firstIntervalEnd, greetingText: firstIntervalGreeting),
                                                  afternoonGreetingModel: VFGVovGreetingModel.init(startInterval: secondIntervalStart, endInterval: secondIntervalEnd, greetingText: secondIntervalGreeting),
                                                  eveningGreetingModel: VFGVovGreetingModel.init(startInterval: thirdIntervalStart, endInterval: thirdIntervalEnd, greetingText: thirdIntervalGreeting))
        
        vovDataSource.append(welcomeMessage)
    }
    
    // MARK: - Private methods
    
    private func convertIntervalStringToVFGTime(timeIntervalString: String) -> VFGTime {
        let colonOperator: String = ":"
        
        let timeInterval = timeIntervalString.components(separatedBy: colonOperator)
        if let hours = Int(timeInterval.first!), let minutes = Int(timeInterval.last!) {
            return VFGTime(hours: hours, minutes: minutes)
        }
        
        return VFGTime(hours: 0, minutes: 0)
    }
    
    // MARK: - VFGVoiceOfVodafoneViewDelegate
    
    func maxNumberOfMessages() -> Int {
        return 5
    }
    
    func leftButtonDidSelected(_ index: Int) {
        
    }
    
    func rightButtonDidSelected(_ index: Int) {
        
    }
}

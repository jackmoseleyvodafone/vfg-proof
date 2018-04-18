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
    
    override func loadData() {
        
        // load welcome message
        let welcomeMessage: VFGVovBaseModel = VoVRepository.requestVoVWelcomeMessage()
        vovDataSource.append(welcomeMessage)
        
        // load campaign messages
//        let campaignMessages: [VFGVovGeneralModel] = VoVRepository.requestVoVCampaignMessages()
//        vovDataSource.append(contentsOf: campaignMessages as [VFGVovBaseModel])
        
        rootView?.vovView.setup(dataArray: vovDataSource, sender: self, animated: false)
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

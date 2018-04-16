//
//  VFGCustomView.swift
//  VFGVoV
//
//  Created by Mohamed Magdy on 5/23/17.
//  Copyright © 2017 Mohamed Magdy. All rights reserved.
//

import UIKit
import VFGCommonUtils

let generalAnimationDuration: TimeInterval = 0.6
let baseViewInitialScale    : CGFloat = 0.5
let baseViewFinalScale      : CGFloat = 1.05

public class VFGVoVBaseView: UIView {
    
    var baseViewAnimationScalingUpCompletion: (()->Void)?
    func loadFromNib() {
        let contentView = UINib(nibName: self.theClassName, bundle: VFGVoVBundle.bundle()).instantiate(withOwner: self, options: nil).first as? UIView
        guard let content = contentView else {
            VFGLogger.log("failed to get content view")
            return
        }
        content.frame = bounds
        self.addSubview(content)

        self.clipsToBounds = false
        self.layoutIfNeeded()
    }
    
    /* this is for any message animation*/
    public func startVoiceOfVodafoneAnimationForView(_ view: UIView) {
        view.alpha = 0.0
        view.transform = CGAffineTransform(scaleX: baseViewInitialScale, y: baseViewInitialScale)
        
        UIView.animate(withDuration: generalAnimationDuration, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform(scaleX: baseViewFinalScale, y: baseViewFinalScale)
        }, completion: { [weak self] done in
            guard let strongSelf = self else {
                VFGLogger.log("failed to get self ")
                return
            }
            strongSelf.baseViewAnimationScalingUpCompletion?()
            UIView.animate(withDuration: generalAnimationDuration, animations: {
                view.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
    
}


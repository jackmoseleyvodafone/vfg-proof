//
//  AdobeTargetHandler.swift
//  VFGDataAccess
//
//  Created by Ehab Alsharkawy on 7/4/17.
//  Copyright © 2017 VFG. All rights reserved.
//
import VFGCommonUtils
internal struct AdobeTargetConstants {
    
    static let triggerGetOffersEventName : String = "DASHBOARD_REFRESHED"
    static let remoteCommandPayloadKey : String = "requestPayload"
    
    internal struct TealiumParameterkey{
        static let billDueDate : String = "visitor_bill_payment_due_date"
        static let creditBalance : String = "visitor_credit_balance"
        static let dataUsageBalance : String = "visitor_data_usage_balance"
        static let dataUsageLimit : String = "visitor_data_usage_limit"
        static let dataUsed : String = "visitor_data_usage_used"
        static let dateOfBirth : String = "visitor_date_of_birth"
        static let firstName : String = "visitor_first_name"
        static let lastName : String = "visitor_last_name"
        static let remainingDuration : String = "visitor_subscription_remaining_duration"
        static let subscriptionName : String = "visitor_subscription_name"
        static let subscriptionType : String = "visitor_subscription_type"
        static let screenName : String = "DASHBOARD_REFRESHED"
    }
    
    internal struct AdobeTargetCampaignRequest {
        static let bodyKey : String = "post_json"
        static let urlKey : String = "post_url"
        static let responseContentKey : String = "content"
    }
    
    internal struct TealiumAdobeTargetResponseEvent {
        static let tealiumEventAdobeContentKey : String = "messages"
        static let tealiumEventName : String = "adobeTargetResponse"
    }
}
/**
 *  Adobe Target Handler is used for getting offers from tealium for Voice of Vodafone Component
 *
 */
public final class AdobeTargetHandler: NSObject {
    
    /**
     *  getOffers method to retrieve offers from Tealium
     *  @param requestModel of type VFGCampaignRequestModel
     */
    
    public static let sharedInstance: AdobeTargetHandler = AdobeTargetHandler()
    private override init() {
        super.init()
    }
    public func triggerGetOffersEvent(requestModel : VFGCampaignRequestModel) {
        
        let input : [String : String] = [
            AdobeTargetConstants.TealiumParameterkey.billDueDate : requestModel.billDueDate ?? "",
            AdobeTargetConstants.TealiumParameterkey.creditBalance : requestModel.creditBalance ?? "",
            AdobeTargetConstants.TealiumParameterkey.dataUsageBalance : requestModel.dataUsageBalance ?? "",
            AdobeTargetConstants.TealiumParameterkey.dataUsageLimit : requestModel.dataUsageLimit ?? "",
            AdobeTargetConstants.TealiumParameterkey.dataUsed : requestModel.dataUsed ?? "",
            AdobeTargetConstants.TealiumParameterkey.dateOfBirth : requestModel.dateOfBirth ?? "true",
            AdobeTargetConstants.TealiumParameterkey.firstName : requestModel.firstName ?? "",
            AdobeTargetConstants.TealiumParameterkey.lastName : requestModel.lastName ?? "",
            AdobeTargetConstants.TealiumParameterkey.remainingDuration : requestModel.remainingDuration ?? "",
            AdobeTargetConstants.TealiumParameterkey.subscriptionName : requestModel.subscriptionName ?? "",
            AdobeTargetConstants.TealiumParameterkey.subscriptionType : requestModel.subscriptionType ?? ""]
        VFGTealiumHelper.sharedInstance.onGetOffersCommand = { (theResponse : Any?) -> Void in
            
            if let receivedData = ((theResponse as AnyObject).value(forKey:AdobeTargetConstants.remoteCommandPayloadKey) as? [String : AnyObject]) {
                self.downloadAdobeCampaign(receivedData)
            }
            else {
                VFGLogger.log("Can't ready getOffers remote command payload!")
            }
        }
        
        VFGAnalytics.trackEvent(AdobeTargetConstants.triggerGetOffersEventName, dataSources: input )
    }
    
    public func downloadAdobeCampaign(_ downloadDetails : [String : AnyObject]) {
        VFGLogger.log("AdobeTargetHandler did reach downloadAdobeCampaign with downloadDetails \(downloadDetails)")
        
        if let requestURL : String = (downloadDetails[AdobeTargetConstants.AdobeTargetCampaignRequest.urlKey] as? String) {
            VFDAF.getDAFManager().request(url: requestURL, requestMethod: .post, parameters: (downloadDetails[AdobeTargetConstants.AdobeTargetCampaignRequest.bodyKey] as? [String : AnyObject]), headers: nil, success: { (response : Any?) in
                if let response : [String : AnyObject] = response as? [String : AnyObject] {
                    if let adobeTargetResponse : String = response[AdobeTargetConstants.AdobeTargetCampaignRequest.responseContentKey] as? String {
                        let responseString : String = "[" + adobeTargetResponse + "]"
                        VFGLogger.log("AdobeTargetHandler did recieve responseString from downloadAdobeCampaign \(responseString)")
                        // Campaign downloaded. Send event with campaign details to Tealium
                        VFGAnalytics.trackEvent(AdobeTargetConstants.TealiumAdobeTargetResponseEvent.tealiumEventName, dataSources:[AdobeTargetConstants.TealiumAdobeTargetResponseEvent.tealiumEventAdobeContentKey : responseString])
                    }
                    else {
                        VFGLogger.log("Missing key (" + AdobeTargetConstants.AdobeTargetCampaignRequest.responseContentKey + ") in Adobe Target response")
                    }
                }
                else {
                    VFGLogger.log("Cannot parse Adobe Target response")
                }
            }, failure: { (error : NSError) in
                VFGLogger.log("Cannot download Adobe Target campaing. Error:" + error.localizedDescription)
            })
        }
        else {
            VFGLogger.log("Adobe Target URL not present in Tealium response")
        }
    }
}


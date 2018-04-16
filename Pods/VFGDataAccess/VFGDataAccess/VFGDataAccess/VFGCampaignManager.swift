//
//  VFGCampaignManager.swift
//  VFGDataAccess
//
//  Created by Ehab Alsharkawy on 04/07/2017.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import VFGCommonUtils
import VFGCommonUI
public typealias VFGCampaignManagerSuccessClosure = (Any?) -> Void
public typealias VFGCampaignErrorClosure = (NSError) -> Void

internal struct CampaignManagerConstants {
    internal struct Error {
        static let domain : String = "VFGCampaignManager"
        static let code : Int = -9890 // Random code number
        internal struct Description {
            static let emptyList : String = "list is empty"
            static let indexOverListCount : String = "index is greater than list count"
        }
    }

    internal struct Success {
        internal struct Description {
            static let deleteMessage : String = "Message is Deleted Successfully"
            static let addMessages : String = "Message is added Successfully"
        }
    }

    fileprivate static let remoteCommandPayloadKey : String = "requestPayload"
    fileprivate static let visitorCampaignsKey : String = "visitor_campaigns"
    fileprivate static let campaignIdKey : String = "campaignId"
    fileprivate static let dateLastSeenKey : String = "date_last_seen"
    fileprivate static let dateDismissedKey : String = "date_dismissed"
    fileprivate static let dateAcceptedKey : String = "date_accepted"
    fileprivate static let dateCompletedKey : String = "date_completed"
    static let persistentMessagesKey = "persistentMessagesKey"
}

/**
 *  VFGCampaignManager is Singelton class manager of campaigns that used in Vov
 *
 - campaignMessageslist : For List of campaign Messages
 */

public final class VFGCampaignManager : NSObject {

    private let greekLanguagePrefix : String = "el"
    private var counter : Int = 0
    internal var messageCounter : Int {
        get {
            self.counter += 1
            return self.counter
        }
    }
    public var campaignReceivedClosure : VFGCampaignManagerSuccessClosure?

    public static let sharedInstance: VFGCampaignManager = VFGCampaignManager()
    /**
     *   campaignMessageslist: Array variable of all campaign messages
     *
     */
    public var campaignMessageslist : Array<VovMessage>? = []
    private override init() {
        VFGTealiumHelper.sharedInstance.onGetOffersCommand = { (theResponse : Any?) -> Void in

            if let receivedData : [String : AnyObject] = ((theResponse as AnyObject).value(forKey:AdobeTargetConstants.remoteCommandPayloadKey) as? [String : AnyObject]) {
                AdobeTargetHandler.sharedInstance.downloadAdobeCampaign(receivedData)
            }
            else {
                VFGLogger.log("Can't ready getOffers remote command payload!")
            }
        }

        VFGTealiumHelper.sharedInstance.onNewMessagesCommand = { (response: NSObject?) -> Void in
            if let requestPayload = (response?.value(forKey:AdobeTargetConstants.remoteCommandPayloadKey) as? [String : AnyObject]) {
                VFGCampaignManager.sharedInstance.parse(campaignJsonResponse: requestPayload, success: { (result : Any?) in
                    VFGLogger.log("New message remote command parsed with success")
                    VFGCampaignManager.sharedInstance.campaignReceivedClosure?(result)

                    // Save visitorCampaigns in persistant data
                    if let visitorCampaigns : [[String : String]] = requestPayload[CampaignManagerConstants.visitorCampaignsKey] as? [[String : String]] {
                        
                        let value = VFGCampaignManager.sharedInstance.convertToString(array: visitorCampaigns)!
                        let key = CampaignManagerConstants.visitorCampaignsKey
                        let finalDic = [key: value]
                        VFGTealiumHelper.sharedInstance.addPersistentDataSources(finalDic)
                    }

                }, failure: { (error : NSError) in
                    VFGLogger.log("New message remote command parsing failed with error:" + error.description)
                })
            }
        }
        
        if let savedData = UserDefaults.standard.object(forKey: CampaignManagerConstants.persistentMessagesKey) as? Data {
            if let savedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                var updatedMessages = [VovMessage]()
                for message: VovMessage in savedMessages {
                   
                    if message.autoExpireAsInt != nil && message.autoExpireAsInt! > 0 && message.dateReceived != nil  {
                        let expirationDate = message.dateReceived?.addingTimeInterval(TimeInterval(message.autoExpireAsInt! * 60))
                        if expirationDate! > Date() {
                            campaignMessageslist!.append(message)
                            updatedMessages.append(message)
                        }
                        let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: updatedMessages)
                        UserDefaults.standard.set(updatedData, forKey: CampaignManagerConstants.persistentMessagesKey)
                    }else if message.autoExpireAsInt! == -1  && message.autoExpireAsInt != nil{
                        
                        updatedMessages.append(message)
                        let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: updatedMessages)
                        UserDefaults.standard.set(updatedData, forKey: CampaignManagerConstants.persistentMessagesKey)
                        
                    }
                }
            }
        }
    }
    
    //MARK: - private utilities methods
    private func convertToString(array: [[String: Any]]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    private func convertToDictionary(text: String) -> [[String: Any]]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String:Any]]
                return json
            } catch {
                return nil
            }
        }
        return nil
    }
    /**
     *  fetchCurrentOffersFromAdobeTargetByDashboardRefreshedEvent method to retrieve offers
     *  @param requestModel of type VFGCampaignRequestModel
     */
    public func fetchCurrentOffersFromAdobeTargetByDashboardRefreshedEvent(requestModel : VFGCampaignRequestModel) {
        AdobeTargetHandler.sharedInstance.triggerGetOffersEvent(requestModel: requestModel)
    }

    /**
     *  deleteMessage method to delete offers from messageList
     *  @param index of type Int
     *  @return VFGCampaignManagerSuccessClosure : call back response with String success message
     *  @return VFGCampaignErrorClosure : call back NSError response
     */
    public func deleteMessage(index: Int, success:@escaping VFGCampaignManagerSuccessClosure, failure:  @escaping VFGCampaignErrorClosure){

        if let messagesList : Array <VovMessage> = self.campaignMessageslist {
            if messagesList.count > index {
                self.campaignMessageslist?.remove(at: index)
                success(CampaignManagerConstants.Success.Description.deleteMessage)
            }else{
                let error = NSError.init(domain: CampaignManagerConstants.Error.Description.emptyList, code: CampaignManagerConstants.Error.code, userInfo: [NSLocalizedDescriptionKey: CampaignManagerConstants.Error.Description.indexOverListCount])
                failure(error)
            }
        }
        else{
            let error = NSError.init(domain: CampaignManagerConstants.Error.domain, code: CampaignManagerConstants.Error.code, userInfo: [NSLocalizedDescriptionKey: CampaignManagerConstants.Error.Description.indexOverListCount])
            failure(error)
        }
    }

    /**
     *  addMessages method to add offers to messageList
     *  @param newlist of type Array of VovMessage
     *  @return VFGCampaignManagerSuccessClosure : call back response with String success message
     *  @return VFGCampaignErrorClosure : call back NSError response
     */
    public func addMessages(newlist : Array<VovMessage>, success: VFGCampaignManagerSuccessClosure?, failure:   VFGCampaignErrorClosure?){
        if var messagesList : Array <VovMessage> =  self.campaignMessageslist {
            messagesList.append(contentsOf: newlist)
            self.campaignMessageslist?.append(contentsOf: newlist)
        }
        success?(CampaignManagerConstants.Success.Description.addMessages)
    }

    /**
     *  Camapign response JSON parsing method which populates internal campaign messages list.
     *
     *  @param campaignJsonResponse JSON data model to parse
     *  @return VFGCampaignManagerSuccessClosure : call back response with String success message
     *  @return VFGCampaignErrorClosure : call back NSError response
     */
    public func parse(campaignJsonResponse: Any, success:@escaping VFGCampaignManagerSuccessClosure, failure: VFGCampaignErrorClosure) {
        ParserManager.parse(modelObject: VFGCampaignResponseModel, json: campaignJsonResponse, success: { (theResponse : Any?) -> Void  in

            let response : VFGCampaignResponseModel? = theResponse as? VFGCampaignResponseModel

            if let campaignArray : [VovRequestPayload] = response?.vovRequestPayload {
                for campaign in campaignArray {
                    // for now we will use primary language for only for greece, this will change in the future.
                    var campaignMsg = campaign.primary

                    if !VFGConfiguration.locale.identifier.hasPrefix(greekLanguagePrefix) {
                        campaignMsg = campaign.secondary
                    }
                    if let campaignMessage : VovMessage = campaignMsg {

                        switch campaignMessage.deliveryMethod {
                        case 0?: //VOV
                            handleVOVMessage(campaignMessage)
                            break
                        case 2?: //Nudge
                            VFGRootViewController.shared.showNudgeView(title: campaignMessage.messageTitle, description: campaignMessage.messageBody!, primaryButtonTitle: campaignMessage.dismissButtonText, secondaryButtonTitle: "", primaryButtonAction: {
                                VFGRootViewController.shared.hideNudgeView()
                                guard let urlString = campaignMessage.url else {
                                    return //be safe
                                }
                                let url: URL = URL(string: urlString)!
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }, secondaryButtonAction: {}, closeAction: {
                                VFGRootViewController.shared.hideNudgeView()
                            })
                            break
                        case 3?: //Toast
                            VFGSnackbar().show(message: campaignMessage.messageBody!, duration: 5, image: nil)
                            break
                        case 4?: //Interstitial
                            VFGAlertViewController.showAlert(title: campaignMessage.messageTitle!, alertMessage: campaignMessage.messageBody!, alertSubmessage: "", primaryButtonText: campaignMessage.dismissButtonText!, primaryButtonAction: {
                            }, secondaryButtonText: "", secondaryButtonAction: {
                            }, tertiaryButtonText: "", tertiaryButtonAction: {
                            }, closeButtonAction: {
                            }, icon: nil, showCloseButton: true)
                            break
                        default:
                            handleVOVMessage(campaignMessage)
                            break
                        }
                    }
                }
            }

            success(theResponse)
        }, failure: failure)
    }

    //Handling VOV messages
    private func handleVOVMessage (_ campaignMessage: VovMessage) {
       

        
        if campaignMessage.autoExpire != nil {
            
            campaignMessage.autoExpireAsInt = Int(campaignMessage.autoExpire!)
        }
        
        campaignMessage.dateReceived = Date()
       
        
        if campaignMessage.autoExpireAsInt != nil && campaignMessage.autoExpireAsInt != 0 {
            var savedMessages: [VovMessage] = [VovMessage]()
            if let savedData = UserDefaults.standard.object(forKey: CampaignManagerConstants.persistentMessagesKey) as? Data {
                if let encodedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                    savedMessages = encodedMessages
                }
            }
            savedMessages.append(campaignMessage)
            let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedMessages)
            UserDefaults.standard.set(updatedData, forKey: CampaignManagerConstants.persistentMessagesKey)
            UserDefaults.standard.synchronize()
        } else {
            self.campaignMessageslist?.append(campaignMessage)
        }
    }
    
    // Method to delete specific persisted VOV Message from local storage
    public func deleteVOVMessage (_ campaignMessage: VovMessage) {
        
        var savedMessages: [VovMessage] = [VovMessage]()
        if let savedData = UserDefaults.standard.object(forKey: CampaignManagerConstants.persistentMessagesKey) as? Data {
            if let encodedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                savedMessages = encodedMessages
            }
        }
        
        //delete vov by campaign id
        if campaignMessage.campaignId != nil && campaignMessage.campaignId != "0" {
            
            
            for message in savedMessages{
                
                
                if message.campaignId == campaignMessage.campaignId{
                    
                    deleteCampaignMessagesWithCampaignID(campaignID: message.campaignId!)
                }
                
                
            }
        //delete vov by message id
        }else if(campaignMessage.messageId != 0){
            
            for message in savedMessages{
                
                
                if message.messageId == campaignMessage.messageId{
                    
                    deleteCampaignMessageWithID(messageID: message.messageId)
                }
                
                
            }
            
        }
      
    }
    
    private func deleteCampaignMessageWithID (messageID : Int){
        
        
        var savedMessages: [VovMessage] = [VovMessage]()
        if let savedData = UserDefaults.standard.object(forKey: CampaignManagerConstants.persistentMessagesKey) as? Data {
            if let encodedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                savedMessages = encodedMessages
            }
        }
        
        
        for message in savedMessages {
            
            
            if message.messageId == messageID{
                
                savedMessages = savedMessages.filter { $0 != message }
                
            }
            
        }
        
        let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedMessages)
        UserDefaults.standard.set(updatedData, forKey: CampaignManagerConstants.persistentMessagesKey)
        UserDefaults.standard.synchronize()
        
        
        
        
    }
    
    private func deleteCampaignMessagesWithCampaignID (campaignID : String){
        
        var savedMessages: [VovMessage] = [VovMessage]()
        if let savedData = UserDefaults.standard.object(forKey: CampaignManagerConstants.persistentMessagesKey) as? Data {
            if let encodedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                savedMessages = encodedMessages
            }
        }
        
        
        for message in savedMessages {
            
            
            if message.campaignId == campaignID{
                
                savedMessages = savedMessages.filter { $0 != message }
                
            }
            
        }
        
        let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedMessages)
        UserDefaults.standard.set(updatedData, forKey: CampaignManagerConstants.persistentMessagesKey)
        UserDefaults.standard.synchronize()
        
    }
    
    //Method to delete all persisted VOV Messages from local storage
    public func deleteAllCampainMessages () {
        
        
        var savedMessages: [VovMessage] = [VovMessage]()
        if let savedData = UserDefaults.standard.object(forKey: CampaignManagerConstants.persistentMessagesKey) as? Data {
            if let encodedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                savedMessages = encodedMessages
            }
        }
        
        savedMessages = [VovMessage]()
        let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: savedMessages)
        UserDefaults.standard.set(updatedData, forKey: CampaignManagerConstants.persistentMessagesKey)
        UserDefaults.standard.synchronize()
        
        
    }
    
    /**
     *  Updates selected visitorCampaigns fields in volatile data source.
     *
     *  @param campaignId Campaign ID to update
     *  @param dateLastSeen Optional new value for date last seen field
     *  @param dateDismissed Optional new value for date dismissed field
     *  @param dateAccepted Optional new value for date accepted field
     *  @param dateCompleted Optional new value for date completed field
     */
    public func updateVisitorCampaigns(campaignId : String, dateLastSeen : String? = nil, dateDismissed : String? = nil, dateAccepted : String? = nil, dateCompleted : String? = nil) {
        
        print("update visitor campaings called")
        guard let stringVisitorCampaigns = VFGTealiumHelper.sharedInstance.getPersistentDataSources()?[CampaignManagerConstants.visitorCampaignsKey] as? String else {
            VFGLogger.log("Cannot unwrap visitorCampaigns")
            return
            

            
        }
        var visitorCampaigns = convertToDictionary(text: stringVisitorCampaigns) as? [[String: Any]]
      
        var index = 0
        for campaign in visitorCampaigns! {

            if campaign[CampaignManagerConstants.campaignIdKey] as? String ==  campaignId {
                var updatedEntry = campaign
                if let dateLastSeen = dateLastSeen {
                    updatedEntry[CampaignManagerConstants.dateLastSeenKey] = dateLastSeen
                }
                if let dateDismissed = dateDismissed {
                    updatedEntry[CampaignManagerConstants.dateDismissedKey] = dateDismissed
                }
                if let dateAccepted = dateAccepted {
                    updatedEntry[CampaignManagerConstants.dateAcceptedKey] = dateAccepted
                }
                if let dateCompleted = dateCompleted {
                    updatedEntry[CampaignManagerConstants.dateCompletedKey] = dateCompleted
                }
                visitorCampaigns![index] = updatedEntry
            }
            
            index = index + 1
            
        }
        VFGTealiumHelper.sharedInstance.addPersistentDataSources([CampaignManagerConstants.visitorCampaignsKey : self.convertToString(array: visitorCampaigns!) as! String])
    }
}

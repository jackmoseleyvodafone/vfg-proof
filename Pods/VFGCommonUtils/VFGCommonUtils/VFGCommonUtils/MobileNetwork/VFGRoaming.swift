//
//  VFGRoaming.swift
//  VFGCommonUtils
//
//  Created by kasa on 13/01/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import CoreTelephony

@objc public class VFGRoaming: NSObject {

    static private let operatorPListSymLinkPath : String = "/var/mobile/Library/Preferences/com.apple.operator.plist"
    static private let deviceCarrierPrefix : String = "device+carrier+"

    static private func isMobileCountryCodeBermuda(_ mcc : String) -> Bool {
        return mcc == "310" || mcc == "338" || mcc == "350"
    }

    static private func isMobileCountryCodeIndia(_ mcc : String) -> Bool {
        return mcc == "404" || mcc == "405"
    }

    static private func isMobileCountryCodeJapan(_ mcc : String) -> Bool {
        return mcc == "440" || mcc == "441"
    }

    static private func isMobileCountryCodeKosovo(_ mcc : String) -> Bool {
        return mcc == "212" || mcc == "293"
    }

    static private func isMobileCountryCodeTurksAndCaicosIslands(_ mcc : String) -> Bool {
        return mcc == "338" || mcc == "376"
    }

    static private func isMobileCountryCodeUnitedKingdom(_ mcc : String) -> Bool {
        return mcc == "234" || mcc == "235"
    }

    static private func isMobileCountryCodeUnitedStates(_ mcc : String) -> Bool {
        return mcc == "310" || mcc == "311" || mcc == "312" || mcc == "313" || mcc == "316"

    }

    static private func mobileCountryCodesAreEqual(_ codeOne : String,_ codeTwo : String) -> Bool {

        if (codeOne == codeTwo) {
            return true
        }

        //Special cases based on https://en.wikipedia.org/wiki/Mobile_country_code
        if isMobileCountryCodeBermuda(codeOne) && isMobileCountryCodeBermuda(codeTwo) {
            return true
        }

        if isMobileCountryCodeIndia(codeOne) && isMobileCountryCodeIndia(codeTwo) {
            return true
        }

        if isMobileCountryCodeJapan(codeOne) && isMobileCountryCodeJapan(codeTwo) {
            return true
        }

        if isMobileCountryCodeKosovo(codeOne) && isMobileCountryCodeKosovo(codeTwo) {
            return true
        }

        if isMobileCountryCodeTurksAndCaicosIslands(codeOne) && isMobileCountryCodeTurksAndCaicosIslands(codeTwo) {
            return true
        }

        if isMobileCountryCodeUnitedKingdom(codeOne) && isMobileCountryCodeUnitedKingdom(codeTwo) {
            return true
        }

        if isMobileCountryCodeUnitedStates(codeOne) && isMobileCountryCodeUnitedStates(codeTwo) {
            return true
        }

        return false
    }

    /**
     Determines whether device is using international roaming.
     This is NOT using official Apple API, use with caution.
     Local roaming is filtered out because the current approach could yield false positives
     
     @return NSNumber with possible values true, false or nil for undefined (missing simcard)
     */
    @objc static public func isInternationalRoamingActive() -> NSNumber? {
        if !VFGEnvironment.isSimulator() {
            let providerNetworkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
            let provider : CTCarrier? = providerNetworkInfo.subscriberCellularProvider
            let simCardCountryCode : String? = provider?.mobileCountryCode

            if let simCardCountryCode : String = simCardCountryCode {
                do {
                    let operatorPath : String = try FileManager.default.destinationOfSymbolicLink(atPath: operatorPListSymLinkPath)
                    let operatorPathComponents : [String] = operatorPath.components(separatedBy: "/")

                    let minimalNumberOfExpectedNumberOfPathComponents : Int = 7
                    let mobileCountryCodeLength = 3

                    //Unexpected => undefined result
                    if (operatorPathComponents.count < minimalNumberOfExpectedNumberOfPathComponents) {
                        VFGLogger.log(component: VFGCommonUtilsBundle.bundle(),
                                      "Path under operator symbolic link is not either of these:\n" +
                                      "/System/Library/Carrier Bundles/iPhone/23415/carrier.plist\n" +
                                      "/var/mobile/Library/Carrier Bundles/iPhone/60202/carrier.plist\n" +
                                      "/var/mobile/Library/Carrier Bundles/Overlay/device+carrier+26002+N42+26.0.plist")
                        return nil
                    }

                    var operatorCountryCode : String?

                    let lastComponentPathIndex = operatorPathComponents.count - 1;
                    let lastButOneComponentPathIndex = operatorPathComponents.count - 2;

                    if (operatorPathComponents[lastComponentPathIndex] == "carrier.plist" ) {
                        operatorCountryCode = operatorPathComponents[lastButOneComponentPathIndex].substring(to: operatorPathComponents[lastButOneComponentPathIndex].index(deviceCarrierPrefix.startIndex, offsetBy: mobileCountryCodeLength))
                    } else if operatorPathComponents[lastComponentPathIndex].hasPrefix(deviceCarrierPrefix) {
                        if (operatorPathComponents[lastComponentPathIndex].contains("Unknown.bundle")) {
                            
                            let carrierPListSymLinkPath = "/var/mobile/Library/Preferences/com.apple.carrier.plist"
                            let operatorPListSymLinkPath = "/var/mobile/Library/Preferences/com.apple.operator.plist"
                            
                            let fileManager = FileManager.default
                            
                            var carrierPListPath: String = "carrierPListPath"
                            var operatorPListPath: String = "operatorPListPath"
                            
                            do {
                                carrierPListPath = try fileManager.destinationOfSymbolicLink(atPath: carrierPListSymLinkPath)
                            } catch {
                                return nil
                            }
                            
                            do {
                                operatorPListPath = try fileManager.destinationOfSymbolicLink(atPath: operatorPListSymLinkPath)
                            } catch {
                                return nil
                            }
                            return NSNumber(booleanLiteral: !(carrierPListPath == operatorPListPath))
                        } else {
                            let index : String.Index = deviceCarrierPrefix.index(deviceCarrierPrefix.startIndex, offsetBy: deviceCarrierPrefix.characters.count)
                            let operatorCountryCodeOperatorMobileNetworkCode : String = String((operatorPathComponents[lastComponentPathIndex].substring(from: index) as NSString).integerValue)

                            operatorCountryCode = operatorCountryCodeOperatorMobileNetworkCode.substring(to: operatorCountryCodeOperatorMobileNetworkCode.index(operatorCountryCodeOperatorMobileNetworkCode.startIndex, offsetBy: mobileCountryCodeLength))
                        }
                    }

                    if let operatorCountryCode : String = operatorCountryCode {
                        return NSNumber(booleanLiteral: !self.mobileCountryCodesAreEqual(simCardCountryCode, operatorCountryCode))
                    }
                    
                } catch {
                    return nil
                }
            }
            
        }
        return nil
    }
}

//
//  BWFeedbackModel.swift
//  BWReportProblem
//
//  Created by raj on 16/09/20.
//  Copyright © 2020 Bluewhale. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

public class BWFeedbackModel {
    
  
    var attachments: UIImage?
    
    var deviceModel: String = UIDevice.modelName
    var deviceOs: String = UIDevice.current.systemVersion
    
    var appName: String = Bundle.main.name
    var appVersion: String = Bundle.main.releaseVersionNumber
    var appBuild: String = Bundle.main.buildVersionNumber
    
    static func isInternetConnected() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}

struct WebServiceCall {
    
    static let KContentType = "Content-Type"
    static let KContentValuejson = "application/json"
    static let KContentValueoctet = "application/octet-stream"
    static let kAuthorization = "Authorization"
    static let KbaseURL = "https://tracker.bluewhaleapps.com/" //
    static let KAuthorizationToken = "Basic QW5vbnltb3VzOlRlc3RAMTIzNDU2" //
    
}


struct ApiMethodName {
    
    static let kUpload = "uploads.json?"
    static let kIssue = "issues.json"
    static let kVideoname = "filename=attachment.mp4"
    static let kImagename = "filename=attachment.jpg"
    
    
}

struct InternetAlert {
    static let kInternetMessage = "Please check Internet connection."
}


enum AppStoryboard : String {
    case Main = "Main"
    
      // MARK: - Declaration
    var instance : UIStoryboard {
        let bundle = Bundle(for: BWFeedback.self)
        return UIStoryboard(name: self.rawValue, bundle: bundle)
    }
    
}

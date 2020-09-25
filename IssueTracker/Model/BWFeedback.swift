//
//  BWFeedback.swift
//  BWReportProblem
//
//  Created by Bluewhale-iOS-Team on 16/09/20.
//  Copyright © 2020 Bluewhale. All rights reserved.
//

import Foundation
import UIKit

public class BWFeedback {
    
    static public let shared: BWFeedback = BWFeedback()
    
    public var recipients: [String] = []
    public var title: String = "Report a problem"
    public var sendButtonTitle = "Send"
    public var cancelButtonTitle = "Cancel"
    public var navigationController = UINavigationController()
    
    public func present(_ sender: UIViewController, _ projectID: String, _ Build_Number: String, _ Device_Info: String, _ ReportedBy: String, _ Environment: String, _ fixed_version_id: String) {
        
        let storyboard = AppStoryboard.Main.instance
        let viewController = storyboard.instantiateViewController(withIdentifier: "BWFeedbackViewController") as! BWFeedbackViewController
        viewController.strProject_id = projectID
        viewController.strBuild_Number = Build_Number
        viewController.strDevice_Info = Device_Info
        viewController.strReportedBy = ReportedBy
        viewController.strEnvironment = Environment
        viewController.strFixed_version_id = fixed_version_id

         let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        sender.present(navigationController, animated: true) {
            
        }
    }
}

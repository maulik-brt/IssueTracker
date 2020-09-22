//
//  BWFeedback.swift
//  BWReportProblem
//
//  Created by raj on 16/09/20.
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
    
    public func present(_ sender: UIViewController, _ projectID: String) {
        
        let storyboard = AppStoryboard.Main.instance
        let viewController = storyboard.instantiateViewController(withIdentifier: "BWFeedbackViewController") as! BWFeedbackViewController
        viewController.project_id = projectID
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        sender.present(navigationController, animated: true) {
            
        }
    }
}
enum AppStoryboard : String {
    case Main = "Main"
    
      // MARK: - Declaration
    var instance : UIStoryboard {
        let bundle = Bundle(for: BWFeedback.self)
        return UIStoryboard(name: self.rawValue, bundle: bundle)
    }
    
}

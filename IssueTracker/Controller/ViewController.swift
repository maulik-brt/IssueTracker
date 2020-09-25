//
//  ViewController.swift
//  IssueReport
//
//  Created by Bluewhale-iOS-Team on 17/09/20.
//

import UIKit

class ViewController: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
     }
    
    
    @IBAction func btnReportIssue(_ sender: Any) {
        BWFeedback.shared.present(self, "test-project", "1.0 (1)", "iOS", "Rajesh", "Staging","157")
     }
    
}

//
//  ViewController.swift
//  AnswerBotSample
//
//  Created by Killian Smith on 27/09/2018.
//  Copyright © 2018 Zendesk. All rights reserved.
//

import UIKit
import ZendeskSDK
import AnswerBotSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func openAnswerBotViewController(_ sender: Any) {
        let answerBotConfigs = AnswerBotUIConfiguration()
        // NOTE: Currently no configs in the AnswerBotUiConfiguration
        
        let requestUIConfigs = RequestUiConfiguration()
        requestUIConfigs.subject = "Example subject field from requests redirected from Answer Bot"
        requestUIConfigs.tags = ["Answer_Bot", "Tag", "iOS"]
        // Requests that are redirected from AB to Support will have the above subject and list of tags
        
        guard let answerBotViewController = AnswerBotUI.buildAnswerBotUI(with: [requestUIConfigs, answerBotConfigs]) else { return }
        self.navigationController?.pushViewController(answerBotViewController, animated: true)
    }
    
    @IBAction func openRequestList(_ sender: Any) {
        let requestList = RequestUi.buildRequestList()
        self.navigationController?.pushViewController(requestList, animated: true)
    }
    
}

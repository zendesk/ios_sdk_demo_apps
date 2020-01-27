//
//  ViewController.swift
//  AnswerBotSample
//
//  Created by Killian Smith on 27/09/2018.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit
import SupportSDK
import AnswerBotSDK
import MessagingSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func openAnswerBotViewController(_ sender: Any) {
        do {
            let answerBotEngine = try AnswerBotEngine.engine()
            let supportEngine = try SupportEngine.engine()
            let messagingConfiguration = MessagingConfiguration()
            let viewController = try Messaging.instance.buildUI(engines: [answerBotEngine, supportEngine],
                                                    configs: [messagingConfiguration])
            self.navigationController?.pushViewController(viewController, animated: true)
        } catch {
            // do something with error
        }
    }
    
    @IBAction func openRequestList(_ sender: Any) {
        let requestScreen = RequestUi.buildRequestUi(with: [])
        self.navigationController?.pushViewController(requestScreen, animated: true)
    }
}

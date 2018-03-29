//
//  ViewController.swift
//  support_request_updates_sample
//
//  Created by Zendesk on 06/03/2018.
//  Copyright © 2018 Zendesk. All rights reserved.
//

import UIKit
import ZendeskSDK
import ZendeskCoreSDK
import ZendeskProviderSDK

class RequestUpdatesVC: UIViewController {
    private let toastWrapper = ZDKToastViewWrapper()
    
    // Outlets
    @IBOutlet weak var ticketListButton: UIButton!
    @IBOutlet weak var requestUpdatesButton: UIButton!
    
    // Actions
    @IBAction func createTicket(_ sender: Any) {
        let viewController = RequestUi.buildRequestList()
        let config = RequestUiConfiguration.init()

        config.subject = "Test subject from support_request_updates_sample app"
        config.tags = ["Test_Tag","supp_req_update_sample", "app"]
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func onClickedRequestUpdates(_ sender: Any) {
        ZDKRequestProvider().getUpdatesForDevice(callback: ({ (updates) in
            if let updates = updates, updates.hasUpdatedRequests() {
                self.ticketListButton.setTitle("Ticket List (\(updates.requestUpdates.count) new)", for: UIControlState.normal)
            
                self.toastWrapper.showError(in: self, withMessage: "New Replies", duration: 3.0)
                
            }else {
                self.ticketListButton.setTitle("Ticket List", for: UIControlState.normal)
                
                self.toastWrapper.showError(in: self, withMessage: "No new Replies", duration: 3.0)
            }
        }))
    }
    
    @IBAction func launchHelpCenter(_ sender: Any) {
        let viewController = ZDKHelpCenterUi.buildHelpCenterOverview()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toastWrapper.hideToastView(true)
    }
}


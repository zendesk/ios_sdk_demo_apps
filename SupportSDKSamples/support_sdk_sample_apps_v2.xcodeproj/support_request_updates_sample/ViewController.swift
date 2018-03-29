//
//  ViewController.swift
//  support_request_updates_sample
//
//  Created by Killian Smith on 06/03/2018.
//  Copyright © 2018 Killian Smith. All rights reserved.
//

import UIKit
import ZendeskSDK
import ZendeskCoreSDK
import ZendeskProviderSDK

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var ticketListButton: UIButton!
    @IBOutlet weak var requestUpdatesButton: UIButton!
    
    // Actions
    @IBAction func onClickedTicketList(_ sender: Any) {
        let config = ZDKRequestUiConfiguration.init()
        config.subject = "Test subject from support_request_updates_sample app"
        config.tags = ["Test_Tag","supp_req_update_sample", "app"]
        
        ZDKRequestUi.pushRequestList(with: self.navigationController, configurations: [config])
    }
    
    @IBAction func onClickedRequestUpdates(_ sender: Any) {
        ZDKRequestProvider().getUpdatesForDevice(callback: ({ (updates) in
            if let updates = updates, updates.hasUpdatedRequests() {
                print("Incoming tickets")
                self.ticketListButton.setTitle("Ticket List (\(updates.requestUpdates.count) new)", for: UIControlState.normal)
            }else {
                print("No new tickets")
                self.ticketListButton.setTitle("Ticket List", for: UIControlState.normal)
            }
        }))
    }
}


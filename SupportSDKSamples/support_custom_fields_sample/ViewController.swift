//
//  ViewController.swift
//  support_sdk_sample_apps_v2
//
//  Created by Zendesk on 06/03/2018.
//  Copyright © 2018 Zendesk. All rights reserved.
//

import UIKit
import ZendeskProviderSDK
import ZendeskSDK
import ZendeskCoreSDK

class ViewController: UIViewController {
    // Outlets
    @IBOutlet weak var customField1: UITextField!
    @IBOutlet weak var customField2: UITextField!
    @IBOutlet weak var customField3: UITextField!
    @IBOutlet weak var customField4: UITextField!
    
    @IBAction func submitPressed(_ sender: Any) {
        let requestProvider = ZDKRequestProvider()
        let request = buildCreateRequest()

        requestProvider.createRequest(request, withCallback: buildCallback())
    
        emptyFields()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func buildCreateRequest() -> ZDKCreateRequest {
        let request = ZDKCreateRequest()
        
        request.subject = "Test custom field tickets"
        request.requestDescription = "We should see custom ticket fields on this ticket"
        
        request.customTicketFields = buildCustomFieldsList()
        return request
    }
    
    private func buildCallback() -> ZDKCreateRequestCallback {
        return { (request, error) in
            if request != nil {
                print("Success")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func emptyFields() {
        customField1.text = ""
        customField2.text = ""
        customField3.text = ""
        customField4.text = ""
    }
    
    // Only appends a custom field if it isn't empty
    private func buildCustomFieldsList()-> [ZDKCustomField] {
        var list = [ZDKCustomField]()
        if let textField1 = customField1.text.getTag(), !textField1.isEmpty {
            list.append(ZDKCustomField(fieldId: NSNumber(value: 1), andValue: textField1))
        }
        
        if let textField2 = customField2.text.getTag(), !textField2.isEmpty {
            list.append(ZDKCustomField(fieldId: NSNumber(value: 2), andValue: textField2))
        }
        
        if let textField3 = customField3.text.getTag(), !textField3.isEmpty {
            list.append(ZDKCustomField(fieldId: NSNumber(value: 3), andValue: textField3))
        }
        
        if let textField4 = customField4.text.getTag(), !textField4.isEmpty  {
            list.append(ZDKCustomField(fieldId: NSNumber(value: 4), andValue: textField4))
        }
        list.forEach({ (item) in
            print(item.value)
        })
        return list
    }
}

extension String {
    // The text fields should be converted to the tag equivalent of the value
    func getTag() -> String {
        return self.lowercased().replacingOccurrences(of: " ", with: "_")
    }
}

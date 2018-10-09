//
//  ViewController.swift
//  CocoaPodSample
//
//  Created by Killian Smith on 22/05/2018.
//  Copyright © 2018 Killian Smith. All rights reserved.
//

import UIKit

import ZendeskSDK
import ZendeskCoreSDK

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    let imagePickerController = UIImagePickerController()
    private let toastWrapper = ZDKToastViewWrapper()
    
    // MARK: Outlets
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var ticketListButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var customFieldTextField: UITextField!
    
    var hcConfig: HelpCenterUiConfiguration {
        let hcConfig = HelpCenterUiConfiguration()
        hcConfig.hideContactSupport = true
        hcConfig.labels = ["label"] // only hc articles with the label 'label' will appear
        return hcConfig
    }
    
    var requestConfig: RequestUiConfiguration {
        let config = RequestUiConfiguration()
        config.tags = ["tag_1","tag_2", "tag_3"]
        config.subject = "Support_API Sample"
        return config
    }

    @IBAction func openHC(_ sender: Any) {
        let helpCenter = HelpCenterUi.buildHelpCenterOverview(withConfigs: [hcConfig, requestConfig])
        navigationController?.pushViewController(helpCenter, animated: true)
    }
    
    @IBAction func openRequestList(_ sender: Any) {
        let requestList = RequestUi.buildRequestList(with: [requestConfig])
        self.navigationController?.pushViewController(requestList, animated: true)
    }

    // MARK: Request Creation
    
    func buildCreateRequest(callback: @escaping (ZDKCreateRequest) -> Void) {
        let request = ZDKCreateRequest()
        request.subject = subjectTextField.text ?? requestConfig.subject
        request.requestDescription = descriptionTextView.text ?? "Default: The problem of the ticket"
        request.tags = requestConfig.tags
        request.customTicketFields = getCustomFields()
        
        uploadAttachment { (attachment) in
            if let attachment = attachment {
                request.attachments.append(attachment)
            }
            callback(request)
        }
    }
    
    private func getCustomFields() -> [ZDKCustomField] {
        var customFields = [ZDKCustomField]()
        
        if let customFieldValue = customFieldTextField.text, !customFieldValue.isEmpty {
            customFields.append(ZDKCustomField(fieldId: NSNumber(value: 1), andValue: customFieldValue) )// get fieldId from Support Settings
        }
        
        return customFields
    }
    
    func uploadAttachment(callback: @escaping (ZDKUploadResponse?) -> Void) {
        let attachment = getImageDataFrom(view: attachmentImageView)
        
        ZDKUploadProvider().uploadAttachment(attachment, withFilename: "image_name_app.png", andContentType: "image") { (response, error) in
            if let response = response {
                print("Token: ", response.uploadToken)
                print("Attachment: ", response.attachment)
            }
            if let error = error {
                print("Error: ", error.localizedDescription)
            }
            callback(response)  // response always gets sent regardless if nil.
        }
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        buildCreateRequest {
            ZDKRequestProvider().createRequest($0)  { [unowned self] (result, error) in
                if result != nil {
                    self.showToast(with: "Message Sent")
                    self.clearFields()
                }
                if error != nil {
                    self.showToast(with: "Failed to send")
                    print("Error: Failed to send request. Enable CoreLogger for more info.")
                }
            }
        }
    }
    
    // MARK: Request Updates
    
    @IBAction func refreshForTicketUpdate(_ sender: Any) {
        ZDKRequestProvider().getUpdatesForDevice { [unowned self] in
            if let updates = $0, updates.hasUpdatedRequests() {
                self.ticketListButton.setTitle("Ticket List (\(updates.requestUpdates.count) new)", for: UIControlState.normal)
                self.showToast(with: "New Replies")
            } else {
                self.ticketListButton.setTitle("Ticket List", for: UIControlState.normal)
                self.showToast(with: "No new Replies")
            }
        }
    }
    
    // MARK: Image stuff
    
    @IBAction func addImage(_ sender: Any) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func getImageDataFrom(view: UIImageView) -> Data?{
        guard let image = view.image else { return nil }
        return UIImagePNGRepresentation(image)
    }
    
    // MARK: UI and Layout
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Support SDK Sample"
        imagePickerController.delegate = self
        clearFields()
    }
    
    private func clearFields() {
        subjectTextField.text = ""
        descriptionTextView.text = ""
        customFieldTextField.text = ""
        attachmentImageView.image = nil
    }
    
    private func showToast(with message: String) {
        self.toastWrapper.showError(in: self, withMessage: message, duration: 3.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        
        attachmentImageView.contentMode = .scaleAspectFit
        attachmentImageView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


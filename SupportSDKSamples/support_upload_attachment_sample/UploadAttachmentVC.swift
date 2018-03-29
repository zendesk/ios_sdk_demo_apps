//
//  ViewController.swift
//  support_upload_attachment_sample
//
//  Created by Zendesk on 06/03/2018.
//  Copyright © 2018 Zendesk. All rights reserved.
//

import UIKit
import ZendeskSDK
import ZendeskCoreSDK
import ZendeskProviderSDK

class UploadAttachmentVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let toastWrapper = ZDKToastViewWrapper()
    let imagePickerController = UIImagePickerController()
    let provider = ZDKProvider.init()
    
    // Outlets
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var customTagsField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    // Actions
    @IBAction func addImagePressed(_ sender: Any) {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        // Once the request is finished being built, it is sent
        buildCreateRequest { [weak self] (request) in
            self?.sendCreateRequest(request: request)
        }
    }
    
    // func returns nothing.
    func buildCreateRequest(callback: @escaping (ZDKCreateRequest)->Void) {
        uploadAttachment { (attachment) in
            let request = ZDKCreateRequest()
            request.subject = self.subjectField.text
            request.requestDescription = self.descriptionField.text
            request.tags = self.retrieveTags()
            if let attachment = attachment{
                request.attachments.append(attachment)
            }
            callback(request)
        }
    }
    
    func sendCreateRequest(request: ZDKCreateRequest){
        ZDKRequestProvider().createRequest(request) {  (result, error) in
            if let error = error {
                
                self.toastWrapper.showError(in: self, withMessage: "Failed to send", duration: 3.0)
                print(error.localizedDescription)
                
            }else{
                self.toastWrapper.showError(in: self, withMessage: "Sent Successfully", duration: 3.0)
                
                self.clearFields()
            }
        }
        print(request.debugDescription)
    }
    
    func uploadAttachment(callback: @escaping (ZDKUploadResponse?)->Void){
        ZDKUploadProvider().uploadAttachment(getImageDataFrom(view: imageView), withFilename: "image_name_app.png", andContentType: "image")
        { (response, error) in
            if let response = response {
                print("Response token: \(response.uploadToken)")
                print("Response attach: \(response.attachment.debugDescription)")
            }else if let error = error {
                print("No image")
                print(error.localizedDescription)
            }
            callback(response)  // response always gets sent regardless if nil.
        }
    }
    
    func retrieveTags() -> [String]{
        var tagsArray = [String]()
        if let tags = self.customTagsField.text {
            tagsArray = tags.components(separatedBy: " ")
        }

        return tagsArray
    }
    
    // Resets the view for the next request to be sent.
    func clearFields() {
        subjectField.text = ""
        descriptionField.text = ""
        customTagsField.text = ""
        imageView.image = nil
    }
    
    func getImageDataFrom(view: UIImageView) -> Data?{
        if let image = view.image{
            return UIImagePNGRepresentation(image)
        }else{
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        
        addImageButton.layer.cornerRadius = addImageButton.frame.size.height / 2
        addImageButton.clipsToBounds = true
        sendButton.layer.cornerRadius = addImageButton.frame.size.height / 5
        sendButton.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toastWrapper.hideToastView(true)
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

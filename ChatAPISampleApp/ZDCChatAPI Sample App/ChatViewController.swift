/*
 *
 *  ChatViewController.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 07/07/2016.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zopim Chat SDK, You agree to the Zendesk Terms
 *  of Service https://www.zendesk.com/company/terms and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/application-developer-and-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Chat SDK.
 *
 */

import UIKit
import DKImagePickerController


class ChatViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet var loadingView: UIView!
  
  var delegate: ChatViewControllerDelegate?
  var dataSource: ChatViewControllerDataSource?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    
    // Create a chaat delegate and datasouce object
    let delegateDatasource = ChatDelegateDateSource(withChatView: self)
    
    self.delegate = delegateDatasource
    self.dataSource = delegateDatasource
    
    setupKeyboardEvents()
    updateSendButtonState()
  }
  
  func setupKeyboardEvents() {
    NSNotificationCenter.defaultCenter().addObserverForName(
      UIKeyboardDidShowNotification,
      object: nil,
      queue: NSOperationQueue.mainQueue()) { [weak self] notification in
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.2) {
          self?.bottomConstraint.constant = keyboardFrame.size.height
          self?.view.layoutIfNeeded()
        }
    }
    
    NSNotificationCenter.defaultCenter().addObserverForName(
      UIKeyboardDidHideNotification,
      object: nil,
      queue: NSOperationQueue.mainQueue()) { [weak self] notificaiton in
        self?.bottomConstraint.constant = 0
    }
  }
}

//MARK: - Actions

extension ChatViewController {
  
  @IBAction func pickImage(sender: AnyObject) {
    let pickerController = DKImagePickerController()
    
    pickerController.singleSelect = true
    pickerController.didSelectAssets = { (assets: [DKAsset]) in
      
      assets[0].fetchOriginalImage(false) { (image, info) in
        self.delegate?.chatController(self, didSelectImage: image!)
      }
    }
    
    self.presentViewController(pickerController, animated: true) {}
  }
  
  @IBAction func sendMessage(sender: AnyObject) {
    sendMessage()
  }
  
  func sendMessage() {
    if (messageTextField.text ?? "").isEmpty {
      return
    }
    
    self.delegate?.chatController(self, sendMessage: messageTextField.text!)
    messageTextField.text = ""
    updateSendButtonState()
  }
  
}


//MARK: - UITextFieldDelegate


extension ChatViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    sendMessage()
    return true
  }
  
  @IBAction func textFieldEditingChanged(sender: AnyObject) {
    updateSendButtonState()
  }
  
  func updateSendButtonState() {
    sendButton.enabled = !(messageTextField.text ?? "").isEmpty
  }
}


//MARK: - Table Delegate/Datasource


extension ChatViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (self.dataSource?.chatLog.count)!
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return TableCellFactory.constructCell(
      forTableView: tableView,
      indexPath: indexPath,
      event: (self.dataSource?.chatLog[indexPath.row])!)
  }
}

extension ChatViewController: ChatView {
  
  // Update the connection state with a new connection value
  func updateConnectionState(state: Bool) {
    NSLog("Chat state updated to \(state)")
    
    let view = state ? nil : self.loadingView
    dispatch_async(dispatch_get_main_queue()) {
      
      UIView.transitionWithView(self.loadingView,
                                duration: 0.3,
                                options: UIViewAnimationOptions.CurveLinear,
                                animations: {
                                  self.tableView.tableHeaderView = view
        },
                                completion: { (Bool) in
                                  self.tableView.tableHeaderView?.hidden = state
                                  self.view.layoutIfNeeded()
      })
    }
  }
  
  func updateChatLog() {
    self.tableView.reloadData()
    self.tableView.setNeedsLayout()
    self.tableView.layoutIfNeeded()
    
    let last = self.tableView.numberOfRowsInSection(0) - 1
    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: last, inSection: 0),
                                          atScrollPosition: .Middle, animated: true)
  }
}

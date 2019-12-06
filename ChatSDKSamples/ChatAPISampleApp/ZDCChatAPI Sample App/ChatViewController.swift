/*
 *
 *  ChatViewController.swift
 *  ZDCChatAPI Sample App
 *
 *  Created by Zendesk on 07/07/2016.
 *
 *  Copyright (c) 2016 Zendesk. All rights reserved.
 *
 *  By downloading or using the Zendesk Mobile SDK, You agree to the Zendesk Master
 *  Subscription Agreement https://www.zendesk.com/company/customers-partners/#master-subscription-agreement and Application Developer and API License
 *  Agreement https://www.zendesk.com/company/customers-partners/#application-developer-api-license-agreement and
 *  acknowledge that such terms govern Your use of and access to the Mobile SDK.
 *
 */

import UIKit
import DKImagePickerController

class ChatViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var messageTextField: UITextField!
  @IBOutlet weak var sendButton: UIButton!
  
  var delegate: ChatViewControllerDelegate!
  var dataSource: ChatViewControllerDataSource!

  // Update the connection state with a new connection value
  var isChatConnected: Bool = false {
    didSet {
      let logMessage = isChatConnected ? "Connected" : "Chat is connecting..."
      print(logMessage)
    }
  }

  fileprivate let client = APIClient()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableView.automaticDimension
    
    delegate = ChatControllerDelegate(client: client)
    dataSource = ChatControllerDataSource(withChatView: self, client: client)
    
    client.resumeChatIfNeeded()
    isChatConnected = client.isChatConnected
    
    setupKeyboardEvents()
    updateSendButtonState()
  }
  
  func setupKeyboardEvents() {
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardDidShowNotification,
      object: nil,
      queue: OperationQueue.main) { [weak self] notification in
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.2, animations: {
          self?.bottomConstraint.constant = keyboardFrame.size.height
          self?.view.layoutIfNeeded()
        }) 
    }
    
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardDidHideNotification,
      object: nil,
      queue: OperationQueue.main) { [weak self] notificaiton in
        self?.bottomConstraint.constant = 0
    }
  }
}

//MARK: - Actions

extension ChatViewController {
  
  @IBAction func pickImage(_ sender: AnyObject) {
    let pickerController = DKImagePickerController()

    pickerController.singleSelect = true
    pickerController.didSelectAssets = { (assets: [DKAsset]) in

      assets[0].fetchOriginalImage { (image, info) in
        self.delegate.chatController(self, didSelectImage: image!)
      }
    }
    
    self.present(pickerController, animated: true) {}
  }
  
  @IBAction func sendMessage(_ sender: AnyObject) {
    sendMessage()
  }
  
  func sendMessage() {
    if (messageTextField.text ?? "").isEmpty {
      return
    }
    
    self.delegate.chatController(self, sendMessage: messageTextField.text!)
    messageTextField.text = ""
    updateSendButtonState()
  }
  
}


//MARK: - UITextFieldDelegate


extension ChatViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    sendMessage()
    return true
  }
  
  @IBAction func textFieldEditingChanged(_ sender: AnyObject) {
    updateSendButtonState()
  }
  
  func updateSendButtonState() {
    sendButton.isEnabled = !(messageTextField.text ?? "").isEmpty
  }
}


//MARK: - Table Delegate/Datasource


extension ChatViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.chatLog.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return TableCellFactory.constructCell(
      forTableView: tableView,
      indexPath: indexPath,
      event: dataSource.chatLog[indexPath.row])
  }
}

extension ChatViewController: ChatView {

  
  func updateChatLog() {
    self.tableView.reloadData()
    self.tableView.setNeedsLayout()
    self.tableView.layoutIfNeeded()
    
    let last = self.tableView.numberOfRows(inSection: 0) - 1
    self.tableView.scrollToRow(at: IndexPath(row: last, section: 0),
                               at: .middle, animated: true)
  }
}

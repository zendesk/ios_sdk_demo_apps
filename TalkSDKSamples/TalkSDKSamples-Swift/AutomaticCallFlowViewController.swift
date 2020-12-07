//
//  AutomaticCallFlowViewController.swift
//  TalkSDKSamples
//
//  Created by Michał Smaga on 27/11/2020.
//

import UIKit
import ZendeskCoreSDK
import TalkSDK

class AutomaticCallFlowViewController: UIViewController {

    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var agentAvailabilityLabel: UILabel!

    var talk: Talk?

    override func viewDidLoad() {
        super.viewDidLoad()

        callButton.isEnabled = false

        Zendesk.initialize(appId: ZendeskConfig.appId,
                           clientId: ZendeskConfig.clientId,
                           zendeskUrl: ZendeskConfig.zendeskURL)

        let identity = Identity.createAnonymous()
        Zendesk.instance?.setIdentity(identity)

        talk = Talk(zendesk: Zendesk.instance!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAgentAvailability()
    }

    // MARK: - Line status and agent availability

    private func checkAgentAvailability() {
        guard let talk = talk else { return }

        talk.lineStatus(digitalLine: ZendeskConfig.digitalLine) { [weak self] result in
            switch result {
            case .success(let lineStatus):
                self?.updateAgentAvailability(with: lineStatus.agentAvailable)
            case .failure(let agentError):
                self?.handleLineStatusError(with: agentError)
            }
        }
    }

    private func updateAgentAvailability(with available: Bool) {
        if available {
            callButton.isEnabled = true
            agentAvailabilityLabel.isHidden = true
        } else {
            callButton.isEnabled = false
            agentAvailabilityLabel.text = "No agent available"
            agentAvailabilityLabel.textColor = .darkGray
            agentAvailabilityLabel.isHidden = false

            // Re-check agent availability
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.checkAgentAvailability()
            }
        }
    }

    private func handleLineStatusError(with error: AgentStatusError) {
        callButton.isEnabled = false
        agentAvailabilityLabel.text = "An error occured. Please try again later"
        agentAvailabilityLabel.textColor = .red
        agentAvailabilityLabel.isHidden = false

        showAlert(title: "Failure", message: error.description)
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Making a call

    @IBAction func callButtonTapped(_ sender: Any) {
        guard let talk = talk else { return }

        talk.startCall(to: ZendeskConfig.digitalLine)
    }
}

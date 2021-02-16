//
//  ManualCallScreensViewController.swift
//  TalkSDKSamples
//
//  Created by Michał Smaga on 27/11/2020.
//

import UIKit
import ZendeskCoreSDK
import TalkSDK

class ManualCallScreensViewController: UIViewController {

    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var agentAvailabilityLabel: UILabel!
    @IBOutlet weak var customizeSwitch: UISwitch!

    var talk: Talk?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        callButton.isEnabled = false

        Zendesk.initialize(appId: ZendeskConfig.appId,
                           clientId: ZendeskConfig.clientId,
                           zendeskUrl: ZendeskConfig.zendeskURL)

        let identity = makeUserIdentity()
        Zendesk.instance?.setIdentity(identity)

        talk = Talk(zendesk: Zendesk.instance!)
    }

    private func makeUserIdentity() -> Identity {
        var userName: String?
        var userEmail: String?

        // provide if able to identify user
        userName = "End User"
        userEmail = "end.user@domain.com"

        return Identity.createAnonymous(name: userName, email: userEmail)
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
        pushCallConfigurationScreen()
    }

    private func pushCallConfigurationScreen() {
        guard let talk = talk else { return }

        let callConfigurationViewController = talk.makeCallConfigurationViewController(for: ZendeskConfig.digitalLine)
        callConfigurationViewController.cancelHandler = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        callConfigurationViewController.startCallHandler = { [weak self] answer in
            self?.navigationController?.popViewController(animated: false)
            self?.presentCallScreen(recordingConsentAnswer: answer)
        }

        if customizeSwitch.isOn {
            CustomStyle.apply(to: callConfigurationViewController.microphoneScreen)
            CustomStyle.apply(to: callConfigurationViewController.recordingConsentScreen)
        }

        navigationController?.pushViewController(callConfigurationViewController, animated: true)
    }

    private func presentCallScreen(recordingConsentAnswer: RecordingConsentAnswer) {
        guard let talk = talk else { return }

        let callData = TalkCallData(digitalLine: ZendeskConfig.digitalLine,
                                    recordingConsentAnswer: recordingConsentAnswer)

        let callViewController = talk.makeCallViewController(with: callData) { [weak self] _, callSummary in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }

        if customizeSwitch.isOn {
            CustomStyle.apply(to: callViewController)
        }

        callViewController.modalPresentationStyle = .fullScreen
        present(callViewController, animated: false, completion: nil)
    }
}

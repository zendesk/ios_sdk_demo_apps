//
//  CustomCallConfigurationViewController.swift
//  TalkSDKSamples
//
//  Created by Michał Smaga on 01/12/2020.
//

import UIKit
import AVFoundation
import ZendeskCoreSDK
import TalkSDK

class CustomCallConfigurationViewController: UIViewController {

    @IBOutlet weak var microphonePermissionView: UIStackView!
    @IBOutlet weak var recordingConsentView: UIStackView!
    @IBOutlet weak var recordingConsentSwitch: UISwitch!

    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var agentAvailabilityLabel: UILabel!

    var talk: Talk?
    var recordingConsentConfiguration: RecordingConsent?

    override func viewDidLoad() {
        microphonePermissionView.isHidden = true
        recordingConsentView.isHidden = true
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
        checkMicrophonePermission()
    }

    // MARK: - Microphone access permission

    private func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            askForMicrophonePermission()
        case .granted:
            checkAgentAvailability()
        case .denied:
            showNoMicrophonePermissionInfo()
        @unknown default:
            showNoMicrophonePermissionInfo()
        }
    }

    private func askForMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.checkAgentAvailability()
                } else {
                    self?.showNoMicrophonePermissionInfo()
                }
            }
        }
    }

    private func showNoMicrophonePermissionInfo() {
        microphonePermissionView.isHidden = false
    }

    // MARK: - Line status and agent availability

    private func checkAgentAvailability() {
        guard let talk = talk else { return }

        talk.lineStatus(digitalLine: ZendeskConfig.digitalLine) { [weak self] result in
            switch result {
            case .success(let lineStatus):
                self?.updateRecordingConsentConfiguration(with: lineStatus.recordingConsent)
                self?.updateAgentAvailability(with: lineStatus.agentAvailable)
            case .failure(let agentError):
                self?.handleLineStatusError(with: agentError)
            }
        }
    }

    private func updateRecordingConsentConfiguration(with configuration: RecordingConsent) {
        recordingConsentConfiguration = configuration

        switch configuration {
        case .optIn:
            recordingConsentView.isHidden = false
            recordingConsentSwitch.isOn = false
        case .optOut:
            recordingConsentView.isHidden = false
            recordingConsentSwitch.isOn = true
        case .unknown:
            recordingConsentView.isHidden = true
        @unknown default:
            recordingConsentView.isHidden = true
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
        var answer: RecordingConsentAnswer = .unknown

        if let configuration = recordingConsentConfiguration, configuration == .optIn || configuration == .optOut {
            answer = recordingConsentSwitch.isOn ? .optedIn : .optedOut
        }

        presentCallScreen(recordingConsentAnswer: answer)
    }

    private func presentCallScreen(recordingConsentAnswer: RecordingConsentAnswer) {
        guard let talk = talk else { return }

        let callData = TalkCallData(digitalLine: ZendeskConfig.digitalLine,
                                    recordingConsentAnswer: recordingConsentAnswer)

        let callViewController = talk.makeCallViewController(with: callData) { [weak self] _, callSummary in
            let delay: TimeInterval = callSummary.error == .some(.digitalLineNotFound) ? 0 : 2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [unowned self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }

        callViewController.modalPresentationStyle = .fullScreen
        present(callViewController, animated: false, completion: nil)
    }
}

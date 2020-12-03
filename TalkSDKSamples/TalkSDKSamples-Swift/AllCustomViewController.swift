//
//  CustomCallUIViewController.swift
//  TalkSDKSamples
//
//  Created by Michał Smaga on 27/11/2020.
//

import UIKit
import AVFoundation
import ZendeskCoreSDK
import TalkSDK

class AllCustomViewController: UIViewController {

    @IBOutlet weak var microphonePermissionView: UIStackView!
    @IBOutlet weak var recordingConsentView: UIStackView!
    @IBOutlet weak var recordingConsentSwitch: UISwitch!

    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var agentAvailabilityLabel: UILabel!

    @IBOutlet weak var ongoingCallView: UIStackView!
    @IBOutlet weak var callDurationLabel: UILabel!
    @IBOutlet weak var speakerSwitchLabel: UILabel!
    @IBOutlet weak var speakerSwitch: UISwitch!
    @IBOutlet weak var muteSwitchLabel: UILabel!
    @IBOutlet weak var muteSwitch: UISwitch!
    @IBOutlet weak var endCallButton: UIButton!

    var talk: Talk?
    var recordingConsentConfiguration: RecordingConsent?
    var talkCall: TalkCall?

    var callTimer: Timer?
    let durationFormatter: DateComponentsFormatter = DateComponentsFormatter()

    override func viewDidLoad() {
        microphonePermissionView.isHidden = true
        recordingConsentView.isHidden = true
        callButton.isEnabled = false
        ongoingCallView.isHidden = true

        durationFormatter.allowedUnits = [.minute, .second]
        durationFormatter.zeroFormattingBehavior = .dropTrailing

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            stopTimer()

            talkCall?.disconnect()
            talkCall = nil
        }
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
            agentAvailabilityLabel.text = ""
        } else {
            callButton.isEnabled = false
            agentAvailabilityLabel.text = "No agent available"
            agentAvailabilityLabel.textColor = .darkGray

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


        makeCall(recordingConsentAnswer: answer)
    }

    private func makeCall(recordingConsentAnswer: RecordingConsentAnswer) {
        guard let talk = talk else { return }

        if let call = talkCall {
            call.disconnect()
            talkCall = nil
        }

        let callData = TalkCallData(digitalLine: ZendeskConfig.digitalLine,
                                    recordingConsentAnswer: recordingConsentAnswer)

        talkCall = talk.call(callData: callData,
                             statusChangeHandler: onCallStatusChange(status:error:))

        callDurationLabel.text = "0:00"
    }

    private func onCallStatusChange(status: CallStatus, error: TalkCallError?) {
        switch status {
        case .connecting:
            agentAvailabilityLabel.text = "Connecting..."
            agentAvailabilityLabel.textColor = .darkGray

            ongoingCallView.isHidden = false
            callButton.isEnabled = false
            setOngoingCallControls(enabled: false)
            startTimer()
        case .connected:
            agentAvailabilityLabel.text = ""
            ongoingCallView.isHidden = false
            callButton.isEnabled = false
            setOngoingCallControls(enabled: true)
        case .disconnected:
            agentAvailabilityLabel.text = ""
            ongoingCallView.isHidden = false
            callButton.isEnabled = true
            disableOngoingCallControlsAndHideWithDelay()
            stopTimer()
        case .failed:
            agentAvailabilityLabel.text = "An error occured. Please try again later"
            agentAvailabilityLabel.textColor = .red
            ongoingCallView.isHidden = false
            callButton.isEnabled = true
            disableOngoingCallControlsAndHideWithDelay()
            stopTimer()
        default:
            break
        }
    }

    private func setOngoingCallControls(enabled: Bool) {
        speakerSwitchLabel.textColor = enabled ? .black : .lightGray
        speakerSwitch.isEnabled = enabled
        muteSwitchLabel.textColor = enabled ? .black : .lightGray
        muteSwitch.isEnabled = enabled
        endCallButton.isEnabled = enabled
    }

    private func disableOngoingCallControlsAndHideWithDelay() {
        setOngoingCallControls(enabled: false)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.ongoingCallView.isHidden = true
        }
    }

    // MARK: - Call duration timer

    private func startTimer() {
        callTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [unowned self] _ in
            guard let call = self.talkCall else { return }

            if call.duration < 1 {
                self.callDurationLabel.text = "0:00"
            } else {
                self.callDurationLabel.text = durationFormatter.string(from: call.duration)
            }
        }
    }

    private func stopTimer() {
        callTimer?.invalidate()
        callTimer = nil
    }

    // MARK: - Ongoing call actions

    @IBAction func speakerSwitchValueChanged(_ sender: Any) {
        guard let call = talkCall else { return }

        call.audioOutput = speakerSwitch.isOn ? .speaker : .headset
    }

    @IBAction func muteSwitchValueChanged(_ sender: Any) {
        guard let call = talkCall else { return }

        call.muted = muteSwitch.isOn
    }

    @IBAction func endCallButtonTapped(_ sender: Any) {
        guard let call = talkCall else { return }

        call.disconnect()
        talkCall = nil
    }
}

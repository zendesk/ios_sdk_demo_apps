//
//  CustomStyle.swift
//  TalkSDKSamples
//
//  Created by Michał Smaga on 30/11/2020.
//

import UIKit
import TalkSDK

struct CustomStyle {

    static func apply(to screen: MicrophonePermissionScreen) {
        screen.backgroundColor = .lightGray

        screen.titleLabel.font = .boldSystemFont(ofSize: 32)
        screen.titleLabel.textColor = .white

        screen.messageLabel.font = .systemFont(ofSize: 24)
        screen.messageLabel.textColor = .white

        screen.allowButton.layer.cornerRadius = 14
        screen.allowButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        screen.allowButton.setTitleColor(.white, for: .normal)
        screen.allowButton.setBackgroundImage(UIImage(named: "button"), for: .normal)

        screen.cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        screen.cancelButton.setTitleColor(.white, for: .normal)
    }

    static func apply(to screen: RecordingConsentScreen) {
        screen.backgroundColor = .lightGray

        screen.titleLabel.font = .boldSystemFont(ofSize: 24)
        screen.titleLabel.textColor = .white

        screen.messageLabel.font = .systemFont(ofSize: 16)
        screen.messageLabel.textColor = .white

        screen.startCallButton.layer.cornerRadius = 14
        screen.startCallButton.titleLabel?.font = .boldSystemFont(ofSize: 24)
        screen.startCallButton.setTitleColor(.white, for: .normal)
        screen.startCallButton.setBackgroundImage(UIImage(named: "button"), for: .normal)

        screen.cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        screen.cancelButton.setTitleColor(.white, for: .normal)

        screen.activityIndicatorView.color = .white

        let color = UIColor(red: 112 / 255, green: 165 / 255, blue: 255 / 255, alpha: 1).withAlphaComponent(0.75)
        screen.consentSwitchView.backgroundColor = color
        screen.consentSwitch.onTintColor = .magenta
        screen.messageLabel.textColor = .white
    }

    static func apply(to screen: UIViewController & CallScreen) {
        let backgroundImg = UIImage(named: "callBackground")
        let backgroundImageView = UIImageView(image: backgroundImg)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        screen.view.addSubview(backgroundImageView)
        screen.view.sendSubviewToBack(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: screen.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: screen.view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: screen.view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: screen.view.bottomAnchor)
        ])

        [screen.callLoadingView.titleLabel,
         screen.callErrorView.titleLabel,
         screen.callTimerView.titleLabel]
            .forEach { label in
                label?.font = .boldSystemFont(ofSize: 24)
                label?.textColor = .black
                label?.numberOfLines = 2
        }

        screen.callButtonsView.speakerTitleLabel.font = .boldSystemFont(ofSize: 12)
        screen.callButtonsView.hangUpTitleLabel.font = .boldSystemFont(ofSize: 14)
        screen.callButtonsView.muteTitleLabel.font = .boldSystemFont(ofSize: 12)

        screen.callErrorView.retryButton.backgroundColor = .red
        screen.callErrorView.cancelButton.setTitleColor(.darkGray, for: .normal)

        if #available(iOS 13.0, *) {
            screen.callLoadingView.activityIndicator.style = .large
        } else {
            screen.callLoadingView.activityIndicator.style = .whiteLarge
        }

        screen.callLoadingView.activityIndicator.color = .white

        screen.callTimerView.timerLabel.font = .boldSystemFont(ofSize: 74)
        screen.callTimerView.timerLabel.textColor = .white
        screen.callTimerView.timerLabel.layer.shadowColor = UIColor.black.cgColor
        screen.callTimerView.timerLabel.layer.shadowRadius = 14
        screen.callTimerView.timerLabel.layer.shadowOpacity = 0.55
        screen.callTimerView.timerLabel.layer.shadowOffset = .zero
    }
}

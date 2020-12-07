:warning: *Use of this software is subject to important terms and conditions as set forth in the License file* :warning:

# Talk SDK Sample App
This repo contains a sample app, that will help you learn how to integrate Zendesk Talk SDK in a way that fits best your application.

We hope you'll find the sample app useful and the code samples contained will be great learning experience and starting point for your own integrations.

## Documentation

### Getting started
Getting started is straightforward.
1. Download or clone the repository.
2. Install the dependancies via CocoaPods by running  `pod install`.
3. Open the `TalkSDKSamples.xcworkspace` workspace in Xcode.
4. **Note**: Provide the necessary details for the SDK initialization:
	- for Swift in in `ZendeskConfig.swift` 
	- for Objective-C in `ZendeskConfig.m` 
5. Select the appropriate target, either `TalkSDKSamples-Swift` or `TalkSDKSamples-ObjectiveC` for building and running the application.

### Samples
The provided code samples show four different approaches to integrating the Talk SDK. We wanted to illustrate how they differ, and depending on how much customizability is required the amount of additional code is needed.

The different use cases are presented with separate view controllers:
- `AutomaticCallFlowViewController` (`ZENAutomaticCallFlowViewController` in Objective-C).
	Presents the simplest way for starting a call. No customization is allowed. The call related view controllers are SDK provided are presented modally.
- `	ManualCallScreensViewController` (`ZENManualCallScreensViewController.m` in Objective-C).
	SDK provided view controllers are initialised and presented manually. Each view controller exposes it's components to enable UI customization.
- `CustomCallConfigurationViewController` (`ZENCustomCallConfigurationViewController` in Objective-C).
	Only SDK provided Call Screen view controller is used. The Call Configuration screen's functionality is implemented by the integrator place.
- `AllCustomViewController` (`ZENAllCustomViewController` in Objective-C).
	No UI components from the SDK are used. All UI is custom implemented and the core SDK APIs are used to start the call.

## Bugs
Please submit bug reports to [Zendesk](https://support.zendesk.com/requests/new).

## Disclaimer
> Please mind that provided samples are meant to be only illustrative starting point for your implementation and thus the concepts are presented in simple and readable way and the code provided should not be considered production ready.

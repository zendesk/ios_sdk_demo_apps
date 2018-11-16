:warning: *Use of this software is subject to important terms and conditions as set forth in the License file* :warning:

# Zendesk Sample Apps for iOS

## Description
This repository provides you with sample Apps to help learn how to use the Zendesk Apps framework and APIs.

We hope you'll find those sample Apps useful and encourage you to re-use some of this code in your own Apps.

This repository contains the following demos:
- [Support SDK Samples](SupportSDKSamples)
  You'll find two Sample Apps added to workspace `CocoaPodSample`
  - A demo application `Sample` showcasing the manual installation of Support SDK.
  - A demo application `CocoaPodSample` showcasing the integration with pods.
  
  Both apps are implementing couple of main features of Support SDK.
  
  **Note:** Initialize your Support SDK within AppDelegate.swift by filling out the credentials
  ```
          // Enter your zendesk app configs here
        Zendesk.initialize(appId: "appId",
                           clientId: "clientId",
                           zendeskUrl: "zendeskUrl")
  ```
                           
- [Chat SDK Samples](ChatSDKSamples)
  - Demo that showcases building a custom chat UI backed by Zendesk Chat API.
  - Demo that shows the app badge count on the tab bar button.
- [Answer Bot SDK Samples](AnswerBotSDKSample)
  - A demo application that shows how to integrate the Answer Bot SDK

## Owners
If you have any questions please email support@zendesk.com.

## Getting Started
Each of the modules in this project is a stand-alone iOS app.

## Contributions
Pull requests are welcome.

## Bugs
Please submit bug reports to [Zendesk](https://support.zendesk.com/requests/new).

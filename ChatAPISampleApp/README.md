:warning: *Use of this software is subject to important terms and conditions as set forth in the License file* :warning:

# Chat SDK API demo

Chat SDK API demo is a swift project that shows how easy it is to create your own chat UI that is backed by Zendesk Chat API.
This demo uses Chat SDK Version 1.3.0.1. You can reference ZDCChat/API as a CocoaPod:

````
pod 'ZDCChat/API'
````

In order to install the CocoaPods used in the sample app, run `pod install`.

![Image](https://support.zendesk.com/hc/user_images/OM78EhKDuet1i0hix6GWBQ.gif)

## Documentation

* [Overview](https://developer.zendesk.com/embeddables/docs/ios-chat-sdk/introduction)
* [Getting started](https://developer.zendesk.com/embeddables/docs/ios-chat-sdk/gettingstarted)
* [Release notes](https://developer.zendesk.com/embeddables/docs/ios-chat-sdk/releasenotes)

## Notable files
* [APIClient.swift](ZDCChatAPI%20Sample%20App/APIClient.swift)
  This class contains all the function calls to ZDCChatAPI.
  <br/>
* [ChatEventsProcessor.swift](ZDCChatAPI%20Sample%20App/ChatEventsProcessor.swift)
  This file is responsible for filterring events, determining if events are new and updates and converts them to UI chat events.
  <br/>
* [ChatDelegateDateSource.swift](ZDCChatAPI%20Sample%20App/ChatDelegateDateSource.swift)
  This class provides the data required for the UI (TableView) and handles sending messages from the UI.
  <br/>
* [ChatUIEvent.swift](ZDCChatAPI%20Sample%20App/ChatUIEvent.swift)
  This file contains the protocols and structs that represents the different type of chat messages the demo deals with.
  <br/>

## Copyright and license

Copyright 2016 Zendesk

By dowloading or using the Zendesk Mobile SDK, You agree to the Zendesk Terms of Service
(https://www.zendesk.com/company/terms) and Application Developer and API License Agreement (https://www.zendesk.com/company/application-developer-and-api-license-agreement) and
acknowledge that such terms govern Your use of and access to the Mobile SDK.

If You make any Contributions (defined below) to the Zendesk Mobile SDK,
You hereby grant Zendesk a royalty-free, worldwide, transferable, sub-licensable,
irrevocable and perpetual license to incorporate into the Service or the Zendesk API
or otherwise use and commercially exploit any Contributions. “Contribution” shall mean
any work of authorship, including any modifications or additions to the Mobile SDK
or derivative works thereof, that is submitted to Zendesk by You.
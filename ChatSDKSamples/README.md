# ChatSDK Authentication

Basic Swift app showcasing Chat SDK with authentication setup.

### Getting started

#### JWT
1. Install JWT gem `gem install jwt`
2. Retrieve JWT Secret from [Chat Dashboard](https://support.zendesk.com/hc/en-us/articles/360022185594-Enabling-authenticated-visitors-in-the-integrated-Web-Widget#topic_s5k_dvq_4fb)
3. Paste into script
4. Run script

#### Application 

1. Make sure you have [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started) installed.
2. Run `pod update`
3. Fill in the Zendesk credentials in the `AppDelegate`.
4. _(Optional)_ Change the zendesk `themeColor` in `ViewController.swift`.
5. Run the app
6. Paste the token into the text field.
7. Press `set token`.
8. Start chat
9. Observe on Chat dashboard that the user is authenticated. See the [documentation](https://support.zendesk.com/hc/en-us/articles/360022185594-Enabling-authenticated-visitors-in-the-integrated-Web-Widget#topic_jsx_cvq_4fb) for more info.

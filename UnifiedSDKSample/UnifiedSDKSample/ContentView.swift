//
//  ContentView.swift
//  UnifiedSDKSample
//
//  Created by Zendesk on 13/04/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let themeColor: UIColor?
    @State private var answerBot = true
    @State private var chat = true

    var body: some View {
        NavigationView {
            VStack {
                Image("zendesk")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                Spacer()
                    .frame(width: 100, height: 20, alignment: .center)
                Text("SwiftUI Sample")
                Spacer()
                    .frame(width: 100, height: 20, alignment: .center)

                NavigationLink(destination: MessagingView(themeColor: themeColor,
                                                          answerBotEnabled: answerBot,
                                                          chatEnabled: chat)) {
                    Text("Start Messaging")
                }
                HStack {
                    Toggle(isOn: $answerBot) {
                        Text("Answer Bot")
                    }
                    Toggle(isOn: $chat) {
                        Text("Chat")
                    }
                }.padding(.horizontal, 40)
            }.padding(.bottom, 80)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(themeColor: nil)
    }
}

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
                NavigationLink(destination: MessagingView(themeColor: themeColor)) {
                    Text("Start Messaging")
                }
            }.padding(.bottom, 80)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(themeColor: nil)
    }
}

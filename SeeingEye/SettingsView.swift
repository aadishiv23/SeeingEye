//
//  SettingsView.swift
//  SeeingEye
//
//  Created by Aadi Shiv Malhotra on 8/2/23.
//

import Foundation
import SwiftUI

struct SettingsView :  View {
    var body: some View {
           VStack {
               HStack{
                   Text("Settings")
                       .font(.largeTitle)
                       .fontWeight(.bold)
                       .frame(maxWidth: .infinity, alignment: .leading)
                       .padding()
               }
               
               // TODO: your content goes here...
               Text("content...")
               Spacer() /// forces content to top
           }
       }
}

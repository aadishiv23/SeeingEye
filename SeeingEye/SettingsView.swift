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

/*
struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel(dataManager: DataManager()) // You'll need to replace DataManager() with your actual data manager
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Capture Settings")) {
                    Picker("Resolution", selection: $settingsViewModel.cPreset.value) {
                        ForEach(settingsViewModel.availableResolutions, id: \.self) { resolution in
                            Text(resolution.title).tag(resolution.value)
                        }

                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Picker("Zoom", selection: $settingsViewModel.zoom.value) {
                        ForEach(settingsViewModel.availableZoomLevels, id: \.value) { zoomLevel in
                            Text(settingsViewModel.formatZoomToText(zoom: zoomLevel.value)).tag(zoomLevel.value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Other Settings")) {
                    Toggle("Live Preview", isOn: $settingsViewModel.livePreview.value)
                    
                    Slider(value: $settingsViewModel.confidenceThreshold.value, in: 0...1, step: 0.01, label: {
                        Text("Confidence Threshold")
                    })
                    
                    Slider(value: $settingsViewModel.iouThreshold.value, in: 0...1, step: 0.01, label: {
                        Text("IOU Threshold")
                    })
                    
                    Toggle("Sound", isOn: $settingsViewModel.sound.value)
                    Toggle("Vibrate", isOn: $settingsViewModel.vibrate.value)
                }
                
                Section {
                    Button("Reset Settings", action: settingsViewModel.reset)
                }
            }
            .navigationBarTitle("Settings")
        }
        .onAppear(perform: settingsViewModel.initFetch)
    }
}

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
*/

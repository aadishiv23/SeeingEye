import SwiftUI

struct ContentView: View {
    @State private var showingSettings = false // A state variable to track whether the SettingsView is shown or not
    //@ObservedObject var observationModel: ObservationModel // Initialize this in your SceneDelegate

    
    var body: some View {
        NavigationView { // Wrap the content in a NavigationView
            ZStack(alignment: .bottom) { // Use ZStack to overlay the translucent box at the bottom
                HostedViewController()
                    .ignoresSafeArea()

                VStack {
                    //Spacer() // Move the Spacer here, so it pushes the content upwards
                
                    
                        HStack(alignment: .top) {
                            Spacer()
                            settingsButton
                            
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10)) // Add some padding to the button
                       
                        RoundedRectangle(cornerRadius: 10) // Add rounded corners to the VStack background
                            .foregroundColor(Color.gray.opacity(0.8)) // Set the color and opacity of the background
                            .frame(width: 300, height: 150) // Set the size of the square
                            .padding(.bottom, 10) // Add some padding to the square at the bottom
                       
                            
                }
                .padding() // Add some padding to the whole VStack
                .background(
                    Rectangle() // Add a transparent background to make the VStack background not cover the settings button
                        .foregroundColor(.clear)
                )
            }
            .background(
                NavigationLink(

                    destination: SettingsView(),
                    isActive: $showingSettings,
                    label: { EmptyView() }
                )
                .hidden() // Hide the actual link, only use for navigation
            )
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle to prevent iPad's sidebar navigation
    }
    
    var settingsButton: some View {
        Button(action: {
            showingSettings.toggle()
        }) {
            Image(systemName: "gearshape.fill")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .clipShape(Circle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

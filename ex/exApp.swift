//
//  exApp.swift
//  ex
//
//  Created by selindegirmenci on 10/15/23.
//

import SwiftUI
import Firebase
import Highcharts

@main
struct exApp: App {
    init() {
        FirebaseApp.configure()
        HIChartView.preload()
    }

    var body: some Scene {
        WindowGroup {
            //SplashScreenView()
            LoginView()
                .padding()
        }
    }
}

/*
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

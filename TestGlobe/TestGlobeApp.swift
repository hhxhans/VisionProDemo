//
//  TestGlobeApp.swift
//  TestGlobe
//
//  Created by hhx on 2023/10/11.
//

import SwiftUI

@main
struct TestGlobeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}

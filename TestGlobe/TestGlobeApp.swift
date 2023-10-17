//
//  TestGlobeApp.swift
//  TestGlobe
//
//  Created by hhx on 2023/10/11.
//

import SwiftUI

@main
struct TestGlobeApp: App {
    @State var AppImmersionStyle:ImmersionStyle = .mixed
    @StateObject var Usermodel:Appusermodel=Appusermodel()
    var body: some Scene {

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
        .immersionStyle(
            selection: $AppImmersionStyle,
            in: .mixed, .progressive, .full
        )
        WindowGroup {
            ContentView(AppImmersionstyle: $AppImmersionStyle)
                .environmentObject(Usermodel)
        }

    }
}

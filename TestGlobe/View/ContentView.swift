//
//  ContentView.swift
//  TestGlobe
//
//  Created by hhx on 2023/10/11.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Binding var AppImmersionstyle:ImmersionStyle
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
            VStack {
                //Model3D(named: "SquarewaveModel", bundle: realityKitContentBundle)
                //.rotation3DEffect(.init(degrees: 90), axis: (1,0,0))
                if !immersiveSpaceIsShown{
                    Image("squarewave")
                        .resizable().scaledToFit()
                        .padding(.bottom, 50)

                }
                

                Text("Squarewave Generator")

                Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                    .toggleStyle(.button)
                    .padding(.top, 50)
            }
            .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

extension ContentView{
    private var immersiveSpaceNotShownView:some View{
        VStack{
            Image("squarewave")
                .resizable().scaledToFit()
                .padding(.bottom, 50)
            Text("Squarewave Generator")
            
            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 50)
        }
    }
    
    private func immersiveSpaceIsShownView(SimualtionAreaGeometry:GeometryProxy)->some View{
        HStack{
            VStack{
                Text("Squarewave Generator")
                
                Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                    .toggleStyle(.button)
                    .padding(.top, 50)
            }
            SquarewaveextraView(outergeometry: SimualtionAreaGeometry)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(AppImmersionstyle: .constant(.full))
}

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
//    @State private var simulationImageExpand = false
    @EnvironmentObject var Usermodel:Appusermodel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        Group{
            if !immersiveSpaceIsShown{
                immersiveSpaceNotShownView
            }else{
                immersiveSpaceIsShownView(SimualtionAreaGeometry: nil)
            }

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
    
    private func immersiveSpaceIsShownView(SimualtionAreaGeometry:GeometryProxy?)->some View{
            VStack{
                if !Usermodel.SimulationImageExpand{
                    HStack{
                        Spacer()
                        VStack(alignment: .trailing){
                            Button("Mixed") {
                                AppImmersionstyle = .mixed
                            }
                            Button("Progressive") {
                                AppImmersionstyle = .progressive
                            }
                            Button("Full") {
                                AppImmersionstyle = .full
                            }
                        }
                        VStack{
                            Text("Squarewave Generator")
                            
                            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                                .toggleStyle(.button)
                                .padding(.top, 50)
                            
                            
                        }
                        Image("squarewave")
                            .resizable().scaledToFit()
                            .clipShape(.rect(cornerRadius: 5))
                            .padding(.bottom)
                    }.padding(.trailing)
                }
                GeometryReader{
                    SquarewaveextraView(outergeometry: $0)
                }
                .padding(.leading)
            }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(AppImmersionstyle: .constant(.full))
}

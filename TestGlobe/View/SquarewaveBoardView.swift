//
//  SquarewaveBoardView.swift
//  TestGlobe
//
//  Created by hhx on 2023/10/17.
//

import SwiftUI
import RealityKit
import RealityKitContent
struct SquarewaveBoardView: View {
    var body: some View {
        RealityView{content in
            if let immersiveContentEntity = try? await Entity(named: "SquarewaveModel", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Add an ImageBasedLight for the immersive content
                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                immersiveContentEntity.components.set(iblComponent)
                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))
            }
        }
    }
}

#Preview {
    SquarewaveBoardView()
}

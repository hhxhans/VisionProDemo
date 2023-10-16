//
//  SimulationViewGestures.swift
//  Ar trial
//
//  Created by 何海心 on 2023/6/16.
//

import SwiftUI

/// AsyncImage Drag gesture
func AsyncImageDraggesture(vm:ServercircuitViewModel)->some Gesture{
    DragGesture()
            .onChanged { value in
                if value.translation.height > 0 {
                    vm.imageyoffset=value.translation.height
                }
            }
            .onEnded { value in
                withAnimation(.spring()) {
                    if value.translation.height > 20 {
                        vm.imageforward()
                    }
                    vm.imageyoffset=0
                }
            }
}

/// Input area Drag gesture
func InputAreaDraggesture(vm:ServercircuitViewModel)->some Gesture{
    DragGesture()
            .onEnded { value in
                if value.translation.height > 20 {
                    vm.inputbackward()
                }
            }

}

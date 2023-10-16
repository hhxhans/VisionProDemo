//
//  SquarewaveView.swift
//  Ar trial
//
//  Created by niudan on 2023/4/18.
//

import SwiftUI
import Combine
//MARK: SquarewaveView
struct SquarewaveextraView: View {
    
    //View properties
    @EnvironmentObject var Usermodel:Appusermodel
    @StateObject var vm = ARsquarewavemodel()
    var outergeometry:GeometryProxy?
    

    var body: some View {
        let Geometrysize=outergeometry?.size ?? CGSize()
        Group{
            switch vm.status {
                //MARK: Start status view
            case .start:
                StartButton(
                    Buttonaction: vm.startforward
                )
                
                
                
                //MARK: Input status view
            case .input:
                ZStack{
                    VStack(alignment:.trailing,spacing:.zero){
                        VStack(alignment:.trailing,spacing:.zero){
                            InputupperLabel(backwardButtonaction: vm.inputbackward)
                            InputStoptimeTextField(leadingtext: "stoptime", Stoptimetext: $vm.stoptimetext, unittext: "s", TextfieldWidth: Geometrysize.width,TextFieldKeyboardTyperawValue: 2)
                            InputSlider(leadingtext: "RT:", Slidervalue: $vm.RT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "CT:", Slidervalue: $vm.CT, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "𝛍F")
                            InputSlider(leadingtext: "VCC:", Slidervalue: $vm.VCC, minimumValue: 1, maximumValue: 15, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "V")
                            InputSlider(leadingtext: "R1:", Slidervalue: $vm.R1, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R2:", Slidervalue: $vm.R2, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                            InputSlider(leadingtext: "R3:", Slidervalue: $vm.R3, minimumValue: 1, maximumValue: 1000, SlidervalueStep: 1, ValueLabelDecimalplaces: 0, unittext: "k𝛀")
                        }.frame(width:Geometrysize.width)
                            .padding(.horizontal,1)
                        InputConfirmButton(Buttondisable: !vm.Valuelegal()){
                            vm.inputforward(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationImagedisplay()
                        }
                    }.frame(width:Geometrysize.width)
                        .background(
                            InputbackgroundView()
                        )
                        .gesture(InputAreaDraggesture(vm:vm))
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
                
                
                //MARK: Image status view
            case .image:
                ZStack{
                    VStack(spacing:.zero){
                        SimulationImageupperLabel(RefreshButtondisable: Usermodel.SimulationimageRefreshDisable, imagezoom: vm.imagezoom, backwardButtonaction: vm.imagebackward) {
                            vm.imagerefresh(userurl: Usermodel.user.simulationurl)
                            Usermodel.SimulationimageRefreshDisable=true
                        } zoomButtonaction: {
                            withAnimation(Animation.spring()) {vm.imagezoom.toggle()}
                        }
                        Divider()
                        if let imageurl=vm.Simulationurl{
                            AsyncImage(url: imageurl) {
                                AsyncImageContent(phase: $0, geometrysize: Geometrysize, vm: vm)
                            }
                        }
                    }.frame(width: Geometrysize.width)
                        .padding(.horizontal,1)
                        .background(
                            SimulationImagebackgroundView()
                        )

                    //.frame(maxWidth: geometry.size.width*0.9)
                        .gesture(AsyncImageDraggesture(vm: vm))
                }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)
            }

        }
        .offset(y:-(outergeometry?.size.height ?? 0)*Usermodel.Circuitupdatetabheightratio)
        .onReceive(Usermodel.Timereveryonesecond, perform: Usermodel.SimulationImageRefreshCountdown)
    }
    
    
}


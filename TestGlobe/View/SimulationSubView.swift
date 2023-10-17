//
//  InputbackgroundView.swift
//  Ar trial
//
//  Created by niudan on 2023/5/17.
//

import SwiftUI


struct StartButton:View{
    @EnvironmentObject var Usermodel:Appusermodel
    let Buttonaction:()->Void
    var body: some View{
        ZStack{
            Button(action: Buttonaction) {
                Text("Simulation")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 2))
        }.frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .bottomTrailing)

    }
}
struct InputbackgroundView: View {
    var body:some View{
        RoundedRectangle(cornerRadius: 3).fill(Color.BackgroundprimaryColor.opacity(0.8))
    }
}
struct InputupperLabel: View {
    let backwardButtonaction:()->Void
    var body:some View{
        HStack{
            Button(action: backwardButtonaction) {
                Image(systemName: "chevron.down")
                    .font(.title2)
            }
            Spacer()
        }.padding(.bottom,5)
    }
}

struct InputStoptimeTextField: View {
    let leadingtext:String
    @Binding var Stoptimetext:String
    let unittext:String
    let TextfieldWidth:CGFloat?
    var TextFieldKeyboardTyperawValue:Int = 0
    var body:some View{
        HStack{
            Text(leadingtext)
            TextField("", text: $Stoptimetext)
                .keyboardType(UIKeyboardType(rawValue: TextFieldKeyboardTyperawValue) ?? .default)
                .frame(width:TextfieldWidth)
                .background(Color.gray.opacity(0.3).cornerRadius(1))
            Text(unittext)
        }.padding(.vertical,5)
    }
}

struct InputSlider: View {
    let leadingtext:String
    @Binding var Slidervalue:Double
    let minimumValue:Double
    let maximumValue:Double
    let SlidervalueStep:Double
    var ValueLabelDecimalplaces:Int=0
    let unittext:String
    var body:some View{
        HStack{
            Text(leadingtext)
            Slider(value: $Slidervalue, in: minimumValue...maximumValue, step: SlidervalueStep, label: {Text("")},
                   minimumValueLabel: {
                Text(String(format: "%.\(ValueLabelDecimalplaces)f",minimumValue))
            },
                   maximumValueLabel: {
                Text(String(format: "%.\(ValueLabelDecimalplaces)f",maximumValue))
            }) { _ in}
            Text(String(format: "%.\(ValueLabelDecimalplaces)f", Slidervalue)+unittext)
        }.padding(.vertical,5)

    }
}

struct InputSliderAreaView:View {
    let leadingtext:[String]
    var Slidervalue:[Binding<Double>]
    let minimumValue:[Double]
    let maximumValue:[Double]
    let SlidervalueStep:[Double]
    var ValueLabelDecimalplaces:[Int]
    let unittext:[String]
    let valuelegal:Bool
    init(leadingtext: [String], Slidervalue: [Binding<Double>], minimumValue: [Double], maximumValue: [Double], SlidervalueStep: [Double], ValueLabelDecimalplaces: [Int], unittext: [String]) {
        self.leadingtext = leadingtext
        self.Slidervalue = Slidervalue
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.SlidervalueStep = SlidervalueStep
        self.ValueLabelDecimalplaces = ValueLabelDecimalplaces
        self.unittext = unittext
        let length:[Int]=[leadingtext.count,Slidervalue.count,minimumValue.count,maximumValue.count,SlidervalueStep.count,ValueLabelDecimalplaces.count,unittext.count]
        self.valuelegal = length.max() != nil && length.max() == length.min()
    }
    
    init(leadingtext: [String], Slidervalue: [Binding<Double>], minimumValue: [Double], maximumValue: [Double], SlidervalueStep: [Double],unittext: [String]) {
        self.leadingtext = leadingtext
        self.Slidervalue = Slidervalue
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.SlidervalueStep = SlidervalueStep
        self.ValueLabelDecimalplaces = Array(repeating: 0, count: leadingtext.count)
        self.unittext = unittext
        let length:[Int]=[leadingtext.count,Slidervalue.count,minimumValue.count,maximumValue.count,SlidervalueStep.count,ValueLabelDecimalplaces.count,unittext.count]
        self.valuelegal = length.max() != nil && length.max() == length.min()
    }


    var body: some View {
        if valuelegal{
            VStack(alignment: .trailing, spacing: .zero){
                ForEach(leadingtext.indices,id: \.self){index in
                    InputSlider(leadingtext: leadingtext[index], Slidervalue: Slidervalue[index], minimumValue: minimumValue[index], maximumValue: maximumValue[index], SlidervalueStep: SlidervalueStep[index], ValueLabelDecimalplaces: ValueLabelDecimalplaces[index], unittext: unittext[index])
                }
            }
        }else{
            EmptyView()
        }
    }
}

struct InputConfirmButton: View {
    @EnvironmentObject var Usermodel:Appusermodel
    let Buttondisable:Bool
    let Buttonaction:()->Void
    var body:some View{
        Button(action: {
            Usermodel.Actiondate=Date()
            Buttonaction()
            
        }) {
            Text("Confirm")
                .foregroundColor(Buttondisable ? Color.secondary:Color.white)
        }
        .disabled(Buttondisable)
//            .buttonStyle(.borderedProminent)
//            .buttonBorderShape(.roundedRectangle(radius: 1))
    }
}

struct SimulationImagebackgroundView: View {
    var body:some View{
        RoundedRectangle(cornerRadius: 3).fill(Color.BackgroundprimaryColor.opacity(0.8))
    }
}

struct SimulationImageupperLabel: View {
    @EnvironmentObject var Usermodel:Appusermodel
    let RefreshButtondisable:Bool
    let imagezoom:Bool
    let backwardButtonaction:()->Void
    let refreshButtonaction:()->Void
    let zoomButtonaction:()->Void
    var body:some View{
        HStack{
            Button(action: backwardButtonaction) {
                Image(systemName: "arrow.left")
                    .font(.title2)
            }.padding(.trailing,5)
            Button(action:refreshButtonaction){
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundColor(RefreshButtondisable ? .secondary : .accentColor)
            }
            .padding(.trailing,5)
            .disabled(RefreshButtondisable)
            Button(action:{
                withAnimation(.easeInOut) {
                    Usermodel.SimulationImageExpand.toggle()
                }
            }){
                Image(systemName:Usermodel.SimulationImageExpand ? "arrow.down.right.and.arrow.up.left":"arrow.up.left.and.arrow.down.right")
                    .font(.title2)
            }
            .padding(.trailing,5)
            Spacer()
        }
    }
}

struct AsyncImageContent:View{
    let phase:AsyncImagePhase
    let geometrysize:CGSize
    @ObservedObject var vm:ServercircuitViewModel
    var body:some View{
        switch phase {
        case .empty:
            ZStack{
                ProgressView()
            }
        case .success(let returnedImage):
            returnedImage
                .resizable()
                .aspectRatio(nil, contentMode: .fit)
                .cornerRadius(3)
        case .failure:
            ZStack{
                Image(systemName: "questionmark")
                    .font(.headline)
            }
        default:
            Image(systemName: "questionmark")
                .font(.headline)
        }

    }

}

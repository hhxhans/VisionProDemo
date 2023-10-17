//
//  Usermodel.swift
//  Ar trial
//
//  Created by niudan on 2023/5/5.
//

import Foundation
import SwiftUI
import Combine

/// App function parts
enum AppFunction:String,CaseIterable,Identifiable{
    case AR="Augmented Reality"
    case OnlineTask="Online Task"
    case PhotoCache="Photo Cache"
    
    var id:String{rawValue}
    
    var MenuLabelString:String{
        switch self{
        case .AR:String(localized: "Augmented Reality")
        case .OnlineTask:String(localized: "Online Task")
        case .PhotoCache:String(localized: "Photo Cache")
        default:""
        }
    }

    
    var MenuLabelSystemImagename:String{
        switch self{
        case .AR:"cube.transparent"
        case .OnlineTask:"list.bullet.clipboard"
        case .PhotoCache:"photo.badge.arrow.down"
        default:""
        }
    }
}
/// The struct stores User information
struct ArappUser:Identifiable,Codable {
    /// user id
    var id:String="1"
    /// user password
    var password:String="1"
    /// user authority level,
    /// authority < 0 means unauthorized user
    /// authority >=0 allow user to log in
    var authority:Int = 1
    /// server address of sending requests
    var simulationurl:String="10.198.14.247:8000"
    var status:Bool=false
}



//MARK: Appusermodel
/// The model includes user information, app status, timers, view state vars
class Appusermodel:ObservableObject{
    //variables
    @Published var user: ArappUser
    /// 0 -> login status, 1 -> running status
    @Published var appstatus:Int
    var cancellables:Set<AnyCancellable>
    /// Log in view sign in button able bool, prevents user from sending frequent requests
    @Published var signinbuttonable: Bool
    @Published var loginfailalert:Bool
    let Timereveryonesecond:Publishers.Autoconnect<Timer.TimerPublisher>
    let Timerevery15second:Publishers.Autoconnect<Timer.TimerPublisher>
    let blurredShapestyle:AnyShapeStyle
    /// Simulation image refreshing button able bool, prevents user from refreshing image frequently
    @Published var SimulationimageRefreshDisable:Bool
    /// Minimum interval between two refresh requests
    @Published var refreshcount:Int
    /// User in signup view
    @Published var UserSignup:Bool
    /// Having sent signing up request
    @Published var Signingup:Bool
    /// Signing up request success
    @Published var Signupsuccess:Bool?
    @Published var Actiondate:Date
    @Published var Receivedate:Date
    let Urladdress:[String]
    let Circuitupdatetabheightratio:CGFloat
    let manager:PhotoCacheManager
    @Published var path: NavigationPath
    @Published var SimulationImageExpand:Bool

    
    init(){
        user=ArappUser()
        appstatus=0
        cancellables=Set<AnyCancellable>()
        signinbuttonable=true
        loginfailalert=false
        Timereveryonesecond = Timer.publish(every: 1, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
        Timerevery15second=Timer.publish(every: 15, tolerance: nil, on: .main, in: .common, options: nil).autoconnect()
        blurredShapestyle = .init(.ultraThinMaterial)
        SimulationimageRefreshDisable=false
        refreshcount=3
        UserSignup=false
        Signingup=false
        Signupsuccess=nil
        Actiondate=Date()
        Receivedate=Date()
        Urladdress=[
            "10.198.14.247:8000",
            "10.198.71.148:8000"
        ]
        Circuitupdatetabheightratio=0.08
        manager=PhotoCacheManager.instance
        path=NavigationPath()
        SimulationImageExpand=false
    }
    //MARK: Functions
    /// Returns whether the login view url is legal text
    /// - Returns: Whether the url match xxx.xxx.xxx.xxx:xxx syntax
    func Simulationurllegal()->Bool{
        var Urllinks:[String]=user.simulationurl.Droplastblankspaces.split(separator: ".").map { String($0)}
        guard Urllinks.count == 4 else{return false}
        let Urllinkslastsplit=Urllinks.last!.split(separator: ":").map { String($0)}
        Urllinks.removeLast()
        Urllinks.append(contentsOf: Urllinkslastsplit)
        guard Urllinks.count == 5 else{return false}
        for string in Urllinks {
            if Int(string) == nil {
                return false
            }
        }
        return true
    }
    
    /// Clears login view textfields texts
    func clearlogintype() -> Void {
        user=ArappUser(id:"",password: "",simulationurl: "")
    }
    
    /// Operation after user tap login button
    func loginconfirm(DismissAction:DismissAction,FirstLogin:Bool) -> Void {
        //Disable signin button
        signinbuttonable=false
        //Remove blank spaces at the end of login view textfields texts
        user.simulationurl.Removelastblankspaces()
        user.password.Removelastblankspaces()
        user.id.Removelastblankspaces()
        //Form url
        let urlstring:String="http://"+user.simulationurl+"/AR/Online/Confirm?username="+user.id+"&password="+user.password+"&url="+user.simulationurl
        guard let url = URL(string: urlstring) else {
            signinbuttonable=true
            user.authority = -1
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            //.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(Appusermodel.handleOutput)
            .decode(type: ArappUser.self, decoder: JSONDecoder())
            .replaceError(with: user)
            .sink{ [weak self] (returnedPosts) in
                //Enable signin button
                self?.signinbuttonable=true
                self?.user = returnedPosts
                //If response authority >= 0, log in. Else alert user
                if returnedPosts.authority >= 0{
                    self?.appstatus=1
                    if !FirstLogin {
                        DismissAction()
                    }
                }
                else{
                    self?.loginfailalert=true
                }
            }
            .store(in: &cancellables)
    }
    
    /// Operation after user tap logout button, reassign usermodel properties
    /// - Parameter FirstLogin: User first log in after entering app
    func logout(FirstLogin:Bool)->Void{
        //Save user id
        let username=user.id
        let url=user.simulationurl
        //Clean user password and url
        user=ArappUser(id:username,password:"",simulationurl: url)
        //Return to login view
        signinbuttonable=true
        loginfailalert=false
        SimulationimageRefreshDisable=false
        refreshcount=3
    }
    
    /// Operation when user tap signin button
    func Signup(username:String,password:String,signupurl:String,dismissAction:DismissAction)->Void{
        Signingup=true
        //Form url
        let urlstring:String="http://"+signupurl+"/AR/Online/Signup?username="+username+"&password="+password+"&url="+signupurl
        guard let url = URL(string: urlstring) else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map { Bool(String(data:$0.data,encoding: .ascii) ?? "false") }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
            } receiveValue: { [weak self] returnvalue in
                guard let unwrappedreturnvalue = returnvalue else{
//                    print("fail")
                    return
                }
                //Assign usermodel signup success var
                self?.Signupsuccess=unwrappedreturnvalue
                //Automatically quit signin view after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    dismissAction()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+2.3) {
                    self?.Signingup=false
                }
            }
            .store(in: &cancellables)
    }
    
    /// Operation when simulation AsyncImage appears, disable refresh button, start countdown 4s
    func SimulationImagedisplay() -> Void {
        SimulationimageRefreshDisable=true
        refreshcount=4
    }
    
    /// Countdown loop of 4s
    /// - Parameter Date: The output of timer
    func SimulationImageRefreshCountdown(Date:Date)->Void{
        if SimulationimageRefreshDisable{
            if refreshcount > 0{
                refreshcount -= 1
            }else{
                SimulationimageRefreshDisable=false
                refreshcount=3
            }
        }
    }
    
    
    //MARK: static functions
    /// Handle datatask output
    static func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    
}

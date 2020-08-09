//
//  HomeView.swift
//  swiftUIPractice
//
//  Created by Davia Belinda Hidayat on 21/07/20.
//  Copyright © 2020 Davia Belinda Hidayat. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
    @State var roomID = ""
    @State var isRoomIDFieldActive = false
    @State var value : CGFloat = 0
    
    @State var host = false
    @State var isRoomIDValid = false
    @State var roomIDToJoin = ""
    
    @State private var keyboardHeight: CGFloat = 0
    
    @State var isNavigationActive = false
    @State var showAlert = false
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    let lightBlue = Color(red: 177.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, opacity: 1.0)
    
    @ObservedObject var campService = CampService()
    
    @EnvironmentObject var globalStore: GlobalStore
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    Image("backgroundhome2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geometry.size.width)
                    VStack(alignment: .center){
                        Text("""
                        Buka pintu buka jendela.
                        Dari sebuah tanya berujung sebuah cerita,
                        Biar ga cuma saling bertukar pandang,
                        karena kata orang tak kenal maka tak sayang
                        """)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.size.width * 0.9, alignment: .center)
                            .padding(.top, UIScreen.main.bounds.height - (UIScreen.main.bounds.height - 50))
                        
                        
                        Text("Yuk kenal lebih dekat dengan")
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding(.top, 35)
                        
                        Text("SesamaMu")
                            .font(.system(size: 45, weight: .heavy, design: .default))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        
                        if self.isRoomIDFieldActive || !self.roomID.isEmpty {
                            HStack{
                                CustomTextField(text: self.$roomID, isFirstResponder: self.isRoomIDFieldActive)
                                    .padding()
                                    .frame(width: 250, height: 50)
                                    .background(self.lightBlue)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        self.isRoomIDFieldActive = true
                                        if self.isRoomIDFieldActive {
                                            self.value = self.keyboardHeight
                                        } else {
                                            self.value = 0
                                            self.isRoomIDFieldActive = false
                                        }
                                }
                                
                                NavigationLink(
                                    destination: AvatarView(host: false,
                                                            campCodeToEnter: self.roomIDToJoin)
                                                 .environmentObject(self.globalStore),
                                    isActive: self.$isNavigationActive) {
                                    
                                    Button(action: {
                                        if self.roomID.isEmpty {
                                            self.showAlert = true
                                            return
                                        }
                                        
                                        self.campService.findCamp(withCode: self.roomID) { (camp) in

                                            guard let camp = camp else {
                                                print("Not found")
                                                self.showAlert = true
                                                return
                                            }

                                            self.roomIDToJoin = camp.campCode
                                            self.isNavigationActive = true
                                        }
                                    }) {
                                        Image("rightButton")
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30)
                                    }.alert(isPresented: self.$showAlert) { () -> Alert in
                                        Alert(title: Text("Campnya ga ketemu"), message: Text("Diisi dulu yah kode nya... trus cek udah bener blum?"), dismissButton: .default(Text("Sip!")) )
                                    }
                                }.navigationBarBackButtonHidden(false)
                                    .navigationBarHidden(false)
                                
                            }.offset(y: self.isRoomIDFieldActive ? -200:0)
                            
                        }
                        
                        if !self.isRoomIDFieldActive && self.roomID.isEmpty {
                            Button(action: {
                                print("gabung camp tapped")
                                self.isRoomIDFieldActive = true
                            }) {
                                Image("gabungcamp")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, alignment: .center)
                            }
                        }
                        
                        if !self.isRoomIDFieldActive{
                            NavigationLink(
                                destination: AvatarView(host: true)
                                    .environmentObject(self.globalStore)) {
                                        
                                Image("buatcamp")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, alignment: .center)
                                    .padding(.bottom, UIScreen.main.bounds.height - (UIScreen.main.bounds.height-175))
                            }
                        }
                    }.KeyboardAwarePadding()
                        .animation(.spring())
                    
                    //.animation(.spring())
                    //.offset(y: -self.keyboardResponder.currentHeight*0.9)
                    
                }
            }.onTapGesture {
                self.isRoomIDFieldActive = false
                self.hideKeyboard()
            }.onAppear {
                print("MUNCUL LAGI")
            }
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(isNavigationActive)
    }
}

struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif



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
    
    @State private var keyboardHeight: CGFloat = 0
    
    let lightBlue = Color(red: 177.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, opacity: 1.0)
    
    
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .center){
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
                                }
                                
                                NavigationLink(destination: AvatarView(host: false)){
                                    Image("rightButton")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                }
                            }.offset(y: -160)
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
                            NavigationLink(destination: AvatarView(host: true)) {
                                Image("buatcamp")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 250, alignment: .center)
                                    .padding(.bottom, UIScreen.main.bounds.height - (UIScreen.main.bounds.height-175))
                            }
                        }
                        
                    }.offset(y: self.value)
                        .animation(.spring())
                        .keyboardAdaptive(onAppear: {
                            self.value = self.keyboardHeight
                            self.isRoomIDFieldActive = true
                        }, onHide: {
                            self.value = 0
                            self.isRoomIDFieldActive = false
                        })
                    
                }
            }.onTapGesture {
                self.hideKeyboard()
            }.onAppear {
                print("MUNCUL LAGI")
            }
            
        }
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

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    var onAppear: (()->())?
    var onHide: (()->())?
    
    
    func body(content: Content) -> some View {
        // 1.
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                // 2.
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    // 3.
                    //                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    //                    // 4.
                    //                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    //                    // 5.
                    //                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                    
                    print("\(keyboardHeight)")
                    
                    self.bottomPadding = keyboardHeight
                    
                    if keyboardHeight != 0 && self.onAppear != nil {
                        print("masukOnAppear")
                        self.onAppear!()
                    }
                    if keyboardHeight == 0 && self.onHide != nil {
                        print("masukOnHide")
                        self.onHide!()
                    }
                    
            }
                // 6.
                .animation(.easeOut(duration: 0.16))
        }
    }
    
}

extension View {
    func keyboardAdaptive(onAppear: ( () -> () )? = nil, onHide: ( ()->() )? = nil ) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive(onAppear: onAppear, onHide: onHide))
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    private static weak var _currentFirstResponder: UIResponder?
    
    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
    
    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

//
//  AvatarView.swift
//  swiftUIPractice
//
//  Created by Davia Belinda Hidayat on 22/07/20.
//  Copyright © 2020 Davia Belinda Hidayat. All rights reserved.
//

import SwiftUI

struct AvatarView: View {
    
    //var host: Bool
    @State private var counter = 1
    @State private var jumlahPemain = 5
    @State private var value : CGFloat = 0
    
    @State var host: Bool
    
    
    @State var namaPanggung = ""
    @State var namaAsli = ""
    
//    @ObservedObject var namaPanggung = "TextBindingManager(limit: 20)"
//    @ObservedObject var namaAsli = TextBindingManager(limit: 20)
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    let lightBlue = Color(red: 177.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, opacity: 1.0)
    
    @State var avatarList: [String] = ["binatang-1", "binatang-2", "binatang-3", "binatang-4", "binatang-5", "binatang-6", "binatang-7", "binatang-8", "binatang-9", "binatang-10", "binatang-11", "binatang-12", "binatang-13", "binatang-14", "binatang-15", "binatang-16"]
    
    var body: some View {
//        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Image("background2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                .frame(width: geometry.size.width)
                
                VStack(alignment: .center){
                    Text("Pilih karakter kamu!")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .default))
                    HStack{
                        Button(action: {
                            
                            if self.counter == 1 {
                                self.counter = 16
                            } else{
                                self.counter -= 1
                            }
                            
                            print(self.counter)
                            
                        }) {
                            Image("leftButton")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 60)
                                .padding(.leading, 30)
                        }
                        Spacer()
                        ZStack {
                            
                            Image("avatarBackground")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                            
                            Image("binatang-\(self.counter)")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 220, height: 220)
                        }
                        
                        Spacer()
                        Button(action: {
                            
                            if self.counter == 16 {
                                self.counter = 1
                            } else{
                                self.counter += 1
                            }
                            
                            print(self.counter)
                            
                        }) {
                            Image("rightButton")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 60)
                                .padding(.trailing, 30)
                        }
                    }
                    
                    Group{
                        Text("Kamu akan memasuki Camp dengan")
                        Text("identitas baru. Pilih") + Text(" karakter unik-mu").bold()
                        Text(" dan masukkan") + Text("nama panggung-mu.").bold()
                        Text("Jangan lupa sertakan") + Text(" nama aslimu!").bold()
                    }.foregroundColor(.white)
                        .font(.system(size: 15))
                    
                    Image("namaPanggung")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 20)
                    
                    TextField("Nama Panggung", text: self.$namaPanggung)
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.black)
                        .background(self.lightBlue)
                        .cornerRadius(12)
                    Image("namaAsli")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 140)
                    
                    TextField("Nama Asli", text: self.$namaAsli)
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.black)
                        .background(self.lightBlue)
                        .cornerRadius(12)
                    
                    if self.host {
                        VStack{
                            HStack {
                                Button(action: {
                                    
                                    if self.jumlahPemain == 1{
                                        self.jumlahPemain = 1
                                    } else {
                                        self.jumlahPemain -= 1
                                    }
                                    
                                }) {
                                    Image("minusButton")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding(.trailing, 30)
                                }
                                
                                Text("\(self.jumlahPemain)")
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    
                                    if self.jumlahPemain == 15{
                                        self.jumlahPemain = 15
                                    } else {
                                        self.jumlahPemain += 1
                                    }
                                }) {
                                    Image("plusButton")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding(.leading, 30)
                                }
                            }
                        }
                        
                        Image("gabungcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 50, alignment: .center)
                    } else{
                        NavigationLink(destination: ContentView()) {
                            Image("buatcamp")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 50, alignment: .center)
                                .padding(.top, UIScreen.main.bounds.height - (UIScreen.main.bounds.height - 70))
                        }
                    }
                    
                }
                .animation(.spring())
                .padding(.top, -100)
        }.KeyboardAwarePadding()
                .animation(.spring())
            .onTapGesture {
            self.hideKeyboard()
        }
//        }
        
    }
    
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(host: true)
    }
}

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int
    
    init(limit: Int = 5){
        characterLimit = limit
    }
}


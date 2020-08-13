//
//  MulaiMain.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 12/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct MulaiMain: View {
    var appIntro = "Buka pintu buka jendela. Dari sebuah tanya berujung sebuah cerita. Biar ga cuma saling bertukar pandang, karena kata orang tak kenal maka tak sayang"
    let lightBlue = Color(red: 177.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, opacity: 1.0)
    
    @State var gabungCampPressed = false
    @State var showAlert = false
    
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    @State var roomId = ""
    
    //DB
    @ObservedObject var campService = CampService()
    @State var roomIdToJoin = ""
    
    
    var body: some View {
        ZStack{
            Image("backgroundhome2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("\"")
                    .font(Font.custom("Montserrat-ExtraBoldItalic", size: 35))
                    .foregroundColor(.white)
                    .frame(width: 300, alignment: .leading)
                Text("\(self.appIntro)")
                    .font(Font.custom("Montserrat", size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                    .lineSpacing(4)
                Text("\"")
                    .font(Font.custom("Montserrat-ExtraBoldItalic", size: 35))
                    .foregroundColor(.white)
                    .frame(width: 300, alignment: .trailing)
                Text("Yuk kenal lebih dalam dengan")
                    .font(Font.custom("Montserrat-Bold", size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                Text("Sesamamu")
                    .font(Font.custom("Montserrat-Bold", size: 45))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                Spacer()
                if self.gabungCampPressed {
                    HStack{
                        CustomTextField(text: self.$roomId, isFirstResponder: self.gabungCampPressed)
                            .padding()
                            .frame(width: 210, height: 50)
                            .background(self.lightBlue)
                            .cornerRadius(12)
                        
                        Button(action: {
                            if !self.roomId.isEmpty {
                                print("Insert campId \(self.roomId)")
                                self.campService.findCamp(withCode: self.roomId) { (camp) in
                                    
                                    guard let camp = camp else {
                                        self.showAlert = true
                                        return
                                    }
                                    
                                    self.roomIdToJoin = camp.campCode
                                    self.globalStore.startPage = "SelectAvatar"
                                    self.globalStore.hostStart = false
                                    self.globalStore.roomName = self.roomIdToJoin
                                    self.hideKeyboard()
                                    print(self.globalStore.hostStart)
                                }
                            } else {
                                self.gabungCampPressed = false
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
                    }.keyboardAdaptive()
                        .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 1))
                } else {
                    Button(action: {
                        print("Gabung Camp Tapped")
                        self.gabungCampPressed = true
                    }) {
                        Image("gabungcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                            .padding(.top, 15)
                    }
                }
                Button(action: {
                    print("Buat Camp Tapped")
                    self.globalStore.startPage = "SelectAvatar"
                    self.globalStore.hostStart = true
                    
                }) {
                    Image("buatcamp")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 15)
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
        }.onAppear{
            playSound(sound: "sesamamuBGM2.mp3")
            audioPlayer.numberOfLoops = -1
        }
    }
    
}

struct MulaiMain_Previews: PreviewProvider {
    static var previews: some View {
        MulaiMain()
    }
}

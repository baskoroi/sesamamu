//
//  SelectAvatar.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 11/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct SelectAvatar: View {
    //Buat Camp
    @State var campCodeToEnter = ""
    @State private var counter = 1
    @State private var jumlahPemain = 5
    
    @State var host: Bool
    @State var namaPanggung = ""
    @State var namaAsli = ""
    
    //Only for joining a room
    @State var playersJoining = 0
    @State var roomStatus = ""
    @State var disableJoin = false
    
    //Alert
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    //Store data ke Global Store
    @State var currentPlayer = PlayerViewModel(isHost: false)
    @State var avatarList: [String] = ["binatang-1", "binatang-2", "binatang-3", "binatang-4", "binatang-5", "binatang-6", "binatang-7", "binatang-8", "binatang-9", "binatang-10", "binatang-11", "binatang-12", "binatang-13", "binatang-14", "binatang-15", "binatang-16"]
    
    let lightBlue = Color(red: 177.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, opacity: 1.0)
    
    //Service
    @ObservedObject var playerService = PlayerService()
    @ObservedObject var campService = CampService()
    
    var body: some View {
        ZStack{
            Image("background2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Pilih karakter kamu!")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold, design: .default))
                
                HStack {
                    Button(action: {
                        if self.counter == 1 {
                            self.counter = 16
                        } else{
                            self.counter -= 1
                        }
                    }) {
                        Image("leftButton")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 60)
                            .padding(.leading, 30)
                    }
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
                    Button(action: {
                        if self.counter == 16 {
                            self.counter = 1
                        } else{
                            self.counter += 1
                        }
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
                    Text(" dan masukkan ") + Text("nama panggung-mu.").bold()
                    Text("Jangan lupa sertakan") + Text(" nama aslimu!").bold()
                }.foregroundColor(.white)
                    .font(.system(size: 15))
                
                Group{
                    Image("namapanggung-30")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 20)
                    
                    TextField("Nama Panggung", text: self.$namaPanggung, onEditingChanged: { isTyping in
//                        if !self.host { return }
//
//                        if self.namaPanggung.isEmpty { return }
                        
                        if !isTyping {
                            self.campService.checkStageNameAvailability(
                                stageName: self.namaPanggung,
                                campCode: self.campCodeToEnter) { (isAvailable, error) in
                                if let err = error {
                                    self.roomStatus = "Nama panggung nya udah keambil, cari yang laen..."
                                    self.disableJoin = true
                                    return
                                }
                                    
                                self.disableJoin = !isAvailable
                                if isAvailable {
                                    self.roomStatus = "Okey, isi semuanya diatas abis itu join! :)"
                                }
                            }
                        }
                    })
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.black)
                        .background(self.lightBlue)
                        .cornerRadius(12)
                        .alert(isPresented: self.$showAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                
                Group{
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
                }
                
                if self.host {
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
                    
                    Button(action: {
                        if !self.namaPanggung.isEmpty && !self.namaAsli.isEmpty {
                            let playerData = PlayerViewModel(
                                stageName: self.namaPanggung,
                                realName: self.namaAsli,
                                avatarURL: "binatang-\(self.counter)",
                                isHost: true,
                                campID: "")
                            
                            self.campService.createCamp(playerViewModel: playerData, maxPlayers: self.jumlahPemain) { (camp, player) in
                                guard let camp = camp else {
                                    self.alertTitle = "Gagal membuat camp"
                                    self.alertMessage = "Maap server gagal proses bikin camp. Dicoba lagi yahh..."
                                    self.showAlert = true
                                    return
                                }
                                
                                self.campCodeToEnter = camp.campCode
                                print("new generated camp code \(self.campCodeToEnter)")
                                
                                // MARK: - store avatar yg kepilih ke database, store jumlah pemain, store nama panggung dan nama asli
                                self.playerService.createPlayer(viewModel: player) { (fetchedPlayer) in
                                    
                                    guard let fetchedPlayer = fetchedPlayer else {
                                        self.alertTitle = "Gagal membuat player"
                                        self.alertMessage = "Maap server gagal proses bikin player untuk camp nya. Dicoba lagi yahh..."
                                        self.showAlert = true
                                        return
                                    }
                                    
                                    self.currentPlayer = fetchedPlayer
                                    self.globalStore.roomName = self.campCodeToEnter
                                    self.globalStore.startPage = "WaitingRoom"
                                }
                            }
                        } else {
                            self.alertTitle = "Lengkapi inputnya..."
                            self.alertMessage = "Nama panggung sama nama aslinya jangan lupa diisi, dua-duanya yah..."
                            self.showAlert = true
                        }
                    }) {
                        Image("buatcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 50, alignment: .center)
                    }.alert(isPresented: self.$showAlert) {
                        Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                    }
                } else {
                    Button(action: {
                        if !self.namaPanggung.isEmpty && !self.namaAsli.isEmpty {

                            let playerData = PlayerViewModel(
                                stageName: self.namaPanggung,
                                realName: self.namaAsli,
                                avatarURL: "binatang-\(self.counter)",
                                isHost: false,
                                campID: self.campCodeToEnter)
                            self.currentPlayer = playerData

                            // MARK: join camp here (alr includes player creation)
                            print("masuk nih saya\(self.currentPlayer.realName)")
                            
                            self.campService.joinCamp(withCode: self.campCodeToEnter, playerCount: self.playersJoining, playerViewModel: playerData) { (canJoin, campCode, error) in
                                if error != nil || !canJoin {
                                    self.alertTitle = "Gagal masuk camp"
                                    self.alertMessage = "Ada error dari servernya. Coba tunggu sebentar trus masuk lagi :)"
                                    self.showAlert = true
                                    return
                                }
                                if canJoin {
                                    self.disableJoin = false
                                    self.globalStore.hostStart = false
                                    self.globalStore.startPage = "WaitingRoom"
                                    print("Bisa gabung")
                                }
                            }
                            print(self.globalStore.startPage)
                        } else {
                            self.alertTitle = "Lengkapi inputnya..."
                            self.alertMessage = "Nama panggung sama nama aslinya jangan lupa diisi, dua-duanya yah..."
                            self.showAlert = true
                        }
                    }) {
                        Image("gabungcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 50, alignment: .center)
                            .padding(.top, UIScreen.main.bounds.height - (UIScreen.main.bounds.height - 70))
                        
                    }
                    .alert(isPresented: self.$showAlert) {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                        // due to camp conditions, e.g. room is full, stage name already exists, etc.
                        .disabled(self.disableJoin)
                        .onAppear {
                            self.campCodeToEnter = self.globalStore.roomName
//                            print("Select Avatar View appear with campId: \(self.campCodeToEnter)")
//                            self.campService.countPlayersInCamp(campCode: self.campCodeToEnter) { (numPlayers, maxPlayers) in
//
//                                guard let numP = numPlayers, let maxP = maxPlayers else {
//                                    return
//                                }
//                                self.playersJoining = numP
//
//                                // only checked if room is not joined yet
//                                if numP > maxP {
//                                    self.alertTitle = "Camp nya full!"
//                                    self.alertMessage = "Coba pencet Back dan panggil temenmu yang ngadain camp nya..."
//                                    self.roomStatus = "Camp penuh. Boleh tunggu atau ke camp berikutnya..."
//                                    self.disableJoin = true
//                                    self.showAlert = true
//                                    return
//                                } else if numP == maxP {
//                                    self.roomStatus = "Camp sudah penuh, mencapai jumlah maksimum player..."
//                                    self.disableJoin = true
//                                    return
//                                }
//
//                                self.disableJoin = false
//                                self.roomStatus = "Okey, isi semuanya diatas abis itu join! :)"
//                            }
                    }
                }
                Text(roomStatus)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .padding(.bottom, 0)
            }
        }
    }
}

struct SelectAvatar_Previews: PreviewProvider {
    static var previews: some View {
        SelectAvatar(host: true)
    }
}

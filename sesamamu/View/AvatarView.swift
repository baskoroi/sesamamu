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
    @State var campCodeToEnter = "" // for both joining AND creating camp
    
    @State var namaPanggung = ""
    @State var namaAsli = ""
    
    @ObservedObject var keyboardResponder = KeyboardResponder()
    @ObservedObject var playerService = PlayerService()
    @ObservedObject var campService = CampService()
    
    @State var currentPlayer = PlayerViewModel(isHost: false)
    @State var isRoomCreated = false
    @State var isRoomJoined = false
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    // only for joining a room
    @State var playersJoining = 0
    @State var roomStatus = ""
    @State var disableJoin = false
    
    @EnvironmentObject var globalStore: GlobalStore
    
    let lightBlue = Color(red: 177.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, opacity: 1.0)
    
    // MARK: - store avatar ke database
    
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
            
            VStack(alignment: .center) {
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
                    Text(" dan masukkan ") + Text("nama panggung-mu.").bold()
                    Text("Jangan lupa sertakan") + Text(" nama aslimu!").bold()
                }.foregroundColor(.white)
                    .font(.system(size: 15))
                
                Image("namaPanggung")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding(.top, 20)
                
                TextField("Nama Panggung", text: self.$namaPanggung, onEditingChanged: { isTyping in
                    if !self.host { return }
                    
                    if self.namaPanggung.isEmpty { return }
                    
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
                    
                    NavigationLink(
                        destination: RoomPlayer(isHost: self.host,
                                                roomName: self.campCodeToEnter,
                                                currentPlayer: self.currentPlayer)
                            .environmentObject(self.globalStore),
                        isActive: $isRoomCreated) {
                        
                        Button(action: {
                            
                            guard !self.namaPanggung.isEmpty && !self.namaAsli.isEmpty else {
                                self.alertTitle = "Lengkapi inputnya..."
                                self.alertMessage = "Nama panggung sama nama aslinya jangan lupa diisi, dua-duanya yah..."
                                self.showAlert = true
                                return
                            }
                            
                            // Camp ID is emptied here, since the ID will be generated inside PlayerService during camp creation
                            let playerViewModel = PlayerViewModel(
                                stageName: self.namaPanggung,
                                realName: self.namaAsli,
                                avatarURL: "binatang-\(self.counter)",
                                isHost: true,
                                campID: "")

                            self.campService.createCamp(
                                playerViewModel: playerViewModel,
                                maxPlayers: self.jumlahPemain) { (camp, player) in
                                    
                                guard let camp = camp else {
                                    self.alertTitle = "Gagal membuat camp"
                                    self.alertMessage = "Maap server gagal proses bikin camp. Dicoba lagi yahh..."
                                    self.showAlert = true
                                    return
                                }
                                
                                self.campCodeToEnter = camp.campCode
                                
                                // MARK: - store avatar yg kepilih ke database, store jumlah pemain, store nama panggung dan nama asli
                                self.playerService.createPlayer(viewModel: player) { (fetchedPlayer) in
                                    
                                    guard let fetchedPlayer = fetchedPlayer else {
                                        self.alertTitle = "Gagal membuat player"
                                        self.alertMessage = "Maap server gagal proses bikin player untuk camp nya. Dicoba lagi yahh..."
                                        self.showAlert = true
                                        return
                                    }
                                    
                                    self.currentPlayer = fetchedPlayer
                                    self.isRoomCreated = true
                                }
                            }
                            
                        }) {
                            
                            Image("buatcamp")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 50, alignment: .center)
                            
                        }
                    }.alert(isPresented: self.$showAlert) {
                        Alert(title: Text(self.alertTitle), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
                    }
                } else {
                    
                    NavigationLink(
                        destination: RoomPlayer(isHost: self.host,
                                                roomName: self.campCodeToEnter,
                                                currentPlayer: self.currentPlayer)
                            .environmentObject(self.globalStore),
                        isActive: self.$isRoomJoined) {
                            
                        Button(action: {
                            
                            guard !self.namaPanggung.isEmpty && !self.namaAsli.isEmpty else {
                                self.alertTitle = "Lengkapi inputnya..."
                                self.alertMessage = "Nama panggung sama nama aslinya jangan lupa diisi, dua-duanya yah..."
                                self.showAlert = true
                                return
                            }
                            
                            let playerViewModel = PlayerViewModel(stageName: self.namaPanggung, realName: self.namaAsli, avatarURL: "binatang-\(self.counter)", isHost: false, campID: self.campCodeToEnter)
                            self.currentPlayer = playerViewModel
                            
                            // MARK: join camp here (alr includes player creation)
                            self.campService.joinCamp(withCode: self.campCodeToEnter, playerCount: self.playersJoining, playerViewModel: playerViewModel) { (canJoin, campCode, error) in
                                if error != nil || !canJoin {
                                    self.alertTitle = "Gagal masuk camp"
                                    self.alertMessage = "Ada error dari servernya. Coba tunggu sebentar trus masuk lagi :)"
                                    self.showAlert = true
                                    return
                                }
                                
                                if canJoin {
                                    self.disableJoin = false
                                }
                                
                                self.isRoomJoined = true
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
                    }
                    // due to camp conditions, e.g. room is full, stage name already exists, etc.
                    .disabled(self.disableJoin)
                    .onAppear {
                        print("avatar view muncul")
                        
                        self.campService.countPlayersInCamp(campCode: self.campCodeToEnter) { (numPlayers, maxPlayers) in
                            
                            guard let numP = numPlayers, let maxP = maxPlayers else {
                                return
                            }
                            
                            self.playersJoining = numP
                            
                            // only checked if room is not joined yet
                            if numP > maxP {
                                self.alertTitle = "Camp nya full!"
                                self.alertMessage = "Coba pencet Back dan panggil temenmu yang ngadain camp nya..."
                                self.roomStatus = "Camp penuh. Boleh tunggu atau ke camp berikutnya..."
                                self.disableJoin = true
                                self.showAlert = true
                                return
                            } else if numP == maxP {
                                self.roomStatus = "Camp sudah penuh, mencapai jumlah maksimum player..."
                                self.disableJoin = true
                                return
                            }
                            
                            self.disableJoin = false
                            self.roomStatus = "Okey, isi semuanya diatas abis itu join! :)"
                        }
                    }
                }
                Text(roomStatus)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .padding(.bottom, 0)
            }
            .animation(.spring())
            .padding(.top, -100)
        }
        .KeyboardAwarePadding()
        .animation(.spring())
        .onTapGesture {
            self.hideKeyboard()
        }
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


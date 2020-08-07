//
//  Explanation.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//
import SwiftUI
import Firebase

struct Explanation: View {
    
    @EnvironmentObject var globalStore: GlobalStore
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                ExplanationView()
                    .environmentObject(self.globalStore)
            }.navigationBarHidden(true)
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct Explanation_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            Explanation().previewDevice("iPhone 11")
            Explanation().previewDevice("iPhone 8")
        }
    }
}


struct ExplanationView: View {
    //Intro to question
    @State var ronde: Int = 1
    @State var rondeIntro: String = "Pengen kenalan tapi malu nanya duluan. Daripada diem-dieman, Yaudah kita bantu dengan pertanyaan"
    @State var rondeDesc: String = "Di ronde ini kamu akan diberikan pertanyaan random. Jangan takut, ini cuma pemanasan. Ga ada jawaban benar dan salah kok. Selamat bermain!"
    
    //Timer
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var appEnterForeground = true
    @State var counter: Int = 0
    var countTo: Int = 3
    
    //NavigationLink
    @State private var readyToMove = false
    
    @EnvironmentObject var globalStore: GlobalStore
    
    var body: some View {
        ZStack{
            Image("backgroundRonde1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Ronde \(self.ronde)")
                    .font(Font.custom("Montserrat-Bold", size: 35))
                    .foregroundColor(.white)
                    .padding(.top, UIScreen.main.bounds.height*0.05)
                VStack{
                    Text("\"")
                        .font(Font.custom("Montserrat-ExtraBoldItalic", size: 35))
                        .foregroundColor(.white)
                        .frame(width: 250, alignment: .leading)
                    Text("\(self.rondeIntro)")
                        .font(Font.custom("Montserrat-BoldItalic", size: 15))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                        .lineSpacing(4)
                    Text("\"")
                        .font(Font.custom("Montserrat-ExtraBoldItalic", size: 35))
                        .foregroundColor(.white)
                        .frame(width: 250, alignment: .trailing)
                }.padding(.top, UIScreen.main.bounds.height*0.01)
                Spacer()
                Text("\(self.rondeDesc)")
                    .font(Font.custom("Montserrat", size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300)
                ZStack{
                    ProgressTrack()
                    ProgressBar(counter: counter, countTo: countTo)
                }.padding(.top, 10)
                NavigationLink(destination: Question().environmentObject(self.globalStore), isActive: $readyToMove) {
                    EmptyView()
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
//                .offset(y: -UIScreen.main.bounds.height*0.05)
        }.onReceive(timer) { time in
            guard self.appEnterForeground else { return }
            if (self.counter < self.countTo) {
                self.counter += 1
            } else if (self.counter == self.countTo){
                //stop timer
                self.timer.upstream.connect().cancel()
                self.readyToMove = true
                print("Pindah yukks")
            }
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.appEnterForeground = false
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.appEnterForeground = true
        }
    }
}

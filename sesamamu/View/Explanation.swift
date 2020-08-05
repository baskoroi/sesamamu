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
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                ExplanationView()
            }
        }.navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
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

    @State var ronde: String = "Ronde 1"
    @State var rondeIntro: String = "Pengen kenalan tapi malu nanya duluan. Daripada diem-dieman, Yaudah kita bantu dengan pertanyaan"
    @State var rondeDesc: String = "Di ronde ini kamu akan diberikan pertanyaan random. Jangan takut, ini cuma pemanasan. Ga ada jawaban benar dan salah kok. Selamat bermain!"
    
    @State var isReady: Bool = false
    @State var numberOfPlayerAvailable: Int = 15
    @State var numberOfPlayerReady: Int = 15
    
//    @ObservedObject var playerReady = AllPlayerReady()
    
    
    
    var body: some View {
        ZStack{
            Image("backgroundRonde1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("\(self.ronde)")
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
                HStack{
                    if numberOfPlayerReady == numberOfPlayerAvailable {
                        ForEach(0..<numberOfPlayerReady){ index in
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                                .padding(.top, 30)
                        }
                    } else if numberOfPlayerReady > 0{
                        ForEach(0..<numberOfPlayerReady){ index in
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                                .padding(.top, 30)
                        }
                        ForEach(0..<self.numberOfPlayerAvailable-numberOfPlayerReady){ index in
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                                .padding(.top, 30)
                        }
                    } else {
                        ForEach(0..<numberOfPlayerAvailable){ index in
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.gray)
                                .padding(.top, 30)
                        }
                    }
                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
        }
    }
}

//class AllPlayerReady: ObservableObject {
//    @State var numberOfPlayerAvailable: Int = 15
//
//    @Published var numberOfPlayerReady: Int = 0 {
//        didSet{
//            if numberOfPlayerAvailable == numberOfPlayerReady {
//                print("Sama inih")
//            }
//        }
//    }
//}

//class TextCount: ObservableObject {
//    var charCount:Int = 0
//
//    @Published var userTextInput:String = ""{
//        didSet{
//            charCount = userTextInput.count
//            print(charCount)
//        }
//    }
//}

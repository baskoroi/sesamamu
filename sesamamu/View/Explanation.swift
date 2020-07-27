//
//  Explanation.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct Explanation: View {
    @State var ronde: String = "Ronde 1"
    @State var rondeIntro: String = "Pengen kenalan tapi malu nanya duluan. Daripada diem-dieman, Yaudah kita bantu dengan pertanyaan"
    @State var rondeDesc: String = "Di ronde ini kamu akan diberikan pertanyaan random. Jangan takut, ini cuma pemanasan. Ga ada jawaban benar dan salah kok. Selemat bermain!"
    @State var isReady: Bool = false
    @State var numberOfPlayerReady: Int = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("backgroundhome2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text("\(self.ronde)")
                        .font(.system(size: 41, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    VStack{
                        Text("\"")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 250, alignment: .leading)
                        Text("\(self.rondeIntro)")
                            .font(.system(size: 17, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: 300)
                        Text("\"")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 250, alignment: .trailing)
                    }
                    Spacer()
                    Text("\(self.rondeDesc)")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: 300)
                    HStack{
                        ForEach(0..<self.numberOfPlayerReady){ index in
                            if self.isReady {
                                Circle()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.white)
                                    .padding(.top, 30)
                            } else {
                                Circle()
                                    .frame(width: 12, height: 12)
                                    .foregroundColor(.gray)
                                    .padding(.top, 30)
                            }
                        }
                    }
                }.frame(height: UIScreen.main.bounds.height*0.9)
            }
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


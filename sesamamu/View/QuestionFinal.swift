//
//  QuestionFinal.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct QuestionFinal: View {
    var ronde: String = "Ronde 3"
    var rondeIntro: String = "Kalau kamu punya kesempatan untuk kenal dia lebih dalam dengan sebuah pertanyaan\n\nMau tanya apa??..."
    
    @State var userInput:String = ""
    
    @ObservedObject var textCount = TextCount()
        
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
                    ZStack{
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.15)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        
                        MultilineTextField("Tanya di sini ya", text: self.$textCount.userTextInput, charLimit: 150, onCommit: {
                            self.userInput = self.textCount.userTextInput
                            print("Final text: \(self.userInput)")
                        })
                            .frame(width: UIScreen.main.bounds.width*0.85)
                            .font(.system(size: 18))
                        
                        if self.textCount.charCount < 120 {
                            Text ("\(self.textCount.charCount)/150")
                                .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        } else if self.textCount.charCount < 145{
                            Text ("\(self.textCount.charCount)/150")
                                .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                                .font(.system(size: 15))
                                .foregroundColor(.yellow)
                        } else {
                            Text ("\(self.textCount.charCount)/150")
                                .frame(width: UIScreen.main.bounds.width*0.80, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                                .font(.system(size: 15))
                                .foregroundColor(.red)
                        }
                    }.keyboardAdaptive()
                        .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 1))
                    
                    Button(action: {
                        print("Kirim tapped")
                        //MARK: - Save data to DB for vote
                        print("Final text: \(self.userInput)")
                    }) {
                        Image("buatcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                            .padding(.top, 15)
                    }
                }.frame(height: UIScreen.main.bounds.height*0.9)
            }.onTapGesture {self.hideKeyboard()}
        }
    }
}

struct QuestionFinal_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            QuestionFinal().previewDevice("iPhone 11")
            QuestionFinal().previewDevice("iPhone 8")
        }
    }
}

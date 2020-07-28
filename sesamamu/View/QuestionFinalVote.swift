//
//  QuestionFinalVote.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct QuestionFinalVote: View {
    var rondeIntro: String = "Pilih 3 pertanyaan yang paling menarik hati"
    var finalRoundQuestionVote = ["Bagian tubuh favoritemu?", "Kalo besok kiamat apa yang bakal kamu lakuin hari ini?", "Lo pake kacamata atau ga?", "Sebutin ciri-ciri lo yang paling unik!!", "Siapa pirs lopemu?", "Kalau udah gede mau jadi apa?"]
    
    var chooseQ:[String] = ["hello"]
    @State var selectedIndex = [Int]()
    
    @State private var tooMuch = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("backgroundhome2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    ScrollView{
                        ForEach(0..<self.finalRoundQuestionVote.count) { index in
                            ZStack{
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.12)
                                    .foregroundColor(self.selectedIndex.contains(index) ? .yellow : .white)
                                    .cornerRadius(12)
                                VStack{
                                    Text("Pertanyaan \(index+1)")
                                        .font(.system(size: 17, weight: .bold, design: .default))
                                    Text("\(self.finalRoundQuestionVote[index])")
                                        .font(.system(size: 17))
                                        .padding(.top, 10)
                                        .multilineTextAlignment(.center)
                                }.padding(.horizontal, 40)
                            }.onTapGesture {
                                if self.selectedIndex.contains(index){
                                    if let pos = self.selectedIndex.firstIndex(of: index) {
                                        self.selectedIndex.remove(at: pos)
                                    }
                                } else {
                                    if self.selectedIndex.count > 2 {
                                        self.tooMuch = true
                                    } else {
                                        self.selectedIndex.append(index)
                                        print(self.selectedIndex)
                                    }
                                }
                            }.alert(isPresented: self.$tooMuch) {
                                Alert(title: Text("Kebanyakan kakak"), message: Text("Pilih 3 aja ya, jangan serakah"), dismissButton: .default(Text("Siaap!")))
                            }.padding(.vertical, 5)
                        }.listRowBackground(Color.blue)
                    }
                    
                    Text("\(self.rondeIntro)")
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    Button(action: {
                        print("Pilih tapped")
                    }) {
                        Image("buatcamp")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                    }
                }.frame(height: UIScreen.main.bounds.height*0.9)
            }
        }
    }
}

struct QuestionFinalVote_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            QuestionFinalVote().previewDevice("iPhone 11")
            QuestionFinalVote().previewDevice("iPhone 8")
        }
    }
}

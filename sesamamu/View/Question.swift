//
//  Question.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct Question: View {
    //DB
    @State var ronde: String = "Ronde 1"
    @State var question: String = "Ada seorang gadis bernama Angel. Angel pergi membawa uang 70.000 untuk membeli sebuah buku seharga 50.000. Di jalan Angel beli bubur seharga 25.000. Kalau kamu jadi Angel, buburnya diaduk ga? Filosofinya?"
        
//    static var test:String = ""
//    static var testBinding = Binding<String>(get: { test }, set: { test = $0 } )
    @State var userInput:String = ""
    
    @ObservedObject var textCount = TextCount()

    @State var offSetValueForKeyboard: CGFloat = 0

    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image("backgroundhome2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text("\(self.ronde)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Text("Pertanyaan 1/3")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                    Rectangle()
                        .frame(width: 30, height: 3)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    VStack{
                        Text("\(self.question)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(width: UIScreen.main.bounds.width*0.8)
                    }
                    Spacer()
                    ZStack{
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.15)
                            .foregroundColor(.white)
                            .cornerRadius(12)
            
                        MultilineTextField("Jawab di sini ya", text: self.$textCount.userTextInput, charLimit: 150, onCommit: {
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
                    }.onAppear(perform: self.pushForKeyboard)
                    .offset(y: -self.offSetValueForKeyboard*0.7)
                    .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 1))
                    
                    Button(action: {
                        print("Kirim tapped")
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
    
    func pushForKeyboard() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { key in
            let value = key.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.offSetValueForKeyboard = value.height
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { key in
            self.offSetValueForKeyboard = 0
        }
    }
}

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            Question().previewDevice("iPhone 11")
            Question().previewDevice("iPhone 8")
        }
    }
}

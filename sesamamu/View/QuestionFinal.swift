//
//  QuestionFinal.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 27/07/20.
//  Copyright ©️ 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI
import Firebase

struct QuestionFinal: View {
    var body: some View {
        GeometryReader { geometry in
            QuestionFinalView()
        }.onTapGesture {self.hideKeyboard()}
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

struct QuestionFinalView: View {
    //Global Store
    @EnvironmentObject var globalStore: GlobalStore
    
    //DB
    @ObservedObject var questionServices = QuestionServices()

    var ronde: String = "Ronde 3"
    var rondeIntro: String = "Kalau kamu punya kesempatan untuk kenal dia lebih dalam dengan sebuah pertanyaan\n\nMau tanya apa??..."
    
    //User Input
    @State var userInput:String = ""
//    @ObservedObject var textCount = TextCount()
    
    //Alert
    @State private var textFieldEmpty = false
    
    //NavigationLink
    @State private var readyToMove = false
        
    var body: some View {
        ZStack{
            Image("backgroundRonde3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("\(self.ronde)")
                    .font(Font.custom("Montserrat-Bold", size: 35))
                    .foregroundColor(.white)
                    .padding(.top, 10)
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
                ZStack{
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.15)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    
                    MultilineTextField("Tanya di sini ya", text: self.$userInput, charLimit: 150)
                        .frame(width: UIScreen.main.bounds.width*0.85)
                        .font(.system(size: 18))
                    
                    if self.userInput.count < 120 {
                        Text ("\(self.userInput.count)/150")
                            .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    } else if self.userInput.count < 145{
                        Text ("\(self.userInput.count)/150")
                            .frame(width: UIScreen.main.bounds.width*0.85, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                            .font(.system(size: 15))
                            .foregroundColor(.yellow)
                    } else {
                        Text ("\(self.userInput.count)/150")
                            .frame(width: UIScreen.main.bounds.width*0.80, height: UIScreen.main.bounds.height*0.13, alignment: .bottomTrailing)
                            .font(.system(size: 15))
                            .foregroundColor(.red)
                    }
                }.keyboardAdaptive()
                    .animation(.spring(response: 0.7, dampingFraction: 0.5, blendDuration: 1))
                
                Button(action: {
                    print("Kirim tapped")
                    print("Kamarnya ini nih \(self.globalStore.roomName)")
                    //MARK: - Save data to DB for vote
                    let answerText = self.userInput
                    if !self.userInput.isEmpty {
                        self.questionServices.submitFinalQuestion(campId: self.globalStore.roomName, userQuestion: answerText)
                        self.readyToMove = true
                        self.globalStore.page = "QuestionFinalVote"

                    } else {
                        self.textFieldEmpty = true
                    }
                }) {
                    Image("buttonKirim")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .padding(.top, 15)
                }.alert(isPresented: self.$textFieldEmpty) {
                    Alert(title: Text("Masih kosong nih"), message: Text("Hati aja perlu di isi, isiannya jangan lupa diisi juga ya kak"), dismissButton: .default(Text("Tjakep!")))}
//                NavigationLink(destination: QuestionFinalVote(), isActive: $readyToMove) {
//                    EmptyView()
//                }
            }.frame(height: UIScreen.main.bounds.height*0.9)
                .offset(y: -UIScreen.main.bounds.height*0.05)
        }
    }
}

//
//  AllAnswersView.swift
//  sesamamu
//
//  Created by Baskoro Indrayana on 07/28/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct AllAnswersView: View {

    @State private var answers: [AnswerViewModel] = [
        AnswerViewModel(nickname: "maung", message: "beliminumnyadulukak. huruf kecil semua", avatarURL: "binatang-1", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "BIBIBIBI", message: "admin123", avatarURL: "binatang-2", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "LALAHOAM", message: "baginotelpnyadunk", isMyOwn: true, avatarURL: "binatang-3", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "maung", message: "beliminumnyadulukak. huruf kecil semua", avatarURL: "binatang-1", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "BIBIBIBI", message: "admin123", avatarURL: "binatang-2", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "LALAHOAM", message: "baginotelpnyadunk", isMyOwn: true, avatarURL: "binatang-3", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "maung", message: "beliminumnyadulukak. huruf kecil semua", avatarURL: "binatang-1", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "BIBIBIBI", message: "admin123", avatarURL: "binatang-2", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "LALAHOAM", message: "baginotelpnyadunk", isMyOwn: true, avatarURL: "binatang-3", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "maung", message: "beliminumnyadulukak. huruf kecil semua", avatarURL: "binatang-1", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "BIBIBIBI", message: "admin123", avatarURL: "binatang-2", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
        AnswerViewModel(nickname: "LALAHOAM", message: "baginotelpnyadunk", isMyOwn: true, avatarURL: "binatang-3", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white),
    ]
    
    var body: some View {
        VStack {
            // MARK: Question in quotes
            QuotedQuestionView()
                .padding(.top, 36)
            
            // MARK: List of answers (chat-like UI)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(answers, id: \.self) { answer in
                        AnswerCell(viewModel: answer)
                    }
                }
            }
            
            // MARK: Continue button
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Lanjut")
                    .font(Font.custom("Montserrat-Bold", size: 28))
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 72)
                    .padding(.vertical, 12)
                    .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(red: 0.19, green: 0.425, blue: 0.431)))
                    .padding(.bottom, 24)
            }
        }
        .modifier(FullScreen())
        .background(Image("backgroundhome2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

struct FullScreen: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

struct AllAnswersView_Previews: PreviewProvider {
    static var previews: some View {
        AllAnswersView()
    }
}

struct QuotedQuestionView: View {
    
    @State private var questionText = "Password Wi-Fi teraneh? Panjangin lagiiiiiiiiii........ TEROS Panjangin lagiiiiiiiiii........ Dipanjangin"
    var quotePaddingMultiplier: CGFloat {
        return questionText.isEmpty ? 1 : CGFloat(questionText.count / 20)
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(",,")
                .font(Font.custom("Montserrat-BoldItalic", size: 48))
                .foregroundColor(.white)
                .rotationEffect(.init(degrees: 180))
                .alignmentGuide(.top, computeValue: { dimension in
                    dimension[VerticalAlignment.top]
                }).padding(.top, -12 * CGFloat(quotePaddingMultiplier))
            Text(self.questionText)
                .font(Font.custom("Montserrat-BoldItalic", size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Text(",,")
                .font(Font.custom("Montserrat-BoldItalic", size: 48))
                .foregroundColor(.white)
                .padding(.bottom, -12 * CGFloat(quotePaddingMultiplier))
            
        }
    }
}

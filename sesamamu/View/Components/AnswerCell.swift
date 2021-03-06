//
//  AnswerCell.swift
//  sesamamu
//
//  Created by Baskoro Indrayana on 07/28/20.
//  Copyright © 2020 Baskoro Indrayana. All rights  reserved.
//

import SwiftUI

struct AnswerCell: View {
    
    let viewModel: AnswerViewModel!
    
    let nicknameFont = FontSelector.AllAnswers.nicknameFont
    let messageFont  = FontSelector.AllAnswers.messageFont
    
    public var body: some View {
        
        HStack {
            if viewModel.isMyOwn {
                Spacer()
                VStack(alignment: .trailing) {
                    Text("(you) \(viewModel.stageName!)").font(nicknameFont).bold()
                        .foregroundColor(.white)
                    Text(viewModel.answerText!)
                        .font(messageFont)
                        .padding(.all, 12)
                        .background(viewModel.backgroundColor)
                        .cornerRadius(12)
                        .foregroundColor(viewModel.foregroundColor)
                }
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    Image("avatarBackground")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                    Image(viewModel.avatarURL!).resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42, alignment: .center)
                }
            } else {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    Image("avatarBackground")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                    Image(viewModel.avatarURL!).resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42, alignment: .leading)
                }
                
                VStack(alignment: .leading) {
                    Text(viewModel.stageName!).font(nicknameFont).bold()
                        .foregroundColor(.white)
                    Text(viewModel.answerText!)
                        .font(messageFont)
                        .padding(.all, 12)
                        .background(viewModel.backgroundColor)
                        .cornerRadius(12)
                        .foregroundColor(viewModel.foregroundColor)
                }
                Spacer()
            }
        }.padding(.horizontal, 16)
    }
}

struct AnswerCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AnswerCell(viewModel: AnswerViewModel(stageName: "cow ada di hatiku", answerText: "his test answerText is here, and this is his longer sentence to visualize to you how the cell expands", isMyOwn: false, avatarURL: "binatang-1", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white))
            AnswerCell(viewModel: AnswerViewModel(stageName: "tigerman", answerText: "this is your own answerText, you might speak a little or much... I don't know :)", isMyOwn: true, avatarURL: "binatang-2", timestamp: Date().timeIntervalSince1970, foregroundColor: .black, backgroundColor: .white))
        }.background(Color(red: 0.059, green: 0.154, blue: 0.209))
    }
}

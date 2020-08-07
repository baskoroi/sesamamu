//
//  QuestionViewModel.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 04/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import Combine

class QuestionViewModel: ObservableObject, Identifiable {
    var id = UUID()
    
    @Published var round: Int?
    @Published var text: String?
    @Published var index: Int?
    @Published var numberOfVote: Int?
    
    //MARK: - Different type of init for QuestionViewModel
    init() {}
    
    init(round: Int?, text: String?) {
        self.round = round
        self.text = text
    }
    
    init(round: Int?, index: Int?, text: String?) {
        self.round = round
        self.text = text
        self.index = index
    }
    
    init(round: Int?, text: String?, numberOfVote: Int?) {
        self.round = round
        self.text = text
        self.numberOfVote = numberOfVote
    }
}
    
    




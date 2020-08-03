//
//  AnswerViewModel.swift
//  sesamamu
//
//  Created by Baskoro Indrayana on 07/21/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

struct AnswerViewModel: Hashable {
    var id = UUID()

    var nickname: String?
    var message: String?
    var isMyOwn: Bool = false
    var avatarURL: String?
    var timestamp: TimeInterval
    var foregroundColor: Color = .black
    var backgroundColor: Color = .white
}

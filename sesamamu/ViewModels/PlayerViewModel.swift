//
//  PlayerViewModel.swift
//  sesamamu
//
//  Created by Davia Belinda Hidayat on 03/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation

struct PlayerViewModel {
    var id = UUID()

    var stageName: String?
    var realName: String?
    var avatarURL: String?
    var isHost = false
    var campID: String?
}

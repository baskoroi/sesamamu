//
//  AnswerService.swift
//  sesamamu
//
//  Created by Baskoro Indrayana on 08/03/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class AnswerService: ObservableObject {
    
    var chatRef = Database.database().reference().child("testMessages")
    var chatHandle: UInt?
    
    func observeIncomingAnswers(completion: @escaping (AnswerViewModel?) -> Void) {
        
        chatHandle = chatRef.observe(.childAdded, with: { (message) in
            if let value = message.value as? [String: Any] {
                let viewModel = AnswerViewModel(nickname: value["nickname"] as? String,
                                                message: value["message"] as? String,
                                                avatarURL: value["avatarURL"] as? String,
                                                timestamp: Date().timeIntervalSince1970)
                completion(viewModel)
            } else {
                completion(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sendAnswer(for question: QuestionModel, at campID: String, from viewModel: AnswerViewModel) {
        guard let nickname = viewModel.nickname,
            let avatarURL = viewModel.avatarURL,
            let message = viewModel.message else { return }
        
        let ref = self.chatRef.child(campID).child("round\(question.round)").child(question.text)
        
        // timestamp is only set as per setValue function call below
        ref.childByAutoId().setValue([
            "nickname": nickname,
            "avatarURL": avatarURL,
            "message": message,
            "timestamp": Date().timeIntervalSince1970,
        ])
    }
    
    deinit {
        if let handle = chatHandle {
            self.chatRef.removeObserver(withHandle: handle)
        }
    }
}

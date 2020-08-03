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
    
    var chatRef = Database.database().reference().child("answers")
    var chatHandle: UInt?
    
    func observeIncomingAnswers(for question: QuestionModel,
                                at campID: String,
                                completion: @escaping (AnswerViewModel?) -> Void) {
        
        let ref = getDBReferenceForAnswer(question, at: campID)
        
        chatHandle = ref.observe(.childAdded, with: { (answer) in
            if let value = answer.value as? [String: Any],
                let memberID = value["member"] as? String,
                let stageName = memberID.components(separatedBy: "->").last,
                let answerText = value["answer"] as? String,
                let avatarURL = value["avatarURL"] as? String,
                let timestamp = value["timestamp"] as? TimeInterval {

                let viewModel = AnswerViewModel(stageName: stageName,
                                                answerText: answerText,
                                                isMyOwn: false,
                                                avatarURL: avatarURL,
                                                timestamp: timestamp)
                
                completion(viewModel)
            } else {
                completion(nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func sendAnswer(for question: QuestionModel,
                    at campID: String,
                    from viewModel: AnswerViewModel) {
        guard let stageName = viewModel.stageName,
            let answerText = viewModel.answerText,
            let avatarURL = viewModel.avatarURL else { return }
        
        let ref = getDBReferenceForAnswer(question, at: campID)
        
        // timestamp is only set as per setValue function call below
        ref.childByAutoId().setValue([
            "member": "\(campID)->\(stageName)",
            "answer": answerText,
            "avatarURL": avatarURL,
            "timestamp": Date().timeIntervalSince1970
        ])
    }
    
    private func getDBReferenceForAnswer(_ question: QuestionModel, at campID: String) -> DatabaseReference {
        return chatRef.child(campID).child("round\(question.round)").child(question.text)
    }
    
    deinit {
        if let handle = chatHandle {
            self.chatRef.removeObserver(withHandle: handle)
        }
    }
}

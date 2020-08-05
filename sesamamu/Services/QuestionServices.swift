//
//  QuestionServices.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 04/08/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import Firebase

class QuestionServices: ObservableObject, Identifiable {
    @Published var submittedQuestionByUser = QuestionViewModel()
    @Published var questionArrayForRound = [QuestionViewModel]()
    @Published var questionForRound = QuestionViewModel()

    
    
    //DB ref
    private var questionRef = Database.database().reference().child("questions")
    
    func submitFinalQuestion(campCode: String, userQuestion questionText: String) {
        
        questionRef.child("round3/\(campCode)/submitted").childByAutoId().setValue(["text": questionText]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                self.submittedQuestionByUser = QuestionViewModel(round: 3, text: questionText)
                print("Data saved successfully! User input: \(questionText)")
            }
        }
    }
    
    //Get question from DB and add it to questionArray
    func fetchQuestion(forRound:Int, campId: String) {
        if forRound == 3 {
            questionRef.child("round\(forRound)/\(campId)/submitted").observeSingleEvent(of: .value, with: { (snapshot) in
                let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
                for questionSubmitted in questionArrayChildren {
                    let question = questionSubmitted.value as? [String: String]
                    if let textQuestion = question?["text"] {
                        let questionFetch = QuestionViewModel(round: forRound, text: textQuestion)
                        self.questionArrayForRound.append(questionFetch)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            questionRef.child("round\(forRound)").observeSingleEvent(of: .value, with: { (snapshot) in
                let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
                if let questionRandomDict = questionArrayChildren.randomElement()?.value as? [String: Any]{
                    self.questionForRound = QuestionViewModel(round: forRound, text: questionRandomDict["text"] as? String ?? "")
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

//
//  QuestionServices.swift
//  sesamamu
//
//  Created by Yohanes Markus Heksan on 04/08/20.
//  Copyright ©️ 2020 Baskoro Indrayana. All rights reserved.
//

import Foundation
import FirebaseDatabase

class QuestionServices: ObservableObject, Identifiable {
    @Published var submittedQuestionByUser = QuestionViewModel()
    @Published var questionVoted = QuestionViewModel()
    
    @Published var questionArrayForRound = [QuestionViewModel]()
    @Published var questionForRound = QuestionViewModel()
    
    @Published var questionPickArray = [String]()
    
    @Published var questionArrayForVote = [String]()

    //DB ref
    private var questionRef = Database.database().reference().child("questions")
    private var campRef = Database.database().reference().child("camps")
    
    //MARK: - Submit data to DB
    func submitFinalQuestion(campId: String, userQuestion questionText: String) {
        
        questionRef.child("round3/\(campId)/submitted").childByAutoId().setValue(["text": questionText]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                self.submittedQuestionByUser = QuestionViewModel(round: 3, text: questionText)
                print("Data saved successfully! User input: \(questionText)")
            }
        }
    }
    
    func submitQuestionForVote(campId: String, questionVoteText: String, numberOfVote: Int) {
        questionRef.child("round3/\(campId)/voted").childByAutoId().setValue(["text": questionVoteText]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                self.questionVoted = QuestionViewModel(round: 3, text: questionVoteText, numberOfVote: numberOfVote)
                print("Data saved successfully! User input: \(questionVoteText) and number of vote are \(numberOfVote)")
            }
        }
    }
    
    func submitVotedQuestionForRound3(campId: String, value questionText: String) {
        
        questionRef.child("round3/\(campId)/published").childByAutoId().setValue(["text": questionText]) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                self.submittedQuestionByUser = QuestionViewModel(round: 3, text: questionText)
                print("Data saved successfully! User input: \(questionText)")
            }
        }
    }
    
    //MARK: - Get question from DB and add it to questionArray
    func fetchQuestion(forRound: Int, campId: String) {
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
        } else if forRound == 31 {
            questionRef.child("round3/\(campId)/published").observeSingleEvent(of: .value, with: { (snapshot) in
                let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
                if let questionRandomDict = questionArrayChildren.randomElement()?.value as? [String: Any]{
                    self.questionForRound = QuestionViewModel(round: forRound, text: questionRandomDict["text"] as? String ?? "")
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func fecthRandomQuestionAndSaveItToCampCurrentQuestion(campId: String, forRound: Int, no questionNumber: Int, isHost:Bool, generateNewRound: Bool){
        if isHost && generateNewRound {
            if forRound == 3 {
                self.fetchQuestionFromCurrentQuestionWithSpecificCampId(id: campId, for: forRound, no: questionNumber)
            } else {
                campRef.child("\(campId)/currentQuestions").removeValue { (err, dbRef) in
                    self.questionRef.child("round\(forRound)").observeSingleEvent(of: .value, with: { (snapshot) in
                        let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
                        for _ in 0...2 {
                            if let questionRandomDict = questionArrayChildren.randomElement()?.value as? [String: Any]{
                                let questionPick = questionRandomDict["text"]
                                self.questionPickArray.append(questionPick as? String ?? "")
                            }
                        }
                        print(self.questionPickArray)
                        var number = 0
                        //Insert to Camp Question with specific id
                        for question in self.questionPickArray {
                            number += 1
                            self.campRef.child("\(campId)/currentQuestions").childByAutoId().setValue(["number": number,"text": question]) { (error:Error?, ref:DatabaseReference) in
                                if let error = error {
                                    print("Data could not be saved: \(error).")
                                } else {
                                    self.questionForRound = QuestionViewModel(round: 3, text: question)
                                    print("Data saved successfully! User input: \(question)")
                                }
                            }
                        }
                        self.fetchQuestionFromCurrentQuestionWithSpecificCampId(id: campId, for: forRound, no: questionNumber)
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                } 
            }
        } else {
            fetchQuestionFromCurrentQuestionWithSpecificCampId(id: campId, for: forRound, no: questionNumber)
        }
    }
    
    func fetchQuestionFromCurrentQuestionWithSpecificCampId(id campId: String, for forRound: Int, no questionNumber: Int) {
        campRef.child("\(campId)/currentQuestions").observeSingleEvent(of: .value, with: { (snapshot) in
            let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
            for number in 0...questionNumber-1{
                if let questionDict = questionArrayChildren[number].value as? [String: Any] {
                    print(questionDict)
                    self.questionForRound = QuestionViewModel(round: forRound, text: questionDict["text"] as? String ?? "")
                }
            }
            print(self.questionForRound)
        })
    }
    
    //MARK: - Filter top 3 voted question and save it to Published path
    func findTopThreeQuestion(forRound:Int, campId: String, isHost: Bool, generateNewRound: Bool) {
        if isHost && generateNewRound {
            questionRef.child("round\(forRound)/\(campId)/voted").observeSingleEvent(of: .value, with: { (snapshot) in
                let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
                for questionVoted in questionArrayChildren {
                    let question = questionVoted.value as? [String: String]
                    if let textQuestion = question?["text"] {
                        self.questionArrayForVote.append(textQuestion)
                    }
                }
                print(self.questionArrayForVote)
                
                for _ in 1...3 {
                    let mappedQuestion = self.questionArrayForVote.map{($0, 1)}
                    let counts = Dictionary(mappedQuestion, uniquingKeysWith: +)
                    
                    
                    if let (value, count) = counts.max(by: {$0.1 < $1.1}) {
                        print("\(value) occurs \(count) times")
                        self.submitVotedQuestionForRound3(campId: campId, value: value)
                        self.questionArrayForVote = self.questionArrayForVote.filter(){$0 != value}
                    }
                }
                print(self.questionArrayForVote)
                self.removeAndUpdateQuestionForFinalQuestion(campId: campId, forRound: forRound, question: self.questionArrayForVote)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func removeAndUpdateQuestionForFinalQuestion(campId: String, forRound:Int, question:[String]) {
        campRef.child("\(campId)/currentQuestions").removeValue { (err, dbRef) in
            self.questionRef.child("round\(forRound)/\(campId)/published").observeSingleEvent(of: .value, with: { (snapshot) in
                let questionArrayChildren = snapshot.children.allObjects as! [DataSnapshot]
                for _ in 0...2 {
                    if let questionRandomDict = questionArrayChildren.randomElement()?.value as? [String: Any]{
                        let questionPick = questionRandomDict["text"]
                        self.questionPickArray.append(questionPick as! String)
                    }
                }
                print(self.questionPickArray)
                var number = 0
                //Insert to Camp Question with specific id
                for question in self.questionPickArray {
                    number += 1
                    self.campRef.child("\(campId)/currentQuestions").childByAutoId().setValue(["number": number,"text": question]) { (error:Error?, ref:DatabaseReference) in
                        if let error = error {
                            print("Data could not be saved: \(error).")
                        } else {
                            self.questionForRound = QuestionViewModel(round: 3, text: question)
                            print("Data saved successfully! User input: \(question)")
                        }
                    }
                }
                //                    self.fetchQuestionFromCurrentQuestionWithSpecificCampId(id: campId, for: forRound, no: questionNumber)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

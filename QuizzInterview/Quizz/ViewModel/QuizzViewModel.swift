//
//  QuizzViewModel.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

protocol QuizzViewModelDelegate: AnyObject {
    func ready(_ viewModel: QuizzViewModel)
    func showError(_ viewModel: QuizzViewModel, error: QuizzError)
    func correctAnswer(_ viewModel: QuizzViewModel)
    func update(_ viewModel: QuizzViewModel, time: String)
    func reload(_ viewModel: QuizzViewModel)
    func updateScore(_ viewModel: QuizzViewModel, score: String)
    
}

class QuizzViewModel{
    
    let service: QuizzService
    weak var viewDelegate: QuizzViewModelDelegate?
    weak var coordinatorDelegate: QuizzCoordinatorDelegate?
    
    private var quizz: Quizz?
    private var correctAnswered: [String]
    
    var timer: Timer?
    private var defaultTime: Int = 300
    private var currentTime: Int = 300
    
    init(service: QuizzService) {
        self.service = service
        self.correctAnswered = []
        
    }
    
    func fetch() {
        coordinatorDelegate?.loading(self, show: true)
        service.fetchQuizzData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let quizz):
                self.quizz = quizz
                self.viewDelegate?.ready(self)
                self.getCurrentStringTime()
                self.coordinatorDelegate?.loading(self, show: false)
            case .failure(let error):
                self.viewDelegate?.showError(self, error: error)
            }
        }
        
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return correctAnswered.count
    }
    
    func getAnswer(for index: Int) -> String? {
        guard correctAnswered.indices.contains(index) else { return nil }
        return correctAnswered[index]
    }
    
    func getTitle() -> String {
        guard let title = quizz?.question else { return "" }
        return title
    }
    
    func getScore() -> String {
        guard let answers = quizz?.answer else { return "--/--" }
        return "\(correctAnswered.count)/\(answers.count)"
    }
    
    func addToCorrectIfNeeded(_ text: String?) {
        guard let text = text else { return }
        if isACorrectOption(text) && !isAlreadyInUse(text) {
            correctAnswered.append(text)
            viewDelegate?.correctAnswer(self)
            viewDelegate?.updateScore(self, score: getScore())
        }
        
        guard let answers = quizz?.answer else { return }
        if correctAnswered.count == answers.count {
            timer?.invalidate()
            let message = "Good job! You found all the answers in time. Keep up with the great work"
            self.coordinatorDelegate?
                .showAlert(self,
                           title: "Congratulations", message: message,
                           action: "Play Again",
                           handler: {
                            self.correctAnswered.removeAll()
                            self.getCurrentStringTime()
                            self.viewDelegate?.ready(self)
                            self.startCountDown()
                            
            })
        }
    }
    
    func startCountDown() {
        currentTime = defaultTime
        correctAnswered.removeAll()
        self.viewDelegate?.reload(self)
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(countDown),
                                     userInfo: nil,
                                     repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(defaultTime)) {
            self.timer?.invalidate()
            guard let answer = self.quizz?.answer else { return }
            let message = "Sorry, time is up! You get \(self.correctAnswered.count) out of \(answer.count) answers"
            self.coordinatorDelegate?
                .showAlert(self,
                           title: "Time finished",
                           message: message,
                           action: "Try Again",
                           handler: {
                            self.correctAnswered.removeAll()
                            self.currentTime = self.defaultTime
                            self.getCurrentStringTime()
                            self.viewDelegate?.updateScore(self, score: self.getScore())
                            self.startCountDown()
            })
        }
    }
    
    private func getCurrentStringTime() {
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        
        let text = String(format: "%02d:%02d", minutes, seconds)
        viewDelegate?.update(self, time: text)
    }
    
    @objc private func countDown() {
        currentTime -= 1
        getCurrentStringTime()
    }
    
    private func isAlreadyInUse(_ text: String) -> Bool {
        return correctAnswered.contains(text)
    }
    
    private func isACorrectOption(_ text: String) -> Bool {
        guard let quizz = quizz else { return false }
        return quizz.answer.contains(text)
    }
    
}

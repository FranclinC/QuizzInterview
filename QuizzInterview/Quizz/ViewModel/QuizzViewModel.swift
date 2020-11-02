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
    
}

class QuizzViewModel{
    
    let service: QuizzService
    weak var viewDelegate: QuizzViewModelDelegate?
    
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
        service.fetchQuizzData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let quizz):
                self.quizz = quizz
                self.viewDelegate?.ready(self)
                self.getCurrentStringTime()
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
        }
    }
    
    func startCountDown() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(defaultTime)) {
            self.timer?.invalidate()
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

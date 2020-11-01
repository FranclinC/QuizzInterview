//
//  QuizzViewModel.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

protocol QuizzViewModelDelegate: AnyObject {
    func ready(_ viewModel: QuizzViewModel)
    func showError(_ viewModel: QuizzViewModel, error: Error)
}

class QuizzViewModel{
    
    weak var viewDelegate: QuizzViewModelDelegate?
    
    private var quizz: Quizz?
    private var correctAnswered: [String]
    
    init() {
        self.correctAnswered = []
    }
    
    private func isACorrectOption(_ text: String) -> Bool {
        guard let quizz = quizz else { return false }
        return quizz.answer.contains(text)
    }
    
}

//
//  QuizzViewModel.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

protocol QuizzViewModelDelegate: AnyObject {
    func ready(_ viewModel: QuizzViewModel)
    func showError(_ viewModel: QuizzViewModel, error: QuizzError)
    
}

class QuizzViewModel{
    
    let service: QuizzService
    weak var viewDelegate: QuizzViewModelDelegate?
    
    private var quizz: Quizz?
    private var correctAnswered: [String]
    
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
            case .failure(let error):
                self.viewDelegate?.showError(self, error: error)
            }
        }
        
    }
    
    private func isACorrectOption(_ text: String) -> Bool {
        guard let quizz = quizz else { return false }
        return quizz.answer.contains(text)
        
    }
    
}

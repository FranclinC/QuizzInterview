//
//  QuizzService.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

class QuizzService: Service<QuizzApi> {
    
    func fetchQuizzData(completion: @escaping (Result<Quizz, QuizzError>) -> Void) {
        fetch(.getKeywords, dataType: Quizz.self) { (result, response) in
            completion(result)
            
        }
    }
}

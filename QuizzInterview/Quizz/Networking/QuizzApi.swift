//
//  QuizzApi.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

enum QuizzApi {
    case getKeywords
    
}

extension QuizzApi: Target {
    var baseURL: URL {
        return URL(staticString: "https://quizcodechallenge.herokuapp.com")
    }
    
    var path: String {
        return "/quiz"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        let header: [String: String] = ["Content-type": "application/json"]
        return header
    }
    
    var task: Task {
        return .requestPlain
    }
    
}

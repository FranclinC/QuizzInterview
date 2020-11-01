//
//  Target.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum Task {
    case requestPlain
}

protocol Target {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var task: Task { get }
}

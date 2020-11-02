//
//  QuizzError.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

enum QuizzError: Error {
    case generic(String)
    case parse
    case unkown
}

extension QuizzError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .generic(let message):
            return message
        default:
            return "Sorry! We are having some issues. Please try again in a moment!"
        }
    }
}

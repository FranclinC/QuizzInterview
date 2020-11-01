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

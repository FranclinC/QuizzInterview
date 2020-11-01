//
//  URL+Extension.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

extension URL {
    init<T: Target>(with target: T) {
        if target.path.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL.appendingPathComponent(target.path)
        }
    }
    
    init(staticString: String) {
        guard let url = URL(string: staticString) else {
            preconditionFailure("URL: \(staticString) is not a valid URL")
        }
        self = url
    }
}

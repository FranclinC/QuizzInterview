//
//  AppExecutor.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation

protocol AppExecutorProtocol {
    func execute(request: URLRequest,
                 session: URLSession,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}


class AppExecutor: AppExecutorProtocol {
    func execute(request: URLRequest,
                 session: URLSession,
                 completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let e = error {
                completion(data, response, e)
                return
            }
            completion(data, response, nil)
        }
        
        task.resume()
        return task
    }
    
}

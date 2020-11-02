//
//  MockFileExecutor.swift
//  QuizzInterviewTests
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/2/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import Foundation
@testable import QuizzInterview

class MockFileExecutor: AppExecutor {
    
    struct Stub {
        let file: String
        let code: Int
    }
    
    let bundle: Bundle
    var executeRequest: URLRequest?
    var stubs: [String: Stub] = [:]
    
    override init() {
        self.bundle = Bundle(for: type(of: self))
    }
    
    func register(file: String, target: Target, statusCode: Int) {
        let path = target.path
        let stub = Stub(file: file, code: statusCode)
        stubs[path] = stub
    }
    
    override func execute(request: URLRequest,
                          session: URLSession,
                          completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        executeRequest = request
        let dummyTask = URLSessionDataTask()
        
        guard let urlPath = request.url?.path, let stub = stubs[urlPath] else {
            let error = QuizzError.generic("Could not retrieve data")
            completion(nil, nil, error)
            return dummyTask
        }
        
        let response = HTTPURLResponse(url: request.url!, statusCode: stub.code, httpVersion: nil, headerFields: nil)
        
        DispatchQueue.global(qos: .background).async {
            guard let filePath = self.bundle.url(forResource: stub.file, withExtension: "json"),
                let content = try? Data(contentsOf: filePath) else {
                let error = QuizzError.generic("Could not get file")
                DispatchQueue.main.sync {
                    completion(nil, response, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(content, response, nil)
            }
        }
        
        return dummyTask
    }
}

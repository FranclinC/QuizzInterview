//
//  QuizzViewModelTests.swift
//  QuizzInterviewTests
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/2/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import XCTest
@testable import QuizzInterview

class QuizzViewModelTests: XCTestCase {
    
    var viewModel: QuizzViewModel!
    var service: QuizzService!
    var executor: MockFileExecutor!
    
    enum ViewDelegationHit {
        case ready
        case update(String)
    }
    
    var viewDelegation: ((ViewDelegationHit) -> Void)?

    override func setUp() {
        service = QuizzService()
        executor = MockFileExecutor()
        service.executor = executor
        viewModel = QuizzViewModel(service: service)
        viewModel.viewDelegate = self
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        executor = nil
    }

    func testFetch() {
        let expectationReady = self.expectation(description: "Wait for fetch return quizz to be ready")
        let expectationUpdate = self.expectation(description: "Wait for fetch return quizz to be updated")
        
        executor.register(file: "quizData", target: QuizzApi.getKeywords, statusCode: 200)
        
        viewDelegation = { delegate in
            switch delegate {
            case .ready:
                XCTAssertEqual(self.viewModel.getTitle(), "this is only a mocked text", "The title is wrong")
                expectationReady.fulfill()
            case .update(let text):
                XCTAssertEqual(text, "05:00", "time is wrong")
                expectationUpdate.fulfill()
            }
        }
        
        viewModel.fetch()
        
        wait(for: [expectationReady, expectationUpdate], timeout: 30.0)
    }

}

extension QuizzViewModelTests: QuizzViewModelDelegate {
    func ready(_ viewModel: QuizzViewModel) {
        viewDelegation?(.ready)
    }
    
    func correctAnswer(_ viewModel: QuizzViewModel) { }
    
    func update(_ viewModel: QuizzViewModel, time: String) {
        viewDelegation?(.update(time))
    }
    
    func reload(_ viewModel: QuizzViewModel) { }
    
    func updateScore(_ viewModel: QuizzViewModel, score: String) { }
    
    
}

//
//  QuizzCoordinator.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import UIKit

class QuizzCoodinator {

    var view: QuizzViewController?
    
    let window: UIWindow
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let service = QuizzService()
        let viewModel = QuizzViewModel(service: service)
        view = QuizzViewController(viewModel)
        window.rootViewController = view
        window.makeKeyAndVisible()
        
    }
    
    func stop() {
        view = nil
    }
    
    
}

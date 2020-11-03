//
//  QuizzCoordinator.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import UIKit

protocol QuizzCoordinatorDelegate: AnyObject {
    func showAlert(_ viewModel: QuizzViewModel, title: String, message: String, action: String, handler: (() -> Void)?)
    func loading(_ viewModel: QuizzViewModel, show: Bool)
}

class QuizzCoodinator {

    var view: QuizzViewController?
    var loadingViewController: LoadingViewController?
    
    let window: UIWindow
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let service = QuizzService()
        let viewModel = QuizzViewModel(service: service)
        viewModel.coordinatorDelegate = self
        view = QuizzViewController(viewModel)
        window.rootViewController = view
        window.makeKeyAndVisible()
        
    }
    
    func stop() {
        view = nil
        loadingViewController = nil
    }
    
    private func showLoading() {
        DispatchQueue.main.async {
            self.loadingViewController = LoadingViewController()
            self.loadingViewController?.modalPresentationStyle = .overFullScreen
            self.loadingViewController?.startLoading()
            guard let vc = self.loadingViewController else { return }
            self.view?.present(vc, animated: true, completion: nil)
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadingViewController?.stopLoading()
            self.loadingViewController?.dismiss(animated: true)
            self.loadingViewController = nil
        }
    }
    
}

extension QuizzCoodinator: QuizzCoordinatorDelegate {

    func showAlert(_ viewModel: QuizzViewModel, title: String, message: String, action: String, handler: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: action, style: .default, handler: { (_) in
                handler?()
            }))
            self.view?.present(alert, animated: true, completion: nil)
        }
    }
    
    func loading(_ viewModel: QuizzViewModel, show: Bool) {
        if show {
            showLoading()
        } else {
            hideLoading()
        }
        
    }
    
}

//
//  LoadingViewController.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/2/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let loadingSpinner = UIActivityIndicatorView(style: .large)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.color = .white
        return loadingSpinner
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSpinnerView()
    }
    
    private func setupSpinnerView() {
        view.backgroundColor = .black
        view.alpha = 0.20
                
        view.addSubview(spinner)
        view.addSubview(loadingLabel)
        
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 16).isActive = true
        loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func startLoading() {
        spinner.startAnimating()
    }
    
    func stopLoading() {
        spinner.stopAnimating()
    }
    

}

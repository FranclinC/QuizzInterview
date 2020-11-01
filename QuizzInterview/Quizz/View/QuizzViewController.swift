//
//  QuizzViewController.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import UIKit

class QuizzViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    var viewModel: QuizzViewModel
    
    init(_ viewModel: QuizzViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This should not be used")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        
    }
    
}

extension QuizzViewController: QuizzViewModelDelegate {
    func ready(_ viewModel: QuizzViewModel) {
        print("Ready for use")
    }
    
    func showError(_ viewModel: QuizzViewModel, error: Error) {
        print("Should show error")
    }
    
    
    
    
}

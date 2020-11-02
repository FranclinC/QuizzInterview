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
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "Insert word"
            
        }
    }
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
        setupTableView()
        setupTextField()
        setupButton()
        viewModel.fetch()
        
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(cellType: CorrectAnswerTableViewCell.self)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupButton() {
        actionButton.setTitle("Start", for: .normal)
        actionButton.isEnabled = false
    }
    
    private func setupTextField() {
        textField.isEnabled = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
        viewModel.startCountDown()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.addToCorrectIfNeeded(textField.text)
    }
    
}

extension QuizzViewController: QuizzViewModelDelegate {
    func ready(_ viewModel: QuizzViewModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = viewModel.getTitle()
            self.pointsLabel.text = self.viewModel.getScore()
            self.actionButton.isEnabled = true
        }
        
        
        //Start Timer
    }
    
    func showError(_ viewModel: QuizzViewModel, error: QuizzError) {
        print("Should show error")
    }
    
    func correctAnswer(_ viewModel: QuizzViewModel) {
        DispatchQueue.main.async {
            self.textField.text?.removeAll()
            self.tableView.reloadData()
            self.pointsLabel.text = self.viewModel.getScore()
        }
        
    }
    
    func update(_ viewModel: QuizzViewModel, time: String) {
        DispatchQueue.main.async {
            self.timeLabel.text = time
        }
    }
   
}

extension QuizzViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(class: CorrectAnswerTableViewCell.self, indexPath: indexPath) { (cell) in
            cell.setup(self.viewModel.getAnswer(for: indexPath.row))
        }
    }
}




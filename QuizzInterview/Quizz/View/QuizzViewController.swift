//
//  QuizzViewController.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import UIKit

class QuizzViewController: UIViewController {

    let constraintHeightKeyboardDown: CGFloat = 16
    let constraintHeightKeyboardUp: CGFloat = 8
    
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
        configureKeyboard()
        setupTableView()
        setupTextField()
        setupButton()
        viewModel.fetch()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func configureKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleNotification(_ notification: Notification) {
        guard let keyboardValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else { return }
        
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        self.bottomViewConstraint.constant = isKeyboardShowing ? keyboardValue.cgRectValue.height - constraintHeightKeyboardUp : constraintHeightKeyboardDown
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            
            self.view.layoutIfNeeded()
        }, completion: nil)
 
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
        textField.autocorrectionType = .no
        textField.isEnabled = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @IBAction func didTapActionButton(_ sender: UIButton) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
        viewModel.startCountDown()
        actionButton.setTitle("Restart", for: .normal)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        viewModel.addToCorrectIfNeeded(textField.text)
    }
    
}

extension QuizzViewController: QuizzViewModelDelegate {
    func ready(_ viewModel: QuizzViewModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = viewModel.getTitle()
            self.actionButton.isEnabled = true
            self.textField.isEnabled = false
        }
    }
    
    func reload(_ viewModel: QuizzViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showError(_ viewModel: QuizzViewModel, error: QuizzError) {
        print("Should show error")
    }
    
    func correctAnswer(_ viewModel: QuizzViewModel) {
        DispatchQueue.main.async {
            self.textField.text?.removeAll()
            self.tableView.reloadData()
        }
        
    }
    
    func update(_ viewModel: QuizzViewModel, time: String) {
        DispatchQueue.main.async {
            self.timeLabel.text = time
        }
    }
    
    func updateScore(_ viewModel: QuizzViewModel, score: String) {
        DispatchQueue.main.async {
            self.pointsLabel.text = score
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




//
//  UITableView+Extension.swift
//  QuizzInterview
//
//  Created by Franclin Cabral Menezes de Oliveira on 11/1/20.
//  Copyright © 2020 Franclin Cabral Menezes de Oliveira. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: cellType.identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: cellType.identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(class: T.Type,
                                                 indexPath: IndexPath,
                                                 setup: @escaping ((T) -> Void) = { _ in }) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath)
        if let typedCell = cell as? T {
            setup(typedCell)
        }
        return cell
    }
    
}

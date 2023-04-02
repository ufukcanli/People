//
//  UIButton+Ext.swift
//  People
//
//  Created by Ufuk Canlı on 1.04.2023.
//

import UIKit

extension UIButton {
    static var emptyStateButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

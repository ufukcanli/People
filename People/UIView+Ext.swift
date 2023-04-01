//
//  UIView+Ext.swift
//  People
//
//  Created by Ufuk Canlı on 1.04.2023.
//

import UIKit

extension UIView {
    static var emptyStateView: UIView {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.secondarySystemFill.cgColor
        view.layer.borderWidth = 2.0
        view.isHidden = true
        return view
    }
}

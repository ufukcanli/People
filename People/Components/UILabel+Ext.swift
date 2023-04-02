//
//  UILabel+Ext.swift
//  People
//
//  Created by Ufuk Canlı on 1.04.2023.
//

import UIKit

extension UILabel {
    static var emptyStateLabel: UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

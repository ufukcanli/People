//
//  UIActivityIndicatorView+Ext.swift
//  People
//
//  Created by Ufuk Canlı on 1.04.2023.
//

import UIKit

extension UIActivityIndicatorView {
    static var loadingView: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .label
        activityIndicator.style = .medium
        return activityIndicator
    }
}

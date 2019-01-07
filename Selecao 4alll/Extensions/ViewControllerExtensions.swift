
//
//  UIViewController.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Activity Indicator
    private var activityTag: Int {
        return Constants.activityIndicatorTag
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: Constants.activityIndicatorAlpha)
        activityIndicator.tag = self.activityTag
        activityIndicator.frame = UIScreen.main.bounds
        return activityIndicator
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            let view = self.activityIndicator
            view.startAnimating()
            UIApplication.shared.keyWindow?.addSubview(view)
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.viewWithTag(Constants.activityIndicatorTag)?.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation Bar
    func setupNavBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .mainOrange
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Topbar Height
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

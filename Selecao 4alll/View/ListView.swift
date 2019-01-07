//
//  ListView.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

// View da tela inicial
class ListView: UIView {
    
    // MARK: - Variáveis
    var noDataView = NoDataView()
    var tableView = UITableView()
    var tableViewError = TableViewError()
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(tableViewError)
        addSubview(tableView)
        addSubview(noDataView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        noDataView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        noDataView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        noDataView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        noDataView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        tableViewError.translatesAutoresizingMaskIntoConstraints = false
        tableViewError.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        tableViewError.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableViewError.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableViewError.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}

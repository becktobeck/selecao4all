//
//  ListTableViewCell.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

// Célula que exibe os itens encontrados na busca pelas tarefas
class ListTableViewCell: UITableViewCell {
    
    // MARK: - Variáveis
    var name: String? {
        didSet {
            textLabel?.text = name
            textLabel?.textColor = .mainOrange
        }
    }
 
    // MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        tintColor = .mainOrange
        
        selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = UIColor.mainOrange.withAlphaComponent(0.25)
            return view
        }()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

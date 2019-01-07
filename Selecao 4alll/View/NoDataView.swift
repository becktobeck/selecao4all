//
//  NoDataView.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    
    // MARK: - Variáveis
    // Mensagem quando não se encontra nenhum item na lista, caso ocorra
    var noDataText: String = "" {
        didSet {
            noDataLabel.text = noDataText
        }
    }
    
    // MARK: - Constantes
    private let noDataLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mainOrange
        return view
    }()
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setup()
    }
    
    override func layoutSubviews() {
        noDataLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(noDataLabel)
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

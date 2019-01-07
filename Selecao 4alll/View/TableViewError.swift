//
//  TableViewError.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

class TableViewError: UIView {
    
    // MARK: - Variáveis
    var delegate: RetryDelegate?
    
    // Elemento que exibe recebe a mensagem de erro, caso exista
    var errorText: String = "" {
        didSet {
            errorLabel.text = errorText 
        }
    }
    
    // MARK: - Constantes
    private let errorLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .mainOrange
        return view
    }()
    
    private let btnRetry: UIButton = {
        let view = UIButton(type: .system)
        view.setBackgroundImage(UIImage(named: "btnRefresh"), for: .normal)
        return view
    }()
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(errorLabel)
        addSubview(btnRetry)
    }
    
    override func layoutSubviews() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        btnRetry.translatesAutoresizingMaskIntoConstraints = false
        btnRetry.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btnRetry.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 2 * Constants.defaultSpacing).isActive = true
        btnRetry.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funções Auxiliares
    @objc private func handleRetry() {
        delegate?.retry()
    }
    
}

// MARK: - RetryDelegate
protocol RetryDelegate {
    func retry()
}

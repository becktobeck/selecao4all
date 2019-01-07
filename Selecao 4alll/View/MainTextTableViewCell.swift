//
//  MainTextTableViewCell.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 04/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

// View que exibe o texto principal
class MainTextTableViewCell: UITableViewCell {
    
    // MARK: - Variáveis
    var mainText: MainText? {
        didSet {
            if let text = mainText?.mainText {
                mainTextLabel.text = text + "\n"
            }
        }
    }
    
    // MARK: - Constantes
    // Label que exibe o texto principal
    let mainTextLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .natural
        view.textColor = .mainOrange
        return view
    }()
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubview(mainTextLabel)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funções Auxiliares
    func setup() {
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTextLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 2.5 * Constants.defaultSpacing).isActive = true
        mainTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -2.5 * Constants.defaultSpacing).isActive = true
        mainTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        setTextFontSize(forScreenHeight: UIScreen.main.bounds.height)
    }
    
    private func setTextFontSize(forScreenHeight height: CGFloat) {
        var fontSize: CGFloat = 0
        
        switch height {
        case 568:
            fontSize = Constants.FontSizes.iPhone5SE.textSize
        case 667:
            fontSize = Constants.FontSizes.iphone678.textSize
        case 736:
            fontSize = Constants.FontSizes.iphone678Plus.textSize
        case 812:
            fontSize = Constants.FontSizes.iphoneX.textSize
        case 896:
            fontSize = Constants.FontSizes.iphoneXR.textSize
        default:
            fontSize = Constants.FontSizes.ipad.textSize
        }
        
        mainTextLabel.font = UIFont.systemFont(ofSize: fontSize)
    }
}

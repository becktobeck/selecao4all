//
//  ButtonCollectionViewCell.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 06/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

// Classe que contém os botões que executam ações na tela principal
class ButtonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variáveis
    var delegate: ButtonActionDelegate?
    var details: HeaderInfo?
    
    var actionButton: ActionButton? {
        didSet {
            if let image = actionButton?.image, let title = actionButton?.title {
                btn.setBackgroundImage(image, for: .normal)
                btnTitle.text = title
            }
        }
    }
    
    var buttonsInfo: ButtonsInformations? {
        didSet {
            if let details = buttonsInfo?.details, let button = buttonsInfo?.actionButton {
                self.details = details
                actionButton = button
            }
        }
    }
    
    // MARK: - Constantes
    private let width = UIScreen.main.bounds.width
    
    private let btn: UIButton = {
        let view = UIButton(type: .system)
        return view
    }()
    
    private let btnTitle: UILabel = {
        let view = UILabel()
        view.textColor = .mainOrange
        view.textAlignment = .center
        return view
    }()
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(btn)
        addSubview(btnTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: topAnchor).isActive = true
        btn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        btn.heightAnchor.constraint(equalToConstant: Constants.ButtonCollectionViewCell.buttonSizeProportion * width).isActive = true
        btn.widthAnchor.constraint(equalTo: btn.heightAnchor, multiplier: 1).isActive = true
        btn.addTarget(self, action: #selector(handlePressedButton), for: .touchUpInside)
        
        btnTitle.translatesAutoresizingMaskIntoConstraints = false
        btnTitle.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: -Constants.defaultSpacing / 2).isActive = true
        btnTitle.centerXAnchor.constraint(equalTo: btn.centerXAnchor).isActive = true
        
        setButtonLabelFontSize(forScreenHeight: UIScreen.main.bounds.height)
    }
    
    // MARK - Funções Auxiliares
    @objc private func handlePressedButton() {
        switch actionButton?.title {
        case Constants.ActionButtonNames.call: handleCallNumber()
        case Constants.ActionButtonNames.address: handleShowAddress()
        case Constants.ActionButtonNames.comments: handleScrollToComments()
        case Constants.ActionButtonNames.services: handleServices()
        default: ()
        }
    }
    
    // Configura o tamanho de fonte para os botões
    private func setButtonLabelFontSize(forScreenHeight screenHeight: CGFloat) {
        var fontSize: CGFloat = 0
        
        switch screenHeight {
        case 568:
            fontSize = Constants.FontSizes.iPhone5SE.textSize - 2
        case 667:
            fontSize = Constants.FontSizes.iphone678.textSize - 2
        case 736:
            fontSize = Constants.FontSizes.iphone678Plus.textSize - 2
        case 812:
            fontSize = Constants.FontSizes.iphoneX.textSize - 2
        case 896:
            fontSize = Constants.FontSizes.iphoneXR.textSize - 2
        default:
            fontSize = Constants.FontSizes.ipad.textSize - 2
        }
        
        btnTitle.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    // Ações para os botões
    private func handleScrollToComments() {
        delegate?.scrollToComments()
    }
    
    private func handleShowAddress() {
        if let address = details?.address, let extra = details?.title {
            let fullAddress = "\(address)\n\(extra)"
            delegate?.showAddress(fullAddress)
        } else {
            delegate?.error("Endereço indisponível")
        }
    }
    
    private func handleServices() {
        delegate?.openServices()
    }
    
    private func handleCallNumber() {
        if let number = details?.phone {
            delegate?.callNumber(number: number)
        } else {
            delegate?.error("Número indisponível")
        }
        
    }
}

// MARK: - DetailViewActionsDelegate
protocol ButtonActionDelegate {
    func error(_ error: String)
    func callNumber(number: String)
    func openServices()
    func showAddress(_ address: String)
    func scrollToComments()
}

// MARK: - ButtonsInformations
// Contém a informação referente a cada botão
struct ButtonsInformations {
    var details: HeaderInfo?
    var actionButton: ActionButton?
}



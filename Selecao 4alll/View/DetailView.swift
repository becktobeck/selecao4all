//
//  DetailView.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    // MARK: - Variáveis
    // Proporção inicial para as imagens principal e logo
    private var imageProportion: CGFloat = 0.6
    private var logoProportion: CGFloat = 1
    // Constraints para as alturas da imagem principal e do logo
    private var coverPhotoHeightConstraint = NSLayoutConstraint()
    private var logoHeightConstraint = NSLayoutConstraint()
    
    // Elemento que conteem as informações mostradas acima da tableView
    var details: HeaderInfo? {
        didSet {
            if let details = details {
                if let photoUrl = details.urlCover, let urlPhoto = URL(string: photoUrl), let logoUrl = details.urlLogo, let urlLogo = URL(string: logoUrl) {
                    let photoData = try? Data(contentsOf: urlPhoto)
                    let logoData = try? Data(contentsOf: urlLogo)
                    
                    if let photoImageData = photoData, let logoImageData = logoData {
                        DispatchQueue.main.async { [ unowned weakSelf = self ] in
                            //Variáveis auxiliares para descobrir as dimensões da imagem
                            let photoImage = UIImage(data: photoImageData)
                            let logoImage = UIImage(data: logoImageData)
                            
                            if let photoHeight = photoImage?.size.height, let photoWidth = photoImage?.size.width, let logoHeight = logoImage?.size.height, let logoWidth = logoImage?.size.width {
                                
                                weakSelf.updateImageViewWith(imageData: [photoImageData, logoImageData], proportion: [photoHeight / photoWidth, logoHeight / logoWidth])
                            }
                            
                        }
                    }
                }
                titleLabel.text = details.name?.uppercased()
            }
        }
    }

    // MARK: - Constantes
    // Largura da tela, é utilizada como base de cálculo para dimensões dos elementos
    private let width = UIScreen.main.bounds.width
    
    // View localizada na NavigationBar, utilizada em DetailViewController
    let titleView: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.adjustsFontSizeToFitWidth = true
        view.textAlignment = .center
        return view
    }()
    
    // View que contém os botões que realizam ações
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(ButtonCollectionViewCell.self, forCellWithReuseIdentifier: "ButtonCollectionViewCell")
        view.backgroundColor = .white
        return view
    }()
    
    // Imagem principal
    private let coverPhoto: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // View auxiliar para que o logo tenha um contorno em branco
    private let backgroundLogoPhoto: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        return view
    }()
    
    // Imagem do logo
    private let logoPhoto: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        return view
    }()
    
    // Título
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .mainOrange
        return view
    }()
    
    private let titleBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    // View que separa os botões da TableView
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    // View que contém o texto principal, mapa e comentários
    let tableView: UITableView = {
        let view = UITableView()
        view.register(MainTextTableViewCell.self, forCellReuseIdentifier: "MainTextTableViewCell")
        view.register(MapTableViewCell.self, forCellReuseIdentifier: "MapTableViewCell")
        view.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        return view
    }()

    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(coverPhoto)
        addSubview(backgroundLogoPhoto)
        addSubview(logoPhoto)
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(separator)
        addSubview(tableView)
        addSubview(titleBackground)
        
        setupImageConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let logoDimension: CGFloat = Constants.DetailViewConstants.logoDimensionProportion * width
        
        backgroundLogoPhoto.translatesAutoresizingMaskIntoConstraints = false
        backgroundLogoPhoto.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.DetailViewConstants.paddingRightLogoProportion * width).isActive = true
        backgroundLogoPhoto.centerYAnchor.constraint(equalTo: coverPhoto.bottomAnchor, constant: -Constants.defaultSpacing).isActive = true
        backgroundLogoPhoto.heightAnchor.constraint(equalToConstant: logoDimension + Constants.DetailViewConstants.logoHeightProportion * width).isActive = true
        backgroundLogoPhoto.widthAnchor.constraint(equalToConstant: logoDimension + Constants.DetailViewConstants.logoHeightProportion * width).isActive = true
        backgroundLogoPhoto.layer.cornerRadius = (logoDimension + Constants.DetailViewConstants.logoHeightProportion * width) / 2
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: coverPhoto.bottomAnchor, constant: Constants.DetailViewConstants.paddingTopLogoProportion * width).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: coverPhoto.leftAnchor, constant: Constants.defaultSpacing).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.defaultSpacing).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.defaultSpacing).isActive = true
        collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.defaultSpacing).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: Constants.DetailViewConstants.btnsHeightProportion * width).isActive = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 2.5 * Constants.defaultSpacing).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -2.5 * Constants.defaultSpacing).isActive = true
        separator.heightAnchor.constraint(equalToConstant: Constants.DetailViewConstants.separatorHeight).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: Constants.defaultSpacing / 2).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: fontSizeForTitleLabel(forScreenHeight: UIScreen.main.bounds.height))
        
        titleBackground.translatesAutoresizingMaskIntoConstraints = false
        titleBackground.topAnchor.constraint(equalTo: coverPhoto.bottomAnchor).isActive = true
        titleBackground.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleBackground.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleBackground.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        
        sendSubviewToBack(titleBackground)
    }
    
    // MARK: - Funções auxiliares
    // Carrega as imagens
    private func setupImageConstraints() {
        coverPhoto.translatesAutoresizingMaskIntoConstraints = false
        coverPhoto.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        coverPhoto.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        coverPhoto.widthAnchor.constraint(equalToConstant: width).isActive = true
        coverPhotoHeightConstraint = coverPhoto.heightAnchor.constraint(equalTo: coverPhoto.widthAnchor, multiplier: imageProportion)
        coverPhotoHeightConstraint.isActive = true
        
        let logoDimension: CGFloat = Constants.DetailViewConstants.logoDimensionProportion * width
        logoPhoto.translatesAutoresizingMaskIntoConstraints = false
        logoPhoto.centerXAnchor.constraint(equalTo: backgroundLogoPhoto.centerXAnchor).isActive = true
        logoPhoto.centerYAnchor.constraint(equalTo: backgroundLogoPhoto.centerYAnchor).isActive = true
        logoPhoto.widthAnchor.constraint(equalToConstant: logoDimension).isActive = true
        logoHeightConstraint = logoPhoto.heightAnchor.constraint(equalTo: logoPhoto.widthAnchor, multiplier: logoProportion)
        logoHeightConstraint.isActive = true
        logoPhoto.layer.cornerRadius = logoDimension / 2
        
    }
    
    // Configuração Fontes
    // Escolhe o tamanho de fonte para o título com base no tamanho da tela
    private func fontSizeForTitleLabel(forScreenHeight screenHeight: CGFloat) -> CGFloat {
        var fontSize: CGFloat = 0
        
        switch screenHeight {
        case 568:
            fontSize = Constants.FontSizes.iPhone5SE.titleSize
        case 667:
            fontSize = Constants.FontSizes.iphone678.titleSize
        case 736:
            fontSize = Constants.FontSizes.iphone678Plus.titleSize
        case 812:
            fontSize = Constants.FontSizes.iphoneX.titleSize
        case 896:
            fontSize = Constants.FontSizes.iphoneXR.titleSize
        default:
            fontSize = Constants.FontSizes.ipad.titleSize
        }
        
        return fontSize
    }

    // Atualiza o tamanho das imagens com base na proporção da imagem original
    private func updateImageViewWith(imageData data: [Data], proportion: [CGFloat]) {
        DispatchQueue.main.async {
            self.coverPhotoHeightConstraint.isActive = false
            let newPhotoConstraint = self.coverPhoto.heightAnchor.constraint(equalTo: self.coverPhoto.widthAnchor, multiplier: proportion[0])
            newPhotoConstraint.isActive = true
            self.coverPhoto.removeConstraint(self.coverPhotoHeightConstraint)
            self.coverPhoto.addConstraint(newPhotoConstraint)
            
            self.logoHeightConstraint.isActive = false
            let newLogoConstraint = self.logoPhoto.heightAnchor.constraint(equalTo: self.logoPhoto.widthAnchor, multiplier: proportion[1])
            newLogoConstraint.isActive = true
            self.logoPhoto.removeConstraint(self.logoHeightConstraint)
            self.logoPhoto.addConstraint(newLogoConstraint)
            
            self.coverPhoto.image = UIImage(data: data[0])
            self.logoPhoto.image = UIImage(data: data[1])
            
            self.layoutIfNeeded()
        }
        
    }
    
}

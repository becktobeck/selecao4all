//
//  CommentTableViewCell.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 04/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

// View que exibe os comentários feitos pelos usuários
class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Variáveis
    private var photoHeightConstraint = NSLayoutConstraint()
    
    // Variável com as informações da célula
    var comment: Comments? {
        didSet {
            if let photoUrl = comment?.urlPhoto, let urlPhoto = URL(string: photoUrl) {
                let photoData = try? Data(contentsOf: urlPhoto)
                
                if let photoImageData = photoData {
                    DispatchQueue.main.async { [ unowned weakSelf = self ] in
                        weakSelf.commenterPhoto.image = UIImage(data: photoImageData)
                    }
                }
            }
            
            if let mark = comment?.mark {
                giveMark(mark)
            }
            
            // Optou-se por separar o nome, comentário e título em três elementos.
            // Outra estratégia seria utilizar um TextView com attributedString.
            // No entanto, como podem haver muitas variações de texto dentro do textView,
            // torna-se mais prático separar os elementos tendo em vista à aproximação que
            // é feita no heightForRowAt em DetailViewController.
            commenterName.text = comment?.name
            commenterTitle.text = comment?.title
            commenterText.text = comment?.comment
        }
    }
    
    // MARK: - Constantes
    private let width = UIScreen.main.bounds.width
    
    private let commenterPhoto: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let commenterName: UILabel = {
        let view = UILabel()
        view.textColor = .mainOrange
        view.textAlignment = .left
        return view
    }()
    
    private let commenterTitle: UILabel = {
        let view = UILabel()
        view.textColor = .mainOrange
        view.textAlignment = .left
        return view
    }()
    
    private let commenterText: UILabel = {
        let view = UILabel()
        view.textColor = .mainOrange
        view.numberOfLines = 0
        return view
    }()
    
    private let commenterComment: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textColor = .mainOrange
        return view
    }()
    
    private let secondStar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btnFavoriteImage")
        return view
    }()
    
    private let thirdStar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btnFavoriteImage")
        return view
    }()
    
    private let fourthStar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btnFavoriteImage")
        return view
    }()
    
    private let fifthStar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btnFavoriteImage")
        return view
    }()
    
    private let firstStar: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btnFavoriteImage")
        return view
    }()
    
    private let starsStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        return view
    }()
        
    // MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(commenterPhoto)
        addSubview(commenterName)
        addSubview(commenterTitle)
        addSubview(commenterText)
        addSubview(commenterComment)
        addSubview(starsStack)
    }
    
    override func layoutSubviews() {
        commenterPhoto.translatesAutoresizingMaskIntoConstraints = false
        commenterPhoto.topAnchor.constraint(equalTo: topAnchor, constant: Constants.defaultSpacing).isActive = true
        commenterPhoto.leftAnchor.constraint(equalTo: leftAnchor, constant: 2.5 * Constants.defaultSpacing).isActive = true
        var photoDimmension: CGFloat = Constants.CommentTableViewCell.photoDimensionProportion * width
        
        // Caso seja um iPad, utiliza-se um tamanho constante para todos tamanhos de iPad
        // Escolheu-se otimizar o app para iPhones
        if UIScreen.main.bounds.width > Constants.CommentTableViewCell.maxIphoneWidth {
            photoDimmension = Constants.CommentTableViewCell.photoDimensionForiPad
        }
        
        commenterPhoto.widthAnchor.constraint(equalToConstant: photoDimmension).isActive = true
        commenterPhoto.heightAnchor.constraint(equalTo: commenterPhoto.widthAnchor, multiplier: 1).isActive = true
        commenterPhoto.layer.cornerRadius = photoDimmension / 2
        commenterPhoto.layer.masksToBounds = true
        
        commenterName.translatesAutoresizingMaskIntoConstraints = false
        commenterName.topAnchor.constraint(equalTo: commenterPhoto.topAnchor, constant: Constants.defaultSpacing).isActive = true
        commenterName.leftAnchor.constraint(equalTo: commenterPhoto.rightAnchor, constant: Constants.defaultSpacing / 2).isActive = true
        
        commenterTitle.translatesAutoresizingMaskIntoConstraints = false
        commenterTitle.leftAnchor.constraint(equalTo: commenterName.leftAnchor).isActive = true
        commenterTitle.topAnchor.constraint(equalTo: commenterName.bottomAnchor).isActive = true
        
        commenterText.translatesAutoresizingMaskIntoConstraints = false
        commenterText.topAnchor.constraint(equalTo: commenterTitle.bottomAnchor).isActive = true
        commenterText.leftAnchor.constraint(equalTo: commenterTitle.leftAnchor).isActive = true
        commenterText.rightAnchor.constraint(equalTo: rightAnchor, constant: -2.5 * Constants.defaultSpacing).isActive = true
        
        starsStack.translatesAutoresizingMaskIntoConstraints = false
        starsStack.centerYAnchor.constraint(equalTo: commenterName.bottomAnchor).isActive = true
        starsStack.rightAnchor.constraint(equalTo: commenterText.rightAnchor).isActive = true
        starsStack.heightAnchor.constraint(equalToConstant: Constants.CommentTableViewCell.starsStackHeightProportion * width).isActive = true
        starsStack.widthAnchor.constraint(equalToConstant: Constants.CommentTableViewCell.starsStackWidthProportion * width).isActive = true
        
        starsStack.addArrangedSubview(firstStar)
        starsStack.addArrangedSubview(secondStar)
        starsStack.addArrangedSubview(thirdStar)
        starsStack.addArrangedSubview(fourthStar)
        starsStack.addArrangedSubview(fifthStar)
        
        setTextFontSize(forScreenHeight: UIScreen.main.bounds.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funções Auxiliares
    // Configura a opacidade das estrelas com base nas notas
    private func giveMark(_ mark: Int) {
        switch mark {
        case 1:
            secondStar.alpha = 0
            thirdStar.alpha = 0
            fourthStar.alpha = 0
            fifthStar.alpha = 0
        case 2:
            thirdStar.alpha = 0
            fourthStar.alpha = 0
            fifthStar.alpha = 0
        case 3:
            fourthStar.alpha = 0
            fifthStar.alpha = 0
        case 4:
            fifthStar.alpha = 0
        default:
            ()
        }
    }
    
    // Exibe a foto do usuário que fez o comentário
    private func updatePhotoDimension(imageData data: Data, proportion: CGFloat) {
        DispatchQueue.main.async { [ unowned weakSelf = self ] in
            weakSelf.commenterPhoto.image = UIImage(data: data)
        }
    }

    // Escolhe o tamanho da fonte dos textos com base no
    // tamanho da tela
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
        
        commenterName.font = UIFont.systemFont(ofSize: fontSize)
        commenterTitle.font = UIFont.systemFont(ofSize: fontSize)
        commenterText.font = UIFont.systemFont(ofSize: fontSize)
    }
    
}

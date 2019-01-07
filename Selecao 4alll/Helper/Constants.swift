//
//  Constants.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

// Contém as constantes que são utilizadas no projeto
struct Constants {
    
    // MARK: - Gerais
    // Tag utilizada na extensão UIViewController
    static let activityIndicatorTag = 512
    // Opacidade da tela de carregamento
    static let activityIndicatorAlpha: CGFloat = 0.45

    static let port = 3003
    // Endereço principal para requesições
    static let rootAddress = "http://dev.4all.com:\(port)"
    static let taskAddress = "tarefa"
    
    // Mensagem durante o carregamento
    static let noDataLabelSearch = "Carregando..."
    // Mensagem quando nenhum item é encontrado
    static let noItemsFound = "Nenhum resultado encontrado :/"
    // Espaço padrão
    static let defaultSpacing: CGFloat = 10
    static let btnRetryCornerRadius: CGFloat = 15
    static let btnRetryWidth: CGFloat = 100
    
    // Todas as proporções levam em consideração a largura da tela.
    // Utiliza-se a largura da tela pois é uma dimensão comum para diferentes alturas de telas.
    
    // MARK: - DetailView Constantes
    struct DetailViewConstants {
        // Logo
        static let logoDimensionProportion: CGFloat = 0.16
        static let paddingRightLogoProportion: CGFloat = 0.08
        static let logoHeightProportion: CGFloat = 0.04
        static let paddingTopLogoProportion: CGFloat = 0.04
        
        // Stack dos botões
        static let btnsHeightProportion: CGFloat = 0.16
        
        // Altura do separador
        static let separatorHeight: CGFloat = 1
    }
    
    // MARK: - DetailViewController Constantes
    struct DetailViewController {
        // Tamanho da célula da seção que contém o mapa
        static let mapHeightProportion: CGFloat = 0.35
        // Valor para a aproximação do frame do texto do comentário
        static let heightApproximationConstant: CGFloat = 1000
    }
    
    // MARK: - ButtonCollectionViewCell Constantes
    struct ButtonCollectionViewCell {
        static let buttonSizeProportion: CGFloat = 0.1
    }
    
    // MARK: - MapViewTableViewCell Constantes
    struct MapViewTableViewCell {
        static let mapViewHeightProportion: CGFloat = 0.06
        static let pinDimensionProportion: CGFloat = 0.1
    }
    
    // MARK: - CommentTableViewCell Constantes
    struct CommentTableViewCell {
        // Foto do usuário que fez o comentário
        static let photoDimensionProportion: CGFloat = 0.16
        static let photoDimensionForiPad: CGFloat = 80
        
        // UIStackView que contém as estrelas (nota)
        static let starsStackHeightProportion: CGFloat = 0.03
        static let starsStackWidthProportion: CGFloat = 5 * starsStackHeightProportion
        
        // Largura máxima de m iphone, utilizado quando trata-se de um iPad
        static let maxIphoneWidth: CGFloat = 414
        
    }
    
    // MARK: - Tamanhos das Fontes
    // Priorizou-se telas de iphone a partir de 4"
    // A otimização ocorre para estas telas, mesmo assim é possível
    // visualizar corretamente as informações em um iPad
    struct FontSizes {
        
        struct iPhone5SE {
            static let textSize: CGFloat = 10
            static let titleSize: CGFloat = 20
        }
        
        struct iphone678 {
            static let textSize: CGFloat = 12
            static let titleSize: CGFloat = 25
        }
        
        struct iphone678Plus {
            static let textSize: CGFloat = 14
            static let titleSize: CGFloat = 30
        }
        
        struct iphoneX {
            static let textSize: CGFloat = 12
            static let titleSize: CGFloat = 25
        }
        
        struct iphoneXR {
            static let textSize: CGFloat = 14
            static let titleSize: CGFloat = 30
        }
        
        struct ipad {
            static let textSize: CGFloat = 20
            static let titleSize: CGFloat = 30
        }
    }
    
    // MARK: - Nomes Botões de Ação
    struct ActionButtonNames {
        static let call = "Ligar"
        static let services = "Serviços"
        static let address = "Endereço"
        static let comments = "Comentários"
        static let favorites = "Favoritos"
    }
    
}



//
//  DetailViewController.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource {

    // MARK: - Variáveis
    // View principal
    private lazy var detailView = DetailView()
    // Contém as informações principais que serão dispostas em uma Table View
    private var sections = [DetailSection]()
    
    // Ao receber as informações do item, a detailView é preenchida
    var detail: MainDetail? {
        didSet {
            if let header = detail?.headerInfo, let sections = detail?.details {
                DispatchQueue.main.async { [ unowned weakSelf = self ] in
                    weakSelf.navigationItem.titleView = weakSelf.detailView.titleView
                    weakSelf.detailView.titleView.text = header.title
                    weakSelf.detailView.details = header
                }
                buttonsInfo = ButtonsInformations(details: header, actionButton: nil)
                self.sections = sections
            }
        }
    }
    
    private var buttonsInfo: ButtonsInformations?
    
    let buttons = [ActionButton(title: Constants.ActionButtonNames.call, image: UIImage(named: "btnCallImage")),
                   ActionButton(title: Constants.ActionButtonNames.services, image: UIImage(named: "btnServicesImage")),
                   ActionButton(title: Constants.ActionButtonNames.address, image: UIImage(named: "btnAddressImage")),
                   ActionButton(title: Constants.ActionButtonNames.comments, image: UIImage(named: "btnCommentsImage")),
                   ActionButton(title: Constants.ActionButtonNames.favorites, image: UIImage(named: "btnFavoriteImage"))]
    
    // MARK: - View Lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let header = detail?.headerInfo {
            DispatchQueue.main.async { [ unowned weakSelf = self ] in
                weakSelf.detailView.titleView.text = header.title
            }
        }
    }
    
    override func loadView() {
        detailView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view = detailView
    }
    
    // MARK: - Funções Auxiliares
    // Configura a tableView
    private func setup() {
        detailView.collectionView.delegate = self
        detailView.collectionView.dataSource = self
        
        detailView.tableView.delegate = self
        detailView.tableView.dataSource = self
        detailView.tableView.estimatedRowHeight = 200
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btnSearch"), style: .plain, target: nil, action: nil)
    }
     
}

// MARK: - DetailViewActionsDelegate
extension DetailViewController: ButtonActionDelegate {
    
    // Caso haja algum erro em alguma das ações
    func error(_ error: String) {
        let alert = UIAlertController(title: "Erro", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Exibe a janela para fazer a ligação
    func callNumber(number: String) {
        if let phoneCallURL = URL(string: "tel://\(number)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // Exibe a tela de serviços
    func openServices() {
        navigationController?.pushViewController(ServicesViewController(), animated: true)
    }
    
    // Exibe o endereço como popup
    func showAddress(_ address: String) {
        let alert = UIAlertController(title: "Endereço", message: address, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Faz o scroll até os comentários
    func scrollToComments() {
        if sections[2].sectionData.count != 0 {
            detailView.tableView.scrollToRow(at: IndexPath(row: 0, section: 2), at: .top, animated: true)
        } else {
            // Caso não haja comentários é exibida uma mensagem
            let alert = UIAlertController(title: "Comentários", message: "Não há comentários.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
}

// MARK: - UICollectionViewDelegate
// Configura a collectionView
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calcula o tamanho da célula levando em conta o botão e o label
        let height = Constants.ButtonCollectionViewCell.buttonSizeProportion * view.bounds.width + getFontSizeForText(forScreenHeight: view.bounds.height) + Constants.defaultSpacing * 0.5
        let width = (view.bounds.width - 2 * Constants.defaultSpacing) / CGFloat(buttons.count)
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as? ButtonCollectionViewCell else { return UICollectionViewCell() }
        buttonsInfo?.actionButton = buttons[indexPath.row]
        cell.delegate = self
        cell.buttonsInfo = buttonsInfo
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = sections[indexPath.section].sectionData[indexPath.row]
        
        // Identifica qual tipo de célula será configurada
        switch cellModel {
        case .mainText(let mainText):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTextTableViewCell", for: indexPath) as? MainTextTableViewCell else { return UITableViewCell() }
            cell.mainText = mainText
            return cell
        case .map(let mapAddress):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as? MapTableViewCell else { return UITableViewCell() }
            cell.mapInfo = mapAddress
            return cell
        case .comments(let comment):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.comment = comment
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = sections[indexPath.section].sectionData[indexPath.row]

        switch cellModel {
            
        // Para o caso do mapa, retorna-se um valor constante com base nas dimensões da tela
        case .map(_): return Constants.DetailViewController.mapHeightProportion * view.bounds.width
        
        // Para os comentários é feita uma estimativa para cada row para que seja retornado um tamanho de célula adequado, sem espaços extras
        case .comments(let comment):
            // Considera-se a largura do texto do comentário, para isso é necessário remover alguns espaços, como padding da foto, padding do text e tamanho da foto
            let approximateWidthOfCommentText = view.frame.width - 6 * Constants.defaultSpacing - view.frame.width * Constants.CommentTableViewCell.photoDimensionProportion
            let size = CGSize(width: approximateWidthOfCommentText, height: Constants.DetailViewController.heightApproximationConstant)
            
            // Considera-se o tamanho de texto para cada tela
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: getFontSizeForText(forScreenHeight: UIScreen.main.bounds.height))]
            
            // Usa-se o comentário exibido
            guard let comment = comment.comment else { return UITableView.automaticDimension }
            let estimatedFrame = NSString(string: comment).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            // É necessário ajustar o tamanho da célula levando-se em conta os outros elementos: padding da foto, padding top do nome, altura do nome e altura do texto
            let constant: CGFloat = 3 * Constants.defaultSpacing + 2 * getFontSizeForText(forScreenHeight: UIScreen.main.bounds.height)
            
            return estimatedFrame.height + constant
            
        // Apenas para o primeiro item, pois utiliza-se apenas um label pra exibir o texto
        default: return UITableView.automaticDimension
        }
    }

    // MARK: - Função Auxiliar
    private func getFontSizeForText(forScreenHeight screenHeight: CGFloat) -> CGFloat {
        var fontSize: CGFloat = 0
        
        switch screenHeight {
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
        
        return fontSize
    }
    
}

// MARK: - ActionButton
// Caracteriza o botão de ação
struct ActionButton {
    var title: String?
    var image: UIImage?
}

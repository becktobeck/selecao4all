//
//  MainList.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import Foundation

struct MainList {
    
    var delegate: MainListDelegate?
    
    // MARK: - Itens Lista
    // Faz a busca no servidor dos itens disponíveis
    func getMainListItems() {
        guard let link = URL(string: "\(Constants.rootAddress)/\(Constants.taskAddress)") else { return }
        
        URLSession.shared.dataTask(with: link) { (data, response, error) in
            if let error = error {
                self.delegate?.loadError(error.localizedDescription)
            } else {
                do {
                    guard let data = data else { return }
                    let items = try JSONDecoder().decode(List.self, from: data)
                    self.prepareResultForTabelView(with: items)
                    
                } catch let error {
                    self.delegate?.loadError(error.localizedDescription)
                }
                
            }
            }.resume()
    }
    
    // Organiza as informações para exibidas na tableView em ListViewController
    private func prepareResultForTabelView(with data: List) {
        var results = [String]()
        
        guard let result = data.lista else { return }
        
        for item in result {
            results.append(item)
        }
        
        if result.isEmpty {
            delegate?.loadError(Constants.noItemsFound)
        } else {
            self.delegate?.listResult(from: result)
        }
        
    }

    // MARK: - Item Selecionado
    // Busca informações do item selecionado
    func getItemDetails(withId id: String) {
        guard let link = URL(string: "\(Constants.rootAddress)/\(Constants.taskAddress)/\(id)") else { return }
        
        URLSession.shared.dataTask(with: link) { (data, response, error) in
            if let error = error {
                self.delegate?.loadError(error.localizedDescription)
            } else {
                do {
                    guard let data = data else { return }
                    let item = try JSONDecoder().decode(Item.self, from: data)
                    
                    self.delegate?.getDetail(from: self.prepareResultForTableView(fromItem: item))
                    
                } catch let error {
                    self.delegate?.loadError(error.localizedDescription)
                }
                
            }
            }.resume()
    }
    
    // Prepara as informações para serem exibidas na tela principal
    private func prepareResultForTableView(fromItem item: Item) -> MainDetail {
        // Texto principal
        let mainTextSection = DetailSection(sectionData: [.mainText(MainText(mainText: item.texto))])
        // Mapa e endereço
        let mapSection = DetailSection(sectionData: [.map(MapAddress(address: "\(item.endereco ?? "Endereço")", coordinates: MapCoordinates(longitude: item.longitude, latitude: item.latitude)))])
        // Comentários
        let commentSection = DetailSection(sectionData: getComments(fromItem: item))
        
        return MainDetail(headerInfo: HeaderInfo(title: "\(item.cidade ?? "Cidade") - \(item.bairro ?? "Bairro")", urlCover: item.urlFoto, urlLogo: item.urlLogo, name: item.titulo, phone: item.telefone, address: item.endereco), details: [mainTextSection, mapSection, commentSection])
    }
    
    // Retorna o array de comentários
    private func getComments(fromItem item: Item) -> [ItemDetail] {
        var comments = [ItemDetail]()
        
        guard let itemComments = item.comentarios else { return comments }
        
        for comment in itemComments {
            comments.append(.comments(Comments(urlPhoto: comment.urlFoto, name: comment.nome, mark: comment.nota, title: comment.titulo, comment: comment.comentario)))
        }
        
        return comments
    }
    
}

// MARK: - Protocolo Lista Principal
protocol MainListDelegate {
    // Retorna todas informações em formatação para a TableView
    func getDetail(from item: MainDetail)
    
    // Retorna a identidade dos elementos da lista para exibição na TableView
    func listResult(from list: [String])
    
    // Retorna eventual erro
    func loadError(_ error: String)
}

// MARK: - Detalhes do Item
struct MainDetail {
    var headerInfo: HeaderInfo
    var details: [DetailSection]
}

// Informações para row da section
struct DetailSection {
    var sectionData: [ItemDetail]
}

// Contém as informações gerais do item
struct HeaderInfo {
    var title: String?
    var urlCover: String?
    var urlLogo: String?
    var name: String?
    var phone: String?
    var address: String?
}

// Tipos de células para a tableView da tela principal
enum ItemDetail {
    case mainText(MainText)
    case map(MapAddress)
    case comments(Comments)
}

// Texto da tela princiapl
struct MainText {
    var mainText: String?
}

// Informação que aparecem na section mapa
struct MapAddress {
    var address: String?
    var coordinates: MapCoordinates?
}

// Coordenadas do mapa
struct MapCoordinates {
    var longitude: Double?
    var latitude: Double?
}

// Informações que aparecem na section de comentários
struct Comments {
    var urlPhoto: String?
    var name: String?
    var mark: Int?
    var title: String?
    var comment: String?
}

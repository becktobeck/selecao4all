//
//  JSONElements.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import Foundation

// Contém os elementos para decodificação

// MARK: - Itens Lista
struct List: Decodable {
   var lista: [String]?
}

// MARK: - Detalhes do Item
struct Item: Decodable {
    var id: String?
    var cidade: String?
    var bairro: String?
    var urlFoto: String?
    var urlLogo: String?
    var titulo: String?
    var telefone: String?
    var texto: String?
    var endereco: String?
    var latitude: Double?
    var longitude: Double?
    var comentarios: [Comment]?
}

// MARK: - Comentário
struct Comment: Decodable {
    var urlFoto: String?
    var nome: String?
    var nota: Int?
    var titulo: String?
    var comentario: String?
}

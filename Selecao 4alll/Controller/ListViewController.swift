//
//  ListViewController.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 03/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Variáveis
    // View principal
    // Contém 3 views: tableView, noDataView e tableViewError
    // A primeira exibe os itens da lista, se há itens disponíveis.
    // A segunda exibe uma mensagem na tela se nenhum elemento for encontrado.
    // A última exibe uma mensagem de erro juntamente com um botão para refazer a busca.
    private var listView = ListView()
    
    // Model
    private var mainList = MainList()
    private var refreshControl = UIRefreshControl()
    
    // Avalia a mudança de estado da TableView com property observer
    private var state: TableViewState = .noData {
        didSet {
            switch state {
            case .noData:
                // Caso não tenha elementos, informa que não foram encontrados elementos.
                mainListElements = []
                listView.noDataView.noDataText = Constants.noDataLabelSearch
                listView.noDataView.isHidden = false
                listView.tableView.isHidden = true
                listView.tableViewError.isHidden = true
            case .loaded(let cells):
                // Carrega os resultados
                mainListElements = cells
                listView.noDataView.isHidden = true
                listView.tableView.isHidden = false
                listView.tableViewError.isHidden = true
            case .error(let error):
                // Exibe a mensagem de erro
                listView.tableViewError.errorText = error
                listView.noDataView.isHidden = true
                listView.tableView.isHidden = true
                listView.tableViewError.isHidden = false
            }
        }
    }
    
    // Quando há mudança nos elementos da lista a tableView é recarregada
    private var mainListElements: [String] = [] {
        didSet {
            listView.tableView.reloadData()
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura o delegate
        mainList.delegate = self
        
        // Configurações iniciais
        setup()
        
        // Faz a busca por elementos da lista
        loadList(withIndicator: true)
    }
    
    override func loadView() {
        listView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        listView.noDataView.noDataText = Constants.noDataLabelSearch
        listView.tableViewError.delegate = self
        view = listView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationItem.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Lista"
        deselectRow()
    }
    
    // MARK: - Funções Auxiliares
    private func setup() {
        setupRefreshControl()
        setupTableView()
        setupNavBar()
    }
    
    // Configura o refreshControl
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        loadList(withIndicator: false)
    }
    
    // Configura a tableView
    private func setupTableView() {
        listView.tableView.delegate = self
        listView.tableView.dataSource = self
        listView.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: "ListTableViewCell")
        listView.tableView.refreshControl = refreshControl
    }
    
    // Deseleciona a linha da tableView pressionada
    private func deselectRow() {
        if let indexPath = listView.tableView.indexPathForSelectedRow {
            listView.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // Faz a busca por elementos
    @objc private func loadList(withIndicator indicator: Bool) {
        if indicator { startActivityIndicator() }
        mainList.getMainListItems()
    }
    
}

// MARK: - MainListDelegate
extension ListViewController: MainListDelegate {
    // Recebe os elementos
    func listResult(from list: [String]) {
        DispatchQueue.main.async { [ unowned weakSelf = self ] in
            weakSelf.stopActivityIndicator()
            weakSelf.state = .loaded(list)
            weakSelf.refreshControl.endRefreshing()
        }
    }
    
    // Recebe a mensagem de erro
    func loadError(_ error: String) {
        DispatchQueue.main.async { [ unowned weakSelf = self ] in
            weakSelf.stopActivityIndicator()
            weakSelf.state = .error(error)
        }
    }
    
    // Faz a busca pelas informações do item selecionado para passar ao próximo vc.
    func getDetail(from item: MainDetail) {
        let vc = DetailViewController()
        vc.detail = item
        
        stopActivityIndicator()
        
        DispatchQueue.main.async { [ unowned weakSelf = self ] in
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

// MARK: - RetryDelegate
extension ListViewController: RetryDelegate {
    // Refaz a busca por elementos
    func retry() {
        state = .noData
        loadList(withIndicator: true)
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainListElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        
        cell.name = mainListElements[indexPath.row]
        
        return cell
    }
    
    // Inicia a busca de acordo com o elemento selecionado.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startActivityIndicator()
        mainList.getItemDetails(withId: mainListElements[indexPath.row])
    }
    
}

// MARK: - Table View State
enum TableViewState {
    case noData
    case loaded([String])
    case error(String)
}

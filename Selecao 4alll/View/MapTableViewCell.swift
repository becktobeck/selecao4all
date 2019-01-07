//
//  MapTableViewCell.swift
//  Selecao 4alll
//
//  Created by Fábio Beck Wanderer on 04/01/19.
//  Copyright © 2019 Fábio Beck Wanderer. All rights reserved.
//

import UIKit
import MapKit

// View que contém as informações do mapa e endereço
class MapTableViewCell: UITableViewCell {

    // MARK: - Variáveis
    var mapInfo: MapAddress? {
        didSet {
            if let mapInfo = mapInfo, let mapCoordinates = mapInfo.coordinates, let address = mapInfo.address {
                setInitialLocation(withCoordinates: mapCoordinates)
                addressLabel.text = address
            }
        }
    }
    
    // MARK: - Constantes
    private let regionRadius: CLLocationDistance = 1000
    private let width = UIScreen.main.bounds.width
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let mapFooter: UIView = {
        let view = UIView()
        view.backgroundColor = .mainOrange
        return view
    }()
    
    private let addressLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .right
        return view
    }()
    
    private let pinBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let pinImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "btnAddressImage")
        return view
    }()
    
    // MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubview(mapView)
        addSubview(mapFooter)
        addSubview(pinBackground)
        addSubview(addressLabel)
        addSubview(pinImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        mapFooter.translatesAutoresizingMaskIntoConstraints = false
        mapFooter.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        mapFooter.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        mapFooter.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive = true
        mapFooter.heightAnchor.constraint(equalToConstant: Constants.MapViewTableViewCell.mapViewHeightProportion * width).isActive = true
        
        pinBackground.translatesAutoresizingMaskIntoConstraints = false
        pinBackground.trailingAnchor.constraint(equalTo: mapFooter.trailingAnchor, constant: -Constants.defaultSpacing / 2).isActive = true
        pinBackground.bottomAnchor.constraint(equalTo: mapFooter.bottomAnchor, constant: -Constants.defaultSpacing / 2).isActive = true
        let pinDimension: CGFloat = Constants.MapViewTableViewCell.pinDimensionProportion * width
        pinBackground.heightAnchor.constraint(equalToConstant: pinDimension).isActive = true
        pinBackground.widthAnchor.constraint(equalToConstant: pinDimension).isActive = true
        pinBackground.layer.cornerRadius = pinDimension / 2
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.rightAnchor.constraint(equalTo: pinBackground.leftAnchor, constant: -Constants.defaultSpacing).isActive = true
        addressLabel.centerYAnchor.constraint(equalTo: mapFooter.centerYAnchor).isActive = true
        
        setAddresFontSize(forScreenHeight: UIScreen.main.bounds.height)
        
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        pinImageView.centerYAnchor.constraint(equalTo: pinBackground.centerYAnchor).isActive = true
        pinImageView.centerXAnchor.constraint(equalTo: pinBackground.centerXAnchor).isActive = true
        pinImageView.heightAnchor.constraint(equalToConstant: pinDimension - 2).isActive = true
        pinImageView.widthAnchor.constraint(equalToConstant: pinDimension - 2).isActive = true
        pinImageView.isUserInteractionEnabled = true
        pinImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(recenterMap)))
        
    }
    
    // MARK: - Funções Auxiliares
    // Caso o usuário tenha movida o mapa ou dado zoom, é
    // possível retornar à posição inicial do mapa
    @objc private func recenterMap() {
        if let mapInfo = mapInfo, let mapCoordinates = mapInfo.coordinates {
            setInitialLocation(withCoordinates: mapCoordinates)
        }
    }
    
    // Configura o tamanho da fonte com base no tamanho da tela
    private func setAddresFontSize(forScreenHeight height: CGFloat) {
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
        
        addressLabel.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    // Posição inicial do mapa
    private func setInitialLocation(withCoordinates coordinates: MapCoordinates) {
        if let latitude = coordinates.latitude, let longitude = coordinates.longitude {
            centerMapOnLocation(location: CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    
    // Centraliza o mapa com base nas coordenadas do endereço
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(Artwork(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
    }
}

//
//  HouseManager.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 08.08.21.
//

import Foundation
import CoreLocation
import UIKit

class HouseManager: NSObject {
    
    
    private let locationManager = CLLocationManager()
    var locationCoordinates = CLLocationCoordinate2D()
    var refreshTableView: (() -> Void)?
    
    private var houses: [House] = []
    var filteredHouses = [House]()
    var endRefresh:(()->Void)?
    var tableViewHidden:(()->Void)?
    var tableViewVisible:(()-> Void)?
    
    func addData(){
        
        fetchData { [weak self] houses in
            guard let self = self else { return }
            self.houses = houses
            self.filteredHouses = houses
            self.filteredHouses = self.filteredHouses.sorted {
                $0.price < $1.price
            }
            self.refreshTableView!()
        }
    }

    @objc func refresh(_ sender: AnyObject) {
        
        fetchData { [weak self]  houses in
            guard let self = self else { return }
            self.houses = houses
            self.filteredHouses = houses
            self.filteredHouses = self.filteredHouses.sorted{
                $0.price < $1.price
            }
            self.refreshTableView!()
            self.endRefresh!()
            
        }
        
    }
    
    @objc func searchRecords(_ textField: UITextField){
        
        filteredHouses = []
        
        if textField.text == ""{
            filteredHouses = houses
        }
        
        for i in houses{
            let address = "\(i.zip) \(i.city)"
            if let text = textField.text?.lowercased(){
                if address.lowercased().contains(text){
                    filteredHouses.append(i)
                }
            }
        }
        if filteredHouses.count == 0{
            tableViewHidden!()
            
            
        } else{
            tableViewVisible!()
            refreshTableView!()
        }
    }
    
    func fetchData(complation: @escaping ([House])->()){
        
        guard let url = URL(string: Constants.apiLink + Constants.endpointApiLink) else { return }
            var request = URLRequest(url: url)
            request.addValue(Constants.key, forHTTPHeaderField: Constants.accessKey)
            let dataTask = URLSession.shared.dataTask(with: request) {
                (data,response,error) in
                guard let data = data else { return }
                    do{
                        let houseJson = try JSONDecoder().decode([House].self, from: data)
                        complation(houseJson)
                    } catch{
                        print(error.localizedDescription)
                    }
                
            }
            dataTask.resume()
        
    }
    
    
    func locationConfigured(latitude: Double,longtitude:Double)-> String{
        
        var distance = ""
        if CLLocationManager.locationServicesEnabled(){
            switch CLLocationManager.authorizationStatus(){
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                distance = findDistance(firstLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), secondLocation: locationCoordinates)
            default:
                break
            }
        } else{
            print("Location services are not enabled")
        }
        return distance
    }
    
    
    func manageLocationPermissions(){
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func findDistance(firstLocation: CLLocationCoordinate2D, secondLocation: CLLocationCoordinate2D)-> String {
        
        let first = CLLocation(latitude: firstLocation.latitude, longitude: firstLocation.longitude)
        let second = CLLocation(latitude: secondLocation.latitude, longitude: secondLocation.longitude)
        let distance = first.distance(from: second) / 1000
        
        return " \(String(format: Constants.format, distance))\(Constants.measurement)"
    }
}

extension HouseManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            locationCoordinates.latitude = location.coordinate.latitude
            locationCoordinates.longitude = location.coordinate.longitude
            refreshTableView!()
        }
    }
}


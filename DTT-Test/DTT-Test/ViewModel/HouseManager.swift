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
    
    
    let locationManager = CLLocationManager()
    var locationCoordinates = CLLocationCoordinate2D()
    var refreshTableView: (() -> Void)?
    
    var houses = [House]()
    var filteredHouses = [House]()
    var endRefresh:(()->Void)?
    
    func addData(){
        
        fetchData { [self] houses in
            self.houses = houses
            self.filteredHouses = houses
            self.filteredHouses = self.filteredHouses.sorted {
                $0.price < $1.price
            }
            self.refreshTableView!()
        }
    }
    
    
  
    
    @objc func refresh(_ sender: AnyObject) {
        
        fetchData { houses in
            self.houses = houses
            self.filteredHouses = houses
            self.filteredHouses = self.filteredHouses.sorted {
                $0.price < $1.price
            }
                self.refreshTableView!()
                
            self.endRefresh!()
            
        }
        
    }
    
    func fetchData(complation: @escaping ([House])->()){
        
        if let url = URL(string: "https://intern.docker-dev.d-tt.nl/api/house"){
            var request = URLRequest(url: url)
            request.addValue("98bww4ezuzfePCYFxJEWyszbUXc7dxRx", forHTTPHeaderField: "Access-Key")
            let dataTask = URLSession.shared.dataTask(with: request) {
                (data,response,error) in
                if let data = data {
                    do {
                        let houseJson = try JSONDecoder().decode([House].self, from: data)
                        complation(houseJson)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            dataTask.resume()
        }
    }
 
    
    func locationConfigured(latitude: Double,longtitude:Double)-> String{
        
        var distance = ""
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                distance = findDistance(firstLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), secondLocation: locationCoordinates)
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
        return distance
    }
    

    func manageLocationPermissions(){
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    
    
    func findDistance(firstLocation: CLLocationCoordinate2D, secondLocation: CLLocationCoordinate2D)-> String {
        
        let first = CLLocation(latitude: firstLocation.latitude, longitude: firstLocation.longitude)
        let second = CLLocation(latitude: secondLocation.latitude, longitude: secondLocation.longitude)
        
        
        let distance = first.distance(from: second) / 1000
        print(distance)
        
        return " \(String(format:"%.02f", distance))"
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


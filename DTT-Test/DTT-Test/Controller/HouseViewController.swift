//
//  HouseViewController.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 30.07.21.
//

import UIKit
import CoreLocation

class HouseViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var viewTableView: UIView!
    
    var houses = [House]()
    var filteredHouses = [House]()
    let dataManager = DataManager()
    var newView = UIView()
    var locationCoordinates = CLLocationCoordinate2D()
    
    let locationManager = CLLocationManager()
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        newView = NoSearchedView(frame: CGRect(x: 0, y: 0, width: viewTableView.frame.width, height: viewTableView.frame.height))
        viewTableView.insertSubview(newView, at: 0)
        newView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        txtSearchBar.delegate = self
        tableView.register(HouseViewCell.nib(), forCellReuseIdentifier: "houseCell")
        addData()
        manageRefresh()
        addRightImageTo(textField: txtSearchBar, img: UIImage(named: "search")!.withAlignmentRectInsets(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 10)))
        
        
        
        txtSearchBar.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        
        manageLocationPermissions()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func manageLocationPermissions(){
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func addData(){
        
        dataManager.fetchData { houses in
            self.houses = houses
            self.filteredHouses = houses
            self.filteredHouses = self.filteredHouses.sorted {
                $0.price < $1.price
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    func manageRefresh(){
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        
        dataManager.fetchData { houses in
            self.houses = houses
            self.filteredHouses = houses
            self.filteredHouses = self.filteredHouses.sorted {
                $0.price < $1.price
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
        
    }
    
    func addRightImageTo(textField: UITextField,img: UIImage){
        
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        rightImageView.contentMode = .scaleToFill
        rightImageView.image = img
        textField.rightView = rightImageView
        textField.rightViewMode = .unlessEditing
        
    }
    
    
    
    @objc func searchRecords(_ textField: UITextView){
        
        if let button = txtSearchBar.value(forKey: "clearButton") as? UIButton {
            button.tintColor = .black
            
            button.setImage(UIImage(named: "close-2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        filteredHouses = []
        
        if textField.text == "" {
            filteredHouses = houses
        }
        
        for i in houses {
            let address = "\(i.zip) \(i.city)"
            if address.lowercased().contains(textField.text!.lowercased()) {
                filteredHouses.append(i)
            }
        }
        if filteredHouses.count == 0 {
            
            tableView.isHidden = true
            newView.isHidden = false
            
        } else {
            newView.isHidden = true
            tableView.isHidden = false
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailViewController {
            
            let model = filteredHouses[tableView.indexPathForSelectedRow!.row]
            
            let distance = findDistance(firstLocation: CLLocationCoordinate2D(latitude: Double(model.latitude), longitude: Double(model.longitude)), secondLocation: locationCoordinates)
            
            destination.details = DetailViewModel(image: model.image, price: model.price, bathrooms: model.bathrooms, bedrooms: model.bedrooms, surface: model.size, location: distance, description: model.description, latitude: model.latitude, longtitue: model.longitude)
            
            destination.coordinate = locationCoordinates
            
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            
        }
    }
    
    func findDistance(firstLocation: CLLocationCoordinate2D, secondLocation: CLLocationCoordinate2D)-> String {
        
        let first = CLLocation(latitude: firstLocation.latitude, longitude: firstLocation.longitude)
        let second = CLLocation(latitude: secondLocation.latitude, longitude: secondLocation.longitude)
        
        
        let distance = first.distance(from: second) / 1000
        print(distance)
        
        return " \(String(format:"%.02f", distance))"
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
}

extension HouseViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHouses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseCell", for: indexPath) as! HouseViewCell
        
        let model = filteredHouses[indexPath.row]
        
        let distance = locationConfigured(latitude: Double(model.latitude), longtitude: Double(model.longitude))
        
        cell.configure(viewModel: CellViewModel(image: model.image, price: model.price, bedrooms: model.bedrooms, bathrooms: model.bathrooms, surface: model.size, location: distance, address: "\(model.zip) \(model.city)"))
        cell.selectionStyle = .none
        
        return cell
    }
}


extension HouseViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: self)
        
        
    }
}

extension HouseViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            locationCoordinates.latitude = location.coordinate.latitude
            locationCoordinates.longitude = location.coordinate.longitude
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
}

extension HouseViewController: UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        txtSearchBar.resignFirstResponder()
        
        return true
    }
}

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
    
    
    let houseManager = HouseManager()
    var newView = UIView()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        houseManager.refreshTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        
        houseManager.endRefresh = {[weak self] in
            DispatchQueue.main.async {
                self!.refreshControl.endRefreshing()
            }
        }
        
        newView = NoSearchedView(frame: CGRect(x: 0, y: 0, width: viewTableView.frame.width, height: viewTableView.frame.height))
        viewTableView.insertSubview(newView, at: 0)
        newView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        txtSearchBar.delegate = self
        
        
        tableView.register(HouseViewCell.nib(), forCellReuseIdentifier: "houseCell")
        houseManager.addData()
        manageRefresh()
        addRightImageTo(textField: txtSearchBar, img: UIImage(named: "search")!.withAlignmentRectInsets(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 10)))
        
        txtSearchBar.addTarget(self, action: #selector(houseManager.searchRecords(_ :)), for: .editingChanged)
        
        houseManager.manageLocationPermissions()
        
        
        
        houseManager.tableViewHidden = {[weak self] in
            self!.tableView.isHidden = true
            self!.newView.isHidden = false
        }
        houseManager.tableViewVisible = {[weak self] in
            self!.newView.isHidden = true
            self!.tableView.isHidden = false
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func manageRefresh(){
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(houseManager.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func manageSearchButton(){
        
        if let button = txtSearchBar.value(forKey: "clearButton") as? UIButton {
            button.tintColor = .black
            
            button.setImage(UIImage(named: "close-2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    
    func addRightImageTo(textField: UITextField,img: UIImage){
        
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        rightImageView.contentMode = .scaleToFill
        rightImageView.image = img
        textField.rightView = rightImageView
        textField.rightViewMode = .unlessEditing
        
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailViewController {
            
            let model = houseManager.filteredHouses[tableView.indexPathForSelectedRow!.row]
            
            let distance = houseManager.findDistance(firstLocation: CLLocationCoordinate2D(latitude: Double(model.latitude), longitude: Double(model.longitude)), secondLocation: houseManager.locationCoordinates)
            
            destination.details = DetailModel(image: model.image, price: model.price, bathrooms: model.bathrooms, bedrooms: model.bedrooms, surface: model.size, location: distance, description: model.description, latitude: model.latitude, longtitue: model.longitude)
            
            destination.coordinate = houseManager.locationCoordinates
            
            
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            
        }
    }
    
    
    
}

extension HouseViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseManager.filteredHouses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "houseCell", for: indexPath) as! HouseViewCell
        
        let model = houseManager.filteredHouses[indexPath.row]
        
        let distance = houseManager.locationConfigured(latitude: Double(model.latitude), longtitude: Double(model.longitude))
        
        cell.configure(viewModel: CellModel(image: model.image, price: model.price, bedrooms: model.bedrooms, bathrooms: model.bathrooms, surface: model.size, location: distance, address: "\(model.zip) \(model.city)"))
        cell.selectionStyle = .none
        
        return cell
    }
}


extension HouseViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: self)
        
    }
}


extension HouseViewController: UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        txtSearchBar.resignFirstResponder()
        
        return true
    }
}

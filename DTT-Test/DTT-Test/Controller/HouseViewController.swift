//
//  HouseViewController.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 30.07.21.
//

import UIKit
import CoreLocation

class HouseViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var txtSearchBar: UITextField!
    @IBOutlet private weak var viewTableView: UIView!
    
    
    private let houseManager = HouseManager()
    private var newView = UIView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpDelegetes()
        setUpView()
        manageRefresh()
        addRightImageTo(textField: txtSearchBar, img: UIImage(named: Constants.searchImage)!
                            .withAlignmentRectInsets(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 10)))
        manageDataFromViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func editingChanged(_ sender: UITextField) {
        houseManager.searchRecords(sender)
    }
    
    private func setUpDelegetes(){
        tableView.dataSource = self
        tableView.delegate = self
        txtSearchBar.delegate = self
        
    }
    
    private func setUpView(){
        navigationController?.navigationBar.isHidden = true
        newView = NoSearchedView(frame: CGRect(x: 0, y: 0, width: viewTableView.frame.width, height: viewTableView.frame.height))
        viewTableView.insertSubview(newView, at: 0)
        newView.isHidden = true
        tableView.register(HouseViewCell.nib(), forCellReuseIdentifier: Constants.houseCellId)
    }
    
    private func manageDataFromViewModel(){
        
        houseManager.refreshTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        houseManager.endRefresh = {[weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        houseManager.tableViewHidden = {[weak self] in
            guard let self = self else { return }
            self.tableView.isHidden = true
            self.newView.isHidden = false
        }
        houseManager.tableViewVisible = {[weak self] in
            guard let self = self else { return }
            self.newView.isHidden = true
            self.tableView.isHidden = false
            
        }
        
        houseManager.addData()
        houseManager.manageLocationPermissions()
        
    }
    
    private func manageRefresh(){
        
        refreshControl.attributedTitle = NSAttributedString(string: Constants.refreshAlert)
        refreshControl.addTarget(self, action: #selector(houseManager.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func manageSearchButton(){
        
        if let button = txtSearchBar.value(forKey: Constants.clearButtonAsset) as? UIButton {
            button.tintColor = .black
            button.setImage(UIImage(named: Constants.closeButton)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    
    private func addRightImageTo(textField: UITextField,img: UIImage){
        
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        rightImageView.contentMode = .scaleToFill
        rightImageView.image = img
        textField.rightView = rightImageView
        textField.rightViewMode = .unlessEditing
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DetailViewController {
            if let index = tableView.indexPathForSelectedRow{
                
                let model = houseManager.filteredHouses[index.row]
                let coordinatesFirst = CLLocationCoordinate2D(latitude: Double(model.latitude), longitude: Double(model.longitude))
                let coordinatesSecond = houseManager.locationCoordinates
                
                let distance = houseManager.findDistance(firstLocation: coordinatesFirst, secondLocation: coordinatesSecond )
                
                destination.details = DetailModel(image: model.image, price: model.price, bathrooms: model.bathrooms, bedrooms: model.bedrooms, surface: model.size, location: distance, description: model.description, latitude: model.latitude, longtitue: model.longitude)
                
                destination.coordinate = houseManager.locationCoordinates
                
                
                tableView.deselectRow(at: index, animated: true)
            }
            
        }
    }
}

extension HouseViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        houseManager.filteredHouses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.houseCellId, for: indexPath) as! HouseViewCell
        
        let model = houseManager.filteredHouses[indexPath.row]
        
        let distance = houseManager.locationConfigured(latitude: Double(model.latitude), longtitude: Double(model.longitude))
        
        cell.configure(viewModel: CellModel(image: model.image, price: model.price, bedrooms: model.bedrooms, bathrooms: model.bathrooms, surface: model.size, location: distance, address: "\(model.zip) \(model.city)"))
        cell.selectionStyle = .none
        return cell
        
    }
}


extension HouseViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.detailSegueId, sender: self)
        
    }
}

extension HouseViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        txtSearchBar.resignFirstResponder()
        
        return true
    }
}

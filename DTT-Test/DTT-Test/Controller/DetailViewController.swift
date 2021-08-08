//
//  DetailViewController.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 01.08.21.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var detailView: DetailView!
    @IBOutlet private weak var houseView: UIImageView!
    
    var details: DetailModel?
    var detailsView: DetailView?
    var coordinate: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpBackButton()
        setDetailView()
        manageImageInDetailView()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    private func setDetailView(){
        
        if let details = details{
        detailView.configure(viewModel: details)
        }
        detailView.coordinate2 = coordinate
    }
    
    private func manageImageInDetailView(){
        
        if let image = details?.image{
            let imageUrlString = Constants.apiLink + image
        guard let imageUrl: URL = URL(string:imageUrlString ) else { return }
        houseView.contentMode = UIView.ContentMode.scaleAspectFill
        houseView.loadImge(withUrl: imageUrl)
        }
    }
    private func setUpBackButton(){
        let yourBackImage = UIImage(named: Constants.leftArrowAsset)
        navigationController?.navigationBar.backIndicatorImage = yourBackImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setUpNavigationBar(){
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
}

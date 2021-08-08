//
//  DetailViewController.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 01.08.21.
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailView: DetailView!
    
    
    @IBOutlet weak var houseView: UIImageView!
    
    var details: DetailModel?
    var detailsView: DetailView?
    var coordinate: CLLocationCoordinate2D?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let yourBackImage = UIImage(named: "left-arrow-2")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationController?.navigationBar.topItem?.title = ""

        detailView.configure(viewModel: details!)
        detailView.coordinate2 = coordinate
        
        let imageUrlString = "https://intern.docker-dev.d-tt.nl" + details!.image
        guard let imageUrl:URL = URL(string:imageUrlString ) else {return}
        houseView.contentMode = UIView.ContentMode.scaleAspectFill
        houseView.loadImge(withUrl: imageUrl)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailView.layer.cornerRadius = 10
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
}

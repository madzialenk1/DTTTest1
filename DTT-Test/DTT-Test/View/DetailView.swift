//
//  DetailView.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 31.07.21.
//

import UIKit
import MapKit

class DetailView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var bedroomNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var coordinate1 = CLLocationCoordinate2D()
    var coordinate2: CLLocationCoordinate2D?
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        commonInit()
        
    }
    
    func commonInit(){
        
        guard let viewFromNib = loadViewFromNib() else { return }
        
        viewFromNib.frame = self.bounds
        viewFromNib.layer.cornerRadius = 20
        
        mapView.delegate = self
        addSubview(viewFromNib)
        
    }
    
    func loadViewFromNib() -> UIView?{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Constants.viewIdentifier, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configureGesture(){
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action:#selector(handleTap))
        gestureRecognizer.delegate = self
        gestureRecognizer.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.isZoomEnabled = false
        
    }
    
    func configure(viewModel: DetailModel){
        
        configureGesture()
        
        coordinate1 = CLLocationCoordinate2D(latitude: CLLocationDegrees(viewModel.latitude), longitude: CLLocationDegrees(viewModel.longtitue))
        
        coordinate2 = CLLocationCoordinate2D(latitude: 52, longitude: 5)
        
        priceLabel.text = "$\(viewModel.price)"
        bathroomLabel.text = "\(viewModel.bathrooms)"
        bedroomNumberLabel.text = "\(viewModel.bedrooms)"
        descriptionLabel.text = viewModel.description
        locationLabel.text = "\(viewModel.location)"
        sizeLabel.text = "\(viewModel.surface)"
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(viewModel.latitude), longitude: Double(viewModel.longtitue)), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        addCustomPin(latitude: Double(viewModel.latitude),longitude: Double(viewModel.longtitue))
        
        
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer){
        
        if let coordinates = coordinate2 {
            getDirection(lat1: coordinate1.latitude, long1: coordinate1.longitude, lat2: coordinates.latitude, long2: coordinates.longitude)
            addCustomPin(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
        
    }
    
    func addCustomPin(latitude: Double, longitude:Double){
        
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(pin)
    }
    
    
    func getDirection(lat1: Double, long1: Double,lat2: Double, long2: Double){
        
        let location1 = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
        let location2 = CLLocationCoordinate2D(latitude: lat2, longitude: long2)
        let request = createDirectionRequest(to: location2, from: location1)
        let directions = MKDirections(request: request)

        directions.calculate {[weak self] (response, error) in
            guard let self = self else { return }
            guard let response = response else {return}
            for route in response.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
            }
        }
    }

    func createDirectionRequest(to coordinates: CLLocationCoordinate2D,
                                from location : CLLocationCoordinate2D) -> MKDirections.Request {
        
        let destinationCoordinate = coordinates
        let startingLocation = MKPlacemark(coordinate: location)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        return request
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 20
        
    }
    
}

extension DetailView: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationIdentifier)
        
        if annotationView==nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationIdentifier)
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: Constants.pinRed)
        
        return annotationView
    }
    
}


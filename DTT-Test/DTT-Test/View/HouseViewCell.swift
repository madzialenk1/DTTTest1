//
//  HouseViewCell.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 31.07.21.
//

import UIKit

class HouseViewCell: UITableViewCell {
    
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var houseImage: UIImageView!
    @IBOutlet private weak var kmLabel: UILabel!
    @IBOutlet private weak var surfaceLabel: UILabel!
    @IBOutlet private weak var bathroomNumberLabel: UILabel!
    @IBOutlet private weak var bedroomNumberLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib{
        return UINib(nibName: Constants.houseCellIdentifier, bundle: nil)
    }
    
    func configure (viewModel: CellModel){
        
        surfaceLabel.text = "\(viewModel.surface)"
        bathroomNumberLabel.text = "\(viewModel.bathrooms)"
        bedroomNumberLabel.text = "\(viewModel.bedrooms)"
        kmLabel.text = viewModel.location
        var price = "\(viewModel.price)"
        let count = price.count
        for point in stride(from: count - 3, to: 0, by: -3) {
            let i = price.index(price.startIndex, offsetBy: point)
            price.insert(",", at: i)
            
        }
        priceLabel.text = "$\(price)"
        addressLabel.text = "\(viewModel.address)"
        
        let imageUrlString = Constants.apiLink + viewModel.image
        guard let imageUrl: URL = URL(string: imageUrlString) else { return }
        
        houseImage.loadImge(withUrl: imageUrl)
        houseImage.layer.cornerRadius = 10
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
    }
    
}

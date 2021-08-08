//
//  HouseViewCell.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 31.07.21.
//

import UIKit

class HouseViewCell: UITableViewCell {
    
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var surfaceLabel: UILabel!
    @IBOutlet weak var bathroomNumberLabel: UILabel!
    @IBOutlet weak var bedroomNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HouseViewCell", bundle: nil)
    }
    
    public func configure (viewModel: CellModel){
        
        surfaceLabel.text = "\(viewModel.surface)"
        bathroomNumberLabel.text = "\(viewModel.bathrooms)"
        bedroomNumberLabel.text = "\(viewModel.bedrooms)"
        kmLabel.text = viewModel.location
        var price = "\(viewModel.price)"
        let count = price.count
        for p in stride(from: count-3, to: 0, by: -3) {
            let i = price.index(price.startIndex, offsetBy: p)
            price.insert(",", at: i)
            
        }
        priceLabel.text = "$\(price)"
        addressLabel.text = "\(viewModel.address)"
        
        let imageUrlString = "https://intern.docker-dev.d-tt.nl" + viewModel.image
        guard let imageUrl:URL = URL(string: imageUrlString) else {return}
        
        houseImage.loadImge(withUrl: imageUrl)
        houseImage.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        contentView.layer.cornerRadius = 10
        self.backgroundColor = .systemGray6
        contentView.backgroundColor = .white
    }
    
}

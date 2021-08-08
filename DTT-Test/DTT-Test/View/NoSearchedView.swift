//
//  NoSearchedView.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 31.07.21.
//

import UIKit

class NoSearchedView: UIView {
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
    }
    
    func commonInit(){
        
        let viewFromXib = Bundle.main.loadNibNamed(Constants.noSearchString, owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
}

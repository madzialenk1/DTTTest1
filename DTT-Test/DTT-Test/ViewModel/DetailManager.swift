//
//  DetailViewModel.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 08.08.21.
//

import Foundation
import UIKit
class DetailManager{
    
    func addHyperLink(textView: UITextView) {
        
        let path = Constants.path
        let text = textView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: Constants.path)
        textView.attributedText = attributedString
    }
}

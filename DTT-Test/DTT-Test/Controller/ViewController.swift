//
//  ViewController.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 30.07.21.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHyperLink()

    }
    
    func addHyperLink(){
        let path = "https://www.d-tt.nl/"
        let text = textView.text ?? ""
        let attributedString = NSAttributedString.makeHyperLink(for: path, in: text, as: "https://www.d-tt.nl/")
        textView.attributedText = attributedString
    }
   
}


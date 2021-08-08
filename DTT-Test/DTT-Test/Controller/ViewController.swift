//
//  ViewController.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 30.07.21.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var textView: UITextView!
    
    private let detailManager = DetailManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailManager.addHyperLink(textView: textView)
    }
    
 
   
}


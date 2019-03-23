//
//  ExtractViewController.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit
import YPImagePicker

class ExtractViewController: UIViewController {

    var image: UIImage!
    var seed: String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        textView.text = seed
    }
    
    @IBAction func copyBtnTapped(_ sender: Any) {
        guard let seed = seed, seed.isEmpty == false else { return }
        
        UIPasteboard.general.string = seed
        UIUtils.showOKAlert(vc: self, title: "Copied to Clipboard", message: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {})
    }
}

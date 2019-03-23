//
//  PinViewController.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit
import YPImagePicker

class PinViewController: UIViewController {

    var image: YPMediaPhoto!
    var seed: String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image.originalImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
}

extension PinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let seed = seed {
            let storyboard = UIStoryboard(name: "Save", bundle: nil)
            let save = storyboard.instantiateViewController(withIdentifier: "SaveViewController") as! SaveViewController
            save.image = image
            save.seed = seed
            self.navigationController?.pushViewController(save, animated: true)
        }
            else {
            let storyboard = UIStoryboard(name: "Extract", bundle: nil)
            let extract = storyboard.instantiateViewController(withIdentifier: "ExtractViewController") as! ExtractViewController
            extract.image = image
            self.navigationController?.pushViewController(extract, animated: true)

        }
        
        return true
    }
}

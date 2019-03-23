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
    
    var image: UIImage!
    var seed: String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
}

extension PinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let password = textField.text, password.isEmpty == false else {
            UIUtils.showOKAlert(vc: self, title: "Password should not be empty", message: nil)
            return false
        }

        if let seed = seed {
            let storyboard = UIStoryboard(name: "Save", bundle: nil)
            let save = storyboard.instantiateViewController(withIdentifier: "SaveViewController") as! SaveViewController
            save.image = image
            save.seed = seed
            save.password = password
            self.navigationController?.pushViewController(save, animated: true)
        }
        else {
            if let seed = Decoder().decode(image: image, key: password) {
                let storyboard = UIStoryboard(name: "Extract", bundle: nil)
                let extract = storyboard.instantiateViewController(withIdentifier: "ExtractViewController") as! ExtractViewController
                extract.image = image
                extract.seed = seed
                self.navigationController?.pushViewController(extract, animated: true)
            }
            else {
                UIUtils.showOKAlert(vc: self, title: "Sorry, something is wrong", message: "Please make sure the right message and password are used.")
            }
        }
        
        return true
    }
}

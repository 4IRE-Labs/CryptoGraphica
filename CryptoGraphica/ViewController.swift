//
//  ViewController.swift
//
//  Created by Brian Hans on 1/13/18.
//  Copyright © 2018 BrianHans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var outputImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var inputField: UITextField!
    
    private var encoded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        inputImage.image = #imageLiteral(resourceName: "ExampleImage")
        actionButton.setTitle("Encode", for: .normal)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(recognizer)
    }
    
    @IBAction func didAction(_ sender: Any) {
        if !encoded {
            encode()
            encoded = true
        } else {
            decode()
        }
    }
    @objc private func handleTap(_ sender: Any) {
        inputField.endEditing(true)
    }
    
    
    private func encode() {
        guard let source = inputImage.image else {
            return
        }
        
        let encodedImage = Encoder().encode(image: source, data: inputField.text ?? "no text")
        
        outputImage.image = encodedImage
        actionButton.setTitle("Decode", for: .normal)
    }
    
    private func decode() {
        guard let source = outputImage.image else {
            return
        }
        
        var response: String?
        if let data = Decoder().decode(image: source) {
            response = data
        } else {
            response = "Failed to decode"
        }
        
        let controller = UIAlertController(title: "Decoded message", message: response, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputField.endEditing(true)
        return true
    }
}


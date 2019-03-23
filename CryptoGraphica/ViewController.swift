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
    @IBOutlet weak var keyField: UITextField!
    
    private var encoded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        keyField.delegate = self
        
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
        keyField.endEditing(true)
    }
    
    
    private func encode() {
        guard let source = inputImage.image else {
            return
        }
        
        let encodedImage = Encoder().encode(image: source, data: inputField.text ?? "no text", key: keyField.text)
        
        outputImage.image = encodedImage
        actionButton.setTitle("Decode", for: .normal)
    }
    
    private func decode() {
        guard let source = outputImage.image else {
            return
        }
        
        var response: String?
        if let data = Decoder().decode(image: source, key: keyField.text) {
            response = data
        }
        
        
        
        let controller = UIAlertController(title: "Decoded message", message: response ?? "Failed to decode", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            controller.dismiss(animated: true, completion: nil)
        }))
        
        present(controller, animated: true, completion: nil)
        if response != nil {
            outputImage.image = nil
            actionButton.setTitle("Encode", for: .normal)
            encoded = false
        }
        
        
        
    }
}

extension ViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputField.endEditing(true)
        keyField.endEditing(true)
        
        return true
    }
}


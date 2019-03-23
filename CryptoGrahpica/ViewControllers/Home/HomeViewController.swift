//
//  ViewController.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import Photos

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logoHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: CGTextView!
    @IBOutlet weak var rocoverBottomOffset: NSLayoutConstraint!
    @IBOutlet weak var bgOverlay: UIImageView!
    @IBOutlet weak var orReserveTopOffset: NSLayoutConstraint!
    
    private let textFieldPlaceholder = "Enter seed prase..."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        textView.text = textFieldPlaceholder
        textView.textColor = UIColor.lightGray
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func storeToPhoto(_ sender: Any) {
        if textView.text.isEmpty || textView.text == textFieldPlaceholder {
            UIUtils.showOKAlert(vc: self, title: "The seed is empty", message: "Please enter the seed ...")
        }
        else {
            showPicker(title: "Save to Photo") { [weak self] (mediaItems) in
                guard let item = mediaItems.first else { return }
                switch item {
                case .photo(p: let photo):
                    let storyboard = UIStoryboard(name: "Pin", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
                    controller.imageView.image = photo.originalImage
                    self?.present(controller, animated: false, completion: nil)
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func recoverFromPhoto(_ sender: Any) {
        showPicker(title: "Recover from Photo") { [weak self] (mediaItems) in
            guard let item = mediaItems.first else { return }
            switch item {
            case .photo(p: let photo):
                let storyboard = UIStoryboard(name: "Pin", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
                controller.imageView.image = photo.originalImage
                self?.present(controller, animated: false, completion: nil)
            default:
                break
            }

        }
    }
    
    private func showPicker(title: String, action: @escaping ([YPMediaItem]) -> ()) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.onlySquareImagesFromCamera = false
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.wordings.libraryTitle = title
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.colors.tintColor = UIColor(named: "CGGreen")!
        config.colors.photoVideoScreenBackground = UIColor(named: "CGGreen")!
        config.showsFilters = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { (mediaItems, cancelled) in
            picker.dismiss(animated: false, completion: { })
            action(mediaItems)
        }
        present(picker, animated: true, completion: nil)
    }
}

//MARK: - Selectors
extension HomeViewController {
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.rocoverBottomOffset.constant = keyboardHeight + 20
            self.orReserveTopOffset.constant = 20
            UIView.animate(withDuration: 0.7) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillDisappear() {
        self.rocoverBottomOffset.constant = 20
        self.orReserveTopOffset.constant = 50
        UIView.animate(withDuration: 0.7) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textFieldPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

//
//  ViewController.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import DKPhotoGallery
import DKImagePickerController


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
        

        FromURL.shared.newValueSet = { [weak self] in
            if let fileURL = FromURL.shared.imageURL {
                let storyboard = UIStoryboard(name: "Pin", bundle: nil)
                let nav = storyboard.instantiateInitialViewController() as! UINavigationController
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    (nav.viewControllers.first as! PinViewController).image = UIImage(data: imageData)
                    self?.present(nav, animated: true, completion: nil)
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let fileURL = FromURL.shared.imageURL {
            let storyboard = UIStoryboard(name: "Pin", bundle: nil)
            let nav = storyboard.instantiateInitialViewController() as! UINavigationController
            do {
                let imageData = try Data(contentsOf: fileURL)
                (nav.viewControllers.first as! PinViewController).image = UIImage(data: imageData)
                self.present(nav, animated: true, completion: nil)
            }
            catch {
                print(error)
            }
        }
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
            showPicker(title: "Save to Photo") { [weak self] (image) in
                    let storyboard = UIStoryboard(name: "Pin", bundle: nil)
                    let nav = storyboard.instantiateInitialViewController() as! UINavigationController
                    (nav.viewControllers.first as! PinViewController).image = image
                    (nav.viewControllers.first as! PinViewController).seed = self?.textView.text
                    self?.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func recoverFromPhoto(_ sender: Any) {
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        documentPickerViewController.delegate = self
        present(documentPickerViewController, animated: true) {}

//        showPicker(title: "Recover from Photo") { [weak self] (image) in
//                let storyboard = UIStoryboard(name: "Pin", bundle: nil)
//                let nav = storyboard.instantiateInitialViewController() as! UINavigationController
//                (nav.viewControllers.first as! PinViewController).image = image
//                self?.present(nav, animated: true, completion: nil)
//
//        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func showPicker(title: String, action: @escaping (UIImage) -> ()) {
        

        
//        let imageURL = getDocumentsDirectory().appendingPathComponent("test.jpg")
//        let image    = UIImage(contentsOfFile: imageURL.path)
//
//        action(image!)

//
        let pickerController = DKImagePickerController()
        pickerController.singleSelect = true
        pickerController.assetType = .allPhotos
        pickerController.sourceType = .both
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            guard let originalAsset = assets.first?.originalAsset else { return }

            let requestImageOption = PHImageRequestOptions()
//            requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            requestImageOption.version = PHImageRequestOptionsVersion.original

            let manager = PHImageManager.default()
            manager.requestImage(for: originalAsset, targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { (image:UIImage?, _) in
                guard let image = image else { return }
                action(image)
            }
        }

        self.present(pickerController, animated: true, completion: {

        })

        
//        var config = YPImagePickerConfiguration()
//        config.library.mediaType = .photo
//        config.onlySquareImagesFromCamera = false
//        config.shouldSaveNewPicturesToAlbum = false
//        config.startOnScreen = .library
//        config.screens = [.library, .photo]
//        config.wordings.libraryTitle = title
//        config.hidesStatusBar = false
//        config.hidesBottomBar = false
//        config.colors.tintColor = UIColor(named: "CGGreen")!
//        config.colors.photoVideoScreenBackground = UIColor(named: "CGGreen")!
//        config.showsFilters = false
//        config.library.onlySquare = false
//
//        let picker = YPImagePicker(configuration: config)
//        picker.didFinishPicking { (mediaItems, cancelled) in
//            picker.dismiss(animated: true, completion: { })
//            action(mediaItems)
//        }
//        present(picker, animated: true, completion: nil)
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

extension HomeViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let storyboard = UIStoryboard(name: "Pin", bundle: nil)
            let nav = storyboard.instantiateInitialViewController() as! UINavigationController
                let imageData = try Data(contentsOf: url)
                (nav.viewControllers.first as! PinViewController).image = UIImage(data: imageData)
                self.present(nav, animated: true, completion: nil)
        }
        catch {
            print(error)
        }
        
    }
    
}

//
//  SaveViewController.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit
import YPImagePicker
import Photos

class SaveViewController: UIViewController {
    
    var image: YPMediaPhoto!
    var seed: String!
    var password: String!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image.originalImage
    }
    
    @IBAction func save(_ sender: Any) {
        //ToDo. Encrypt image with seed and password and save.
        
        let activityViewController = UIActivityViewController(activityItems: [self.image.image], applicationActivities:nil)
        activityViewController.excludedActivityTypes = [.print, .assignToContact, .addToReadingList, .openInIBooks, .markupAsPDF]
        self.present(activityViewController, animated: true) {}
        
        activityViewController.completionWithItemsHandler = { [weak self] (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            guard let sSelf = self else { return }
            if completed {
                if activityType?.rawValue == "com.viber.app-share-extension" {
                    UIUtils.showOKAlert(vc: sSelf, title: "Viber is compressing images. Please don't rely on Viber!!!", message: "Try other options!")
                }
                else {
                    let nameOfApp = String(activityType?.rawValue.split(separator: ".").last ?? "")
                    UIUtils.showOKAlert(vc: sSelf, title: "Saved the image with seed", message: nameOfApp)
                }
            }
            else {
                return
            }
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: {
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

//
//  UIUtils.swift
//  CryptoGrahpica
//
//  Created by test on 3/23/19.
//  Copyright © 2019 cg. All rights reserved.
//

import UIKit

class UIUtils: NSObject {
    static func showOKAlert(vc: UIViewController, title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.accessibilityLabel = "CGAlert"
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        alert.view.tintColor = UIColor.init(named: "CGGreen")
        if vc.isViewLoaded && vc.view.window != nil {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

//
//  UITextField extension.swift
//  Get Post request
//
//  Created by Roman Belov on 09.06.2022.
//

import UIKit

extension UITextField {
    func addBottomLine(withColor color: UIColor){
        let bottomline = CALayer()
        bottomline.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        bottomline.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomline)
    }
}

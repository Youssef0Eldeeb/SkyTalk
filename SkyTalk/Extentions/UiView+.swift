//
//  UiViewExtention.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 07/09/2022.
//

import Foundation
import UIKit

extension UIView{
    @IBInspectable var cornerRedius: CGFloat{
        get{
            return self.cornerRedius
            
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}

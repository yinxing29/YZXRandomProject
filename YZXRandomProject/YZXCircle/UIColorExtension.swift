//
//  UIColorExtension.swift
//  Swift_test
//
//  Created by yinxing on 2023/4/20.
//

import Foundation
import UIKit

extension UIColor {
    static func hexColor(_ hexValue: Int, alphaValue: Float = 1) -> UIColor {
        return UIColor(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255, green: CGFloat((hexValue & 0x00FF00) >> 8) / 255, blue: CGFloat(hexValue & 0x0000FF) / 255, alpha: CGFloat(alphaValue))
    }
    
    static func scaleAverageColor(color: UIColor, otherColor: UIColor) -> UIColor {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        var r1: CGFloat = 0.0
        var g1: CGFloat = 0.0
        var b1: CGFloat = 0.0
        var a1: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        otherColor.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        return UIColor(red: (r + r1) / 2.0, green: (g + g1) / 2.0, blue: (b + b1) / 2.0, alpha: 1.0)
    }
}

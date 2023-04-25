//
//  YZXRectTranslationAnimationViewController.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/4/25.
//

import Foundation
import UIKit

class YZXRectTranslationAnimationViewController: UIViewController {
    
    private let kBtnHeight = 30.0
    
    private lazy var shapeLayer: YZXRectTranslationAnimationLayer = {
        let screenWidth = UIScreen.main.bounds.size.width
        let btnWidth = (screenWidth - 40.0) / 4.0 - 20.0
        
        let layer = YZXRectTranslationAnimationLayer()
        layer.frame = view.bounds
        layer.fillColor = UIColor.orange.cgColor
        layer.animationDuration = 0.3
        if let btn = selectedBtn {
            layer.oneAnimationMinWidth = btn.frame.width + 20.0
        }
        layer.animationDefaultPathFrame = CGRect(x: 30.0, y: 300.0, width: btnWidth, height: kBtnHeight)
        return layer
    }()
    
    private var selectedBtn: UIButton?
    
    private var lastBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let screenWidth = UIScreen.main.bounds.size.width
        let btnWidth = (screenWidth - 40.0) / 4.0 - 20.0
        for i in 0..<4 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 30.0 + Double(i) * (btnWidth + 20.0), y: 300.0, width: btnWidth, height: kBtnHeight)
            btn.setTitle("\(i) btn", for: .normal)
            btn.setTitleColor(.gray, for: .normal)
            btn.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            view.addSubview(btn)
            
            if i == 0 {
                btn.isSelected = true
                selectedBtn = btn
            }
        }
        
        view.layer.insertSublayer(shapeLayer, at: 0)
    }
    
    //MARK: - 点击事件
    @objc private func buttonPressed(sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        if let btn = selectedBtn {
            btn.isSelected = !btn.isSelected
            lastBtn = selectedBtn
        }
        sender.isSelected = !sender.isSelected
        selectedBtn = sender
        
        if let fromBtn = lastBtn, let toBtn = selectedBtn {
            shapeLayer.starstartAnimation(fromRect: fromBtn.frame, toRect: toBtn.frame)
        }
    }
    //MARK: - ---------------------- 点击事件 END ----------------------
}

//
//  YZXRectTranslationAnimationTestView.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/4/25.
//

import Foundation
import UIKit

class YZXRectTranslationAnimationTestView: UIView {
    
    private let kBtnHeight = 5.0
    
    private lazy var shapeLayer: YZXRectTranslationAnimationLayer = {
        let screenWidth = bounds.width
        let btnWidth = (screenWidth - 4.0 * 3.0) / 4.0
        
        let layer = YZXRectTranslationAnimationLayer()
        layer.frame = bounds
        layer.fillColor = UIColor.orange.cgColor
        layer.animationDuration = 0.3
        if let btn = selectedBtn {
            layer.oneAnimationMinWidth = btn.frame.width + 4.0
        }
        layer.animationDefaultPathFrame = CGRect(x: 0.0, y: bounds.height / 2.0 - kBtnHeight / 2.0, width: btnWidth, height: kBtnHeight)
        return layer
    }()
    
    private var selectedBtn: UIButton?
    
    private var lastBtn: UIButton?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        p_initView()
    }
    
    //MARK: - init    
    private func p_initView() {
        let screenWidth = bounds.width
        let btnWidth = (screenWidth - 4.0 * 3.0) / 4.0
        for i in 0..<4 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0.0 + Double(i) * (btnWidth + 4.0), y: bounds.height / 2.0 - kBtnHeight / 2.0, width: btnWidth, height: kBtnHeight)
            btn.setTitle("\(i) btn", for: .normal)
            btn.setTitleColor(.gray, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 3.0)
            btn.isUserInteractionEnabled = false
            btn.tag = 1000 + i
            btn.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            addSubview(btn)
            
            if i == 0 {
                btn.isSelected = true
                selectedBtn = btn
            }
        }
        
        layer.insertSublayer(shapeLayer, at: 0)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {[weak self] timer in
            let i = arc4random() % 4
            if let btn = self?.viewWithTag(1000 + Int(i)) as? UIButton {
                self?.buttonPressed(sender: btn)
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    //MARK: - ---------------------- init END----------------------
    
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

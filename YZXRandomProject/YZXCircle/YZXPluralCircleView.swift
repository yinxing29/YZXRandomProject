//
//  YZXPluralCircleView.swift
//  Swift_test
//
//  Created by yinxing on 2023/4/20.
//

import Foundation
import UIKit

class YZXPluralCircleView: UIView {
    
    //MARK: - data
    var margin: CGFloat = 5.0
    
    var lineWidth: CGFloat = 20.0
    //MARK: - ---------------------- data END ----------------------
    
    //MARK: - UI
    private lazy var firstCircle: YZXSingleCircleView = {
        let view = YZXSingleCircleView(frame: .zero)
        view.startColor = UIColor.hexColor(0x4184FF)
        view.endColor = UIColor.hexColor(0xA6E4FF)
        view.strokeStart = 0.0
        view.strokeEnd = 1.0
        return view
    }()
    
    private lazy var secondCircle: YZXSingleCircleView = {
        let view = YZXSingleCircleView(frame: .zero)
        view.startColor = UIColor.hexColor(0xFCB23A)
        view.endColor = UIColor.hexColor(0xFFE999)
        view.strokeStart = 0.0
        view.strokeEnd = 0.8
        return view
    }()
    
    private lazy var thirdCircle: YZXSingleCircleView = {
        let view = YZXSingleCircleView(frame: .zero)
        view.startColor = UIColor.hexColor(0x6BCF9F)
        view.endColor = UIColor.hexColor(0xBBF8F4)
        view.strokeStart = 0.0
        view.strokeEnd = 0.3
        return view
    }()
    //MARK: - ---------------------- UI END ----------------------
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        p_initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = min(bounds.size.width, bounds.size.height)
        let length = lineWidth + margin
        
        firstCircle.frame = bounds
        secondCircle.frame = CGRect(x: length, y: length, width: width - length * 2.0, height: width - length * 2.0)
        thirdCircle.frame = CGRect(x: length * 2.0, y: length * 2.0, width: width - length * 4.0, height: width - length * 4.0)
        
        firstCircle.lineWidth = lineWidth
        secondCircle.lineWidth = lineWidth
        thirdCircle.lineWidth = lineWidth
    }
    
    //MARK: - init
    private func p_initView() {
        addSubview(firstCircle)
        addSubview(secondCircle)
        addSubview(thirdCircle)
    }
    //MARK: - ---------------------- init END----------------------
}

//
//  YZXSingleCircleView.swift
//  Swift_test
//
//  Created by yinxing on 2023/4/20.
//

import Foundation
import UIKit

class YZXSingleCircleView: UIView {
    
    var startColor: UIColor = UIColor.hexColor(0x4184FF) {
        didSet {
            p_settingColor()
        }
    }
    
    var endColor: UIColor = UIColor.hexColor(0xA6E4FF) {
        didSet {
            p_settingColor()
        }
    }
    
    var strokeStart: CGFloat = 0.0 {
        didSet {
            firstShapeLayer.strokeStart = strokeStart
        }
    }
    
    var strokeEnd: CGFloat = 1.0 {
        didSet {
            firstShapeLayer.strokeEnd = strokeEnd
        }
    }
    
    var lineWidth: CGFloat = 20.0 {
        didSet {
            halfLineWidth = lineWidth / 2.0
            p_refreshUI()
        }
    }
    
    private var halfLineWidth: CGFloat = 10.0
    
    //MARK: - layer
    private lazy var bgFirstShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = startColor.cgColor
        layer.opacity = 0.2
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var bgFirstPath: UIBezierPath?
    
    private lazy var firstShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = startColor.cgColor
        layer.lineWidth = lineWidth
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 1.0
        return layer
    }()
    
    private var firstPath: UIBezierPath?
    
    private lazy var firstGradientyBGLayer: CALayer = {
        let layer = CALayer()
        return layer
    }()
    
    private lazy var firstCenterColor: UIColor = {
        return UIColor.scaleAverageColor(color: startColor, otherColor: endColor)
    }()

    private lazy var first2PiColor: UIColor = {
        return UIColor.scaleAverageColor(color: startColor, otherColor: firstCenterColor)
    }()
    
    private lazy var first3PiColor: UIColor = {
        return UIColor.scaleAverageColor(color: firstCenterColor, otherColor: endColor)
    }()
    
    private lazy var firstTopRightGradientyLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [startColor.cgColor, first2PiColor.cgColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        return layer
    }()
    
    private lazy var firstBottomRightGradientyLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [first2PiColor.cgColor, firstCenterColor.cgColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 1.0, y: 0.0)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return layer
    }()
    
    private lazy var firstBottomLeftGradientyLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [firstCenterColor.cgColor, first3PiColor.cgColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 1.0, y: 1.0)
        layer.endPoint = CGPoint(x: 0.0, y: 0.0)
        return layer
    }()
    
    private lazy var firstTopLeftGradientyLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [first3PiColor.cgColor, endColor.cgColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 0.0)
        return layer
    }()
    
    private lazy var firstCircleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = startColor.cgColor
        return layer
    }()
    //MARK: - ---------------------- layer END ----------------------
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        p_initView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let length = min(bounds.size.width, bounds.size.height)
        let layerCenter = CGPoint(x: length / 2.0, y: length / 2.0)
        
        bgFirstShapeLayer.frame = bounds
        bgFirstPath = UIBezierPath(arcCenter: layerCenter, radius: length / 2.0 - halfLineWidth, startAngle: 0, endAngle: CGFloat.pi * 2.0, clockwise: true)
        bgFirstShapeLayer.path = bgFirstPath?.cgPath
        
        firstShapeLayer.frame = bounds
        firstPath = UIBezierPath(arcCenter: layerCenter, radius: length / 2.0 - halfLineWidth, startAngle: -CGFloat.pi / 2.0, endAngle: CGFloat.pi * 2.0 - CGFloat.pi / 2.0, clockwise: true)
        firstShapeLayer.path = firstPath?.cgPath
        
        firstGradientyBGLayer.frame = bounds
        firstTopRightGradientyLayer.frame = CGRect(x: length / 2.0, y: 0.0, width: length / 2.0, height: length / 2.0)
        firstBottomRightGradientyLayer.frame = CGRect(x: length / 2.0, y: length / 2.0, width: length / 2.0, height: length / 2.0)
        firstBottomLeftGradientyLayer.frame = CGRect(x: 0.0, y: length / 2.0, width: length / 2.0, height: length / 2.0)
        firstTopLeftGradientyLayer.frame = CGRect(x: 0.0, y: 0.0, width: length / 2.0, height: length / 2.0)
        firstGradientyBGLayer.mask = firstShapeLayer
        
        firstCircleLayer.frame = CGRect(x: length / 2.0 - halfLineWidth, y: 0.0, width: lineWidth, height: lineWidth)
        let path = UIBezierPath(arcCenter: CGPoint(x: halfLineWidth, y: halfLineWidth), radius: halfLineWidth, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
        firstCircleLayer.path = path.cgPath
    }
    
    //MARK: - init
    private func p_initView() {
        layer.addSublayer(bgFirstShapeLayer)
        layer.addSublayer(firstGradientyBGLayer)
        firstGradientyBGLayer.addSublayer(firstTopRightGradientyLayer)
        firstGradientyBGLayer.addSublayer(firstBottomRightGradientyLayer)
        firstGradientyBGLayer.addSublayer(firstBottomLeftGradientyLayer)
        firstGradientyBGLayer.addSublayer(firstTopLeftGradientyLayer)
        layer.addSublayer(firstCircleLayer)
    }
    //MARK: - ---------------------- init END----------------------
    
    private func p_settingColor() {
        firstCenterColor = UIColor.scaleAverageColor(color: startColor, otherColor: endColor)

        first2PiColor = UIColor.scaleAverageColor(color: startColor, otherColor: firstCenterColor)
        
        first3PiColor = UIColor.scaleAverageColor(color: firstCenterColor, otherColor: endColor)
        
        firstCircleLayer.fillColor = startColor.cgColor
        
        bgFirstShapeLayer.strokeColor = startColor.cgColor
        
        firstTopRightGradientyLayer.colors = [startColor.cgColor, first2PiColor.cgColor]
        
        firstBottomRightGradientyLayer.colors = [first2PiColor.cgColor, firstCenterColor.cgColor]

        firstBottomLeftGradientyLayer.colors = [firstCenterColor.cgColor, first3PiColor.cgColor]

        firstTopLeftGradientyLayer.colors = [first3PiColor.cgColor, endColor.cgColor]
    }
    
    private func p_refreshUI() {
        bgFirstShapeLayer.lineWidth = lineWidth
        firstShapeLayer.lineWidth = lineWidth
        
        setNeedsLayout()
    }
}

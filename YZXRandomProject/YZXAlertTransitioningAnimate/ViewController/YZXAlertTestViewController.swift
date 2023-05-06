//
//  YZXAlertTestViewController.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/5/5.
//

import Foundation
import UIKit

class YZXAlertTestViewController: UIViewController {
    
    var animationStyle = YZXAlertTransitioningAnimationStyle.popUp {
        didSet {
            animationingAnimate.animationStyle = animationStyle
        }
    }
    
    private lazy var bgView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var animationingAnimate: YZXAlertTransitioningAnimate = {
        let animation = YZXAlertTransitioningAnimate()
        return animation
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = animationingAnimate
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = (touches as NSSet).anyObject() as? UITouch {
            let point = touch.location(in: view)
            
            if bgView.frame.contains(point) {
                return
            }
        }
        
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        p_initView()
    }
    
    //MARK: - init
    private func p_initView() {
        view.addSubview(bgView)
        
        bgView.snp.makeConstraints { make in
            make.left.equalTo(40.0)
            make.right.equalTo(-40.0)
            make.centerY.equalToSuperview()
            make.height.equalTo(200.0)
        }
    }
    //MARK: - ---------------------- init END----------------------
}

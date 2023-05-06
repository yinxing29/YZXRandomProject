//
//  YZXCircleViewController.swift.swift
//  Swift_test
//
//  Created by yinxing on 2023/4/20.
//

import Foundation
import UIKit

class YZXCircleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        p_initView()
    }
    
    //MARK: - init
    private func p_initView() {
        
        let circleView = YZXPluralCircleView(frame: .zero)
        circleView.backgroundColor = .white
        view.addSubview(circleView)
                
        circleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(20.0)
            make.right.equalTo(-20.0)
            make.height.equalTo(circleView.snp.width).multipliedBy(1.0)
        }
    }
    //MARK: - ---------------------- init END----------------------
}

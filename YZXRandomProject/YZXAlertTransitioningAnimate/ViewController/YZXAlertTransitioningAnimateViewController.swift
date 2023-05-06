//
//  YZXAlertTransitioningAnimateViewController.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/5/5.
//

import Foundation
import UIKit

class YZXAlertTransitioningAnimateViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        p_initView()
    }
    
    //MARK: - init
    private func p_initView() {
        let btn = UIButton(type: .custom)
        btn.setTitle("button", for: .normal)
        btn.setTitleColor(.orange, for: .normal)
        btn.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        view.addSubview(btn)
        
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100.0)
        }
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("button1", for: .normal)
        btn1.setTitleColor(.orange, for: .normal)
        btn1.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        btn1.tag = 1001
        view.addSubview(btn1)
        
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(100.0)
        }
    }
    //MARK: - ---------------------- init END----------------------
    
    //MARK: - 点击事件
    @objc private func buttonPressed(sender: UIButton) {
        if sender.tag == 1001 {
            let vc = YZXAlertTestViewController()
            vc.animationStyle = .popOutFromBottom
            present(vc, animated: true)
            return
        }
        
        let vc = YZXAlertTestViewController()
        present(vc, animated: true)
    }
    //MARK: - ---------------------- 点击事件 END ----------------------
}

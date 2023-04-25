//
//  ViewController.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/4/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var dataSource: [[String: Any]] = {
        return [
            ["title": "画圆", "introductionView": circleView, "pageName": NSStringFromClass(YZXCircleViewController.self)],
            ["title": "无限轮博", "introductionView": unlimitedRotationView, "pageName": NSStringFromClass(YZXUnlimitedRotationViewController.self)]
        ]
    }()

    private let kYZXRandomPageCellIdentify = "kYZXRandomPageCellIdentify"
    
    //MARK: - 画圆
    private lazy var circleView: YZXPluralCircleView = {
        let view = YZXPluralCircleView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        view.margin = 2.0
        view.lineWidth = 5.0
        return view
    }()
    //MARK: - ---------------------- 画圆 END ----------------------
    
    //MARK: - 无限轮播
    private let kUnlimitedRotationCellIdentify = "unlimitedRotationCellIdentify"
    
    private var unlimitedRotationDataSource: [UIColor] = [.yellow, .purple, .orange, .red, .blue, .green, .gray, .cyan, .magenta, .brown]
    
    private lazy var unlimitedRotationView: YZXUnlimitedRotationView = {
        let rotationView = YZXUnlimitedRotationView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        rotationView.backgroundColor = .white
        rotationView.delegate = self
        rotationView.isShowPageControl = true
        rotationView.pageType = .left
        rotationView.pageControlHeight = 5.0
        rotationView.activeImage = UIImage.yzx_image(color: .gray, size: CGSize(width: 2.0, height: 2.0), cornerRadius: 1.0)
        rotationView.inactiveImage = UIImage.yzx_image(color: .orange, size: CGSize(width: 2.0, height: 2.0), cornerRadius: 1.0)
        return rotationView
    }()
    //MARK: - ---------------------- 无限轮播 END ----------------------
    
    private lazy var tableView: UITableView = {
        let tab = UITableView(frame: .zero, style: .plain)
        tab.backgroundColor = .white
        tab.delegate = self
        tab.dataSource = self
        tab.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 1.0, height: CGFloat.leastNormalMagnitude))
        tab.register(YZXRandomCell.self, forCellReuseIdentifier: kYZXRandomPageCellIdentify)
        return tab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "随性"
        view.backgroundColor = .white
        p_initView()
    }

    //MARK: - init
    private func p_initView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
        }
    }
    //MARK: - ---------------------- init END----------------------
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kYZXRandomPageCellIdentify, for: indexPath) as! YZXRandomCell
        cell.titleLab.text = dataSource[indexPath.row]["title"] as? String
        cell.introductionView = dataSource[indexPath.row]["introductionView"] as? UIView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vcClass = NSClassFromString(dataSource[indexPath.row]["pageName"] as! String), let vcType = vcClass as? UIViewController.Type else {
            return
        }
        
        let vc = vcType.init()
        vc.title = dataSource[indexPath.row]["title"] as? String
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: YZXUnlimitedRotationViewDelegate {
    func yzx_unlimitedRotationNumbers(view: YZXUnlimitedRotationView) -> Int {
        return unlimitedRotationDataSource.count
    }
    
    func yzx_unlimitedRotationView(view: YZXUnlimitedRotationView, index: Int) -> UITableViewCell {
        var cell = view.dequeueReusableCell(withReuseIdentifier: kUnlimitedRotationCellIdentify)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: kUnlimitedRotationCellIdentify)
        }
        cell?.contentView.backgroundColor = unlimitedRotationDataSource[index]
        return cell!
    }
    
    func yzx_unlimitedRotationView(view: YZXUnlimitedRotationView, didSelectedIndex index: Int) {
        print("------------------ \(index), \(unlimitedRotationDataSource[index])")
    }
}

//
//  YZXRandomCell.swift
//  YZXRandomProject
//
//  Created by yinxing on 2023/4/21.
//

import Foundation
import UIKit

class YZXRandomCell: UITableViewCell {
    
    var introductionView: UIView? {
        didSet {
            p_refreshUI()
        }
    }
    
    private(set) lazy var titleLab: UILabel = {
        let lab = UILabel(frame: .zero)
        lab.font = UIFont.systemFont(ofSize: 16.0)
        lab.textColor = UIColor.hexColor(0x333333)
        return lab
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        selectionStyle = .none
        p_initView()
    }
    
    //MARK: - init
    private func p_initView() {
        contentView.addSubview(titleLab)
        
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(15.0)
            make.centerY.equalToSuperview()
        }
    }
    //MARK: - ---------------------- init END----------------------
    
    private func p_refreshUI() {
        guard let view = introductionView else {
            titleLab.snp.updateConstraints { make in
                make.left.equalTo(15.0)
            }
            return
        }
        
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.left.equalTo(15.0)
            make.top.equalTo(5.0)
            make.bottom.equalTo(-5.0)
            make.size.equalTo(CGSize(width: 40.0, height: 40.0))
        }
        
        titleLab.snp.updateConstraints { make in
            make.left.equalTo(15.0 + 40.0 + 10.0)
        }
    }
}

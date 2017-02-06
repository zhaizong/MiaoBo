//
//  HomeTopSelectedView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/24.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 顶部选择视图

// @since 1.0.0
// @author 赵林洋
class HomeTopSelectedView: UIView {

  // MARK: - Property
  
  var topSelectedClosure: (() -> Void)?
  
  fileprivate var _squareButton: UIButton!
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension HomeTopSelectedView {
  
  fileprivate func _setupApperance() {
    _squareButton = UIButton(type: .custom)
    _squareButton.frame = .zero
    _squareButton.setTitle("广场", for: .normal)
    _squareButton.setTitleColor(UIColor.white, for: .normal)
    _squareButton.addTarget(self, action: #selector(_squareButtonDidClick(_:)), for: .touchUpInside)
    addSubview(_squareButton)
  }
  
  fileprivate func _layoutSubviews() {
    _squareButton.snp.makeConstraints { (make) in
      make.center.equalTo(self)
      make.width.equalTo(60)
    }
  }
  
}

extension HomeTopSelectedView {
  
  @objc fileprivate func _squareButtonDidClick(_ sender: UIButton) {
    topSelectedClosure?()
  }
  
}

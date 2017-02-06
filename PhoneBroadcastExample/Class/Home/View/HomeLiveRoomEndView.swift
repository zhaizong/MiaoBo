//
//  HomeLiveRoomEndView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/2/2.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 直播间, 直播结束的界面

// @since 1.0.0
// @author 赵林洋
class HomeLiveRoomEndView: UIView {

  // MARK: - Property
  
  var closeClosure: (() -> Void)?
  
  fileprivate var _closeButton: UIButton
  fileprivate var _lookOtherButton: UIButton
  fileprivate var _careButton: UIButton
  
  fileprivate var _defaultBackgroundImageView: UIImageView
  
  fileprivate var _liveEndView: UIView
  fileprivate var _topLine: UIView
  fileprivate var _bottomLine: UIView
  fileprivate var _liveEndLabel: UILabel
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _closeButton = UIButton(type: .custom)
    _lookOtherButton = UIButton(type: .custom)
    _careButton = UIButton(type: .custom)
    _defaultBackgroundImageView = UIImageView(frame: .zero)
    _liveEndView = UIView(frame: .zero)
    _topLine = UIView(frame: .zero)
    _bottomLine = UIView(frame: .zero)
    _liveEndLabel = UILabel(frame: .zero)
    
    super.init(frame: frame)
    _closeButton.setTitle("退出直播间", for: .normal)
    _closeButton.setTitleColor(UIColor(hexRGB: 0xD82974), for: .normal)
    _closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    _lookOtherButton.setTitle("查看房间其他主播", for: .normal)
    _lookOtherButton.setTitleColor(UIColor(hexRGB: 0xD82974), for: .normal)
    _lookOtherButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    _careButton.setTitle("+ 关注", for: .normal)
    _careButton.setTitleColor(.white, for: .normal)
    _careButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    _careButton.backgroundColor = UIColor(hexRGB: 0xD82974)
    
    _defaultBackgroundImageView.image = UIImage(named: "private_bg_375x229_")
    
    _liveEndView.backgroundColor = .clear
    _topLine.backgroundColor = .white
    _bottomLine.backgroundColor = .white
    _liveEndLabel.text = "直播结束"
    _liveEndLabel.textColor = .white
    _liveEndLabel.font = UIFont.systemFont(ofSize: 25)
    
    addSubview(_defaultBackgroundImageView)
    addSubview(_careButton)
    addSubview(_lookOtherButton)
    addSubview(_closeButton)
    
    _layoutSubviews()
    _setupMaskRadius(_closeButton)
    _setupMaskRadius(_lookOtherButton)
    _setupMaskRadius(_careButton)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension HomeLiveRoomEndView {
  
  fileprivate func _closeButtonDidClick(_ sender: UIButton) {
    closeClosure?()
  }
}

extension HomeLiveRoomEndView {
  
  fileprivate func _layoutSubviews() {
    _defaultBackgroundImageView.snp.makeConstraints { (make) in
      make.top.equalTo(snp.top)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
      make.bottom.equalTo(snp.bottom)
    }
    
    _closeButton.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.bottom.equalTo(snp.bottom).offset(-30)
      make.centerX.equalTo(snp.centerX)
    }
    
    _lookOtherButton.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.bottom.equalTo(_closeButton.snp.top).offset(-30)
      make.centerX.equalTo(snp.centerX)
    }
    
    _careButton.snp.makeConstraints { (make) in
      make.height.equalTo(50)
      make.bottom.equalTo(_lookOtherButton.snp.top).offset(-30)
      make.centerX.equalTo(snp.centerX)
    }
  }
  
  fileprivate func _setupMaskRadius(_ sender: UIButton) {
    sender.layer.cornerRadius = sender.frame.size.height * 0.5
    sender.layer.masksToBounds = true
    if sender != _careButton {
      sender.layer.borderWidth = 1
      sender.layer.borderColor = UIColor(hexRGB: 0xD82974).cgColor
    }
  }
}

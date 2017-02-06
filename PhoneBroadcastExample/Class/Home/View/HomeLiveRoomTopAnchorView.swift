//
//  HomeLiveRoomTopAnchorView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/2/1.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 直播间顶部主播相关视图

// @since 1.0.0
// @author 赵林洋
class HomeLiveRoomTopAnchorView: UIView {

  // MARK: - Property
  
  var user: PBCNewest?
  
  var live: PBCHot? {
    didSet {
      guard let live = live else { return }
      _live = live
      
      _headImageView.yy_setImage(with: URL(string: live.smallpic), placeholder: UIImage(named: "placeholder_head"))
      
      _nameLabel.text = live.myname
      
      _peopleLabel.text = "\(live.allnum)人"
      
      _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(_updateNum), userInfo: nil, repeats: true)
      
//      _headImageView.isUserInteractionEnabled = true
    }
  }
  fileprivate var _live: PBCHot!
  
  fileprivate var _anchorView: UIView
  fileprivate var _headImageView: UIImageView
  fileprivate var _nameLabel: UILabel
  fileprivate var _peopleLabel: UILabel
  fileprivate var _careButton: UIButton
  fileprivate var _giftViewButton: UIButton
  fileprivate var _peopleScrollView: UIScrollView
  
  fileprivate var _timer: Timer?
  fileprivate var _users: [AnyObject]?
  fileprivate var _randomNum: Int = 0
  
  fileprivate let _keyColor: UIColor = UIColor(red: 216 / 255, green: 41 / 255, blue: 116 / 255, alpha: 1)
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _anchorView = UIView(frame: .zero)
    _headImageView = UIImageView(frame: .zero)
    _nameLabel = UILabel(frame: .zero)
    _peopleLabel = UILabel(frame: .zero)
    _careButton = UIButton(type: .custom)
    _giftViewButton = UIButton(type: .custom)
    _peopleScrollView = UIScrollView(frame: .zero)
    super.init(frame: frame)
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    _timer?.invalidate()
    _timer = nil
  }

}

extension HomeLiveRoomTopAnchorView {
  
  @objc fileprivate func _updateNum() {
    _randomNum += Int(arc4random_uniform(5))
    _peopleLabel.text = "\(Int(_live.allnum) + _randomNum)人"
    _giftViewButton.setTitle("猫粮:\(123 + _randomNum), 娃娃:\(123 + _randomNum)", for: .normal)
  }
  
  @objc fileprivate func _device(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
}

extension HomeLiveRoomTopAnchorView {
  
  fileprivate func _setupApperance() {
    _peopleScrollView.showsVerticalScrollIndicator = false
    _peopleScrollView.showsHorizontalScrollIndicator = false
    
    _giftViewButton.setImage(UIImage(named: "cat_food_18x12_"), for: .normal)
    _giftViewButton.setTitle("猫粮:12345  娃娃124593", for: .normal)
    _giftViewButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    
    addSubview(_peopleScrollView)
    addSubview(_giftViewButton)
    
    _headImageView.image = UIImage(named: "placeholder_head")
    _headImageView.layer.borderWidth = 1
    _headImageView.layer.borderColor = UIColor.white.cgColor
    
    _nameLabel.text = "主播名字"
    _nameLabel.textColor = .white
    _nameLabel.font = UIFont.systemFont(ofSize: 15)
    
    _peopleLabel.text = "1024人"
    _peopleLabel.textColor = .white
    _peopleLabel.font = UIFont.systemFont(ofSize: 14)
    
    _careButton.setTitle("关闭", for: .normal)
    _careButton.setTitleColor(.white, for: .normal)
    _careButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    _careButton.setBackgroundImage(UIImage.imageWithColor(_keyColor, size: _careButton.frame.size), for: .normal)
    _careButton.setBackgroundImage(UIImage.imageWithColor(UIColor.lightGray, size: _careButton.frame.size), for: .normal)
    
    addSubview(_anchorView)
    _anchorView.addSubview(_headImageView)
    _anchorView.addSubview(_nameLabel)
    _anchorView.addSubview(_peopleLabel)
    _anchorView.addSubview(_careButton)
    
    _setupMasksToBounds(_anchorView)
    _setupMasksToBounds(_headImageView)
    _setupMasksToBounds(_careButton)
    _setupMasksToBounds(_giftViewButton)
  }
  
  fileprivate func _layoutSubviews() {
    _anchorView.snp.makeConstraints { (make) in
      make.top.equalTo(snp.top).offset(20)
      make.leading.equalTo(snp.leading)
      make.width.equalTo(220)
      make.height.equalTo(60)
    }
    
    _giftViewButton.snp.makeConstraints { (make) in
      make.top.equalTo(_anchorView.snp.bottom).offset(10)
      make.leading.equalTo(snp.leading)
      make.width.equalTo(220)
      make.height.equalTo(30)
    }
    
    _peopleScrollView.snp.makeConstraints { (make) in
      make.top.equalTo(_anchorView.snp.top)
      make.leading.equalTo(_anchorView.snp.trailing).offset(10)
      make.trailing.equalTo(snp.trailing).offset(-10)
      make.height.equalTo(50)
    }
    
    _headImageView.snp.makeConstraints { (make) in
      make.size.equalTo(50)
      make.top.equalTo(_anchorView.snp.top).offset(5)
      make.leading.equalTo(_anchorView.snp.leading).offset(10)
    }
    
    _nameLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_anchorView.snp.top).offset(5)
      make.leading.equalTo(_headImageView.snp.trailing).offset(10)
    }
    
    _peopleLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(_nameLabel.snp.leading)
      make.bottom.equalTo(_headImageView.snp.bottom)
    }
    
    _careButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(_headImageView.snp.centerY)
      make.leading.equalTo(_nameLabel.snp.trailing).offset(10)
      make.trailing.equalTo(snp.trailing).offset(-10)
      make.width.equalTo(50)
      make.height.equalTo(_headImageView.snp.height)
    }
  }
  
  fileprivate func _setupMasksToBounds(_ view: UIView) {
    view.layer.cornerRadius = view.frame.size.height * 0.5
    view.layer.masksToBounds = true
  }
}

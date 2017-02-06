//
//  HomeHotViewCell.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/25.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 热门 cell

// @since 1.0.0
// @author 赵林洋
fileprivate struct Common {
  static let RedColor = UIColor(red: 201 / 255, green: 72 / 255, blue: 76 / 255, alpha: 1)
  static let GrayColor = UIColor(red: 158 / 255, green: 158 / 255, blue: 158 / 255, alpha: 1)
}

class HomeHotViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  var hots: PBCHot? {
    didSet {
      guard let hots = hots else { return }
      
      _avatarImageView.yy_setImage(with: URL(string: hots.smallpic), placeholder: UIImage(named: "placeholder_head"), options: .refreshImageCache) { (image, url, type, stage, error) in
        if let image = image {
          self._avatarImageView.image = UIImage.circleImageWithOldImage(image, borderWidth: 1, borderColor: .red)
        }
      }
      
      _nameLabel.text = hots.myname
      
      if hots.gps == "" {
        hots.gps = "来自喵星"
      }
      _locationButton.setTitle(hots.gps, for: .normal)
      
      _pictureImageView.yy_setImage(with: URL(string: hots.bigpic), placeholder: UIImage(named: "profile_user_414x414"))
      
      if hots.starlevel > 0 {
        _startImageView.image = UIImage(named: "girl_star\(hots.starlevel)_40x19")
      }
      _startImageView.isHidden = hots.starlevel > 0 ? false : true
      
      let allnum = NSString(string: "\(hots.allnum)人在看")
      let attrStr = NSMutableAttributedString(string: "\(hots.allnum)人在看")
      attrStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 17), range: NSRange(location: 0, length: allnum.length))
//      attrStr.addAttribute(NSFontAttributeName, value: UIColor.red, range: NSRange(location: 0, length: allnum.length - 3))
//       修改后三个字
//      attrStr.addAttribute(NSFontAttributeName, value: Common.GrayColor, range: NSRange(location: allnum.length - 3, length: 3))
      _peoplenumLabel.attributedText = attrStr
    }
  }
  
  fileprivate var _view: UIView
  fileprivate var _avatarImageView: UIImageView
  fileprivate var _startImageView: UIImageView
  fileprivate var _pictureImageView: UIImageView
  fileprivate var _liveImageView: UIImageView
  fileprivate var _nameLabel: UILabel
  fileprivate var _peoplenumLabel: UILabel
  fileprivate var _locationButton: UIButton
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _view = UIView(frame: .zero)
    _avatarImageView = UIImageView(frame: .zero)
    _startImageView = UIImageView(frame: .zero)
    _pictureImageView = UIImageView(frame: .zero)
    _liveImageView = UIImageView(frame: .zero)
    _nameLabel = UILabel(frame: .zero)
    _peoplenumLabel = UILabel(frame: .zero)
    _locationButton = UIButton(type: .custom)
    super.init(frame: frame)
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension HomeHotViewCell {
  
  fileprivate func _setupApperance() {
    _avatarImageView.image = UIImage(named: "placeholder_head")
    
    _startImageView.image = UIImage(named: "girl_star1_40x19")
    
    _liveImageView.image = UIImage(named: "home_live_43x22")
    
    _nameLabel.font = UIFont.systemFont(ofSize: 14)
    _nameLabel.textAlignment = .left
    _nameLabel.text = ""
    
    _peoplenumLabel.font = UIFont.systemFont(ofSize: 14)
    _peoplenumLabel.textAlignment = .right
    _peoplenumLabel.text = ""
    
    _locationButton.frame = .zero
    _locationButton.setImage(UIImage(named: "home_location_8x8"), for: .normal)
    _locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
    _locationButton.setTitleColor(UIColor(hexRGB: 0x6F7179), for: .normal)
    
    contentView.addSubview(_view)
    _view.addSubview(_avatarImageView)
    _view.addSubview(_startImageView)
    _view.addSubview(_nameLabel)
    _view.addSubview(_peoplenumLabel)
    _view.addSubview(_locationButton)
    contentView.addSubview(_pictureImageView)
    contentView.addSubview(_liveImageView)
  }
  
  fileprivate func _layoutSubviews() {
    _view.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
      make.height.equalTo(55)
    }
    
    _avatarImageView.snp.makeConstraints { (make) in
      make.top.equalTo(5)
      make.leading.equalTo(10)
      make.size.equalTo(40)
    }
    
    _nameLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_avatarImageView.snp.top)
      make.leading.equalTo(_avatarImageView.snp.trailing).offset(10)
    }
    
    _startImageView.snp.makeConstraints { (make) in
      make.width.equalTo(40)
      make.height.equalTo(19)
      make.leading.equalTo(_nameLabel.snp.trailing).offset(10)
      make.centerY.equalTo(_nameLabel.snp.centerY)
    }
    
    _locationButton.snp.makeConstraints { (make) in
      make.top.equalTo(_nameLabel.snp.bottom).offset(5)
      make.leading.equalTo(_nameLabel.snp.leading)
    }
    
    _peoplenumLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(_avatarImageView.snp.centerY)
      make.leading.equalTo(_locationButton.snp.trailing).offset(40)
      make.trailing.equalTo(-10)
    }
    
    _pictureImageView.snp.makeConstraints { (make) in
      make.top.equalTo(_view.snp.bottom)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
      make.bottom.equalTo(contentView.snp.bottom).offset(-10)
    }
    
    _liveImageView.snp.makeConstraints { (make) in
      make.width.equalTo(43)
      make.height.equalTo(22)
      make.top.equalTo(_view.snp.bottom).offset(10)
      make.trailing.equalTo(contentView.snp.trailing).offset(-10)
    }
  }
  
}

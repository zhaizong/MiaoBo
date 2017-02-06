//
//  HomeNewestViewCell.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/31.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 最新 cell

// @since 1.0.0
// @author 赵林洋
class HomeNewestViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  var newest: PBCNewest? {
    didSet {
      guard let newest = newest else { return }
//      设置封面头像
      _coverImageView.yy_setImage(with: URL(string: newest.photo), placeholder: UIImage(named: "placeholder_head"))
//      是否是新主播, 0不是新主播
      _starImageview.isHidden = newest.newStar == 0 ? true : false
//      地址
      _locationButton.setTitle(newest.position, for: .normal)
//      主播名
      _nickNameLabel.text = newest.nickname
    }
  }
  
  fileprivate var _coverImageView: UIImageView
  fileprivate var _starImageview: UIImageView
  fileprivate var _locationButton: UIButton
  fileprivate var _nickNameLabel: UILabel
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _coverImageView = UIImageView(frame: .zero)
    _starImageview = UIImageView(frame: .zero)
    _locationButton = UIButton(type: .custom)
    _nickNameLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension HomeNewestViewCell {
  
  fileprivate func _setupApperance() {
    _coverImageView.image = UIImage(named: "placeholder_head")
    
    _starImageview.image = UIImage(named: "flag_new_33x17_")
    
    _locationButton.setTitleColor(.white, for: .normal)
    _locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    _locationButton.setImage(UIImage(named: "location_white_8x9_"), for: .normal)
    
    _nickNameLabel.textColor = .white
    _nickNameLabel.textAlignment = .center
    _nickNameLabel.font = UIFont.systemFont(ofSize: 13)
    
    contentView.addSubview(_coverImageView)
    contentView.addSubview(_starImageview)
    contentView.addSubview(_locationButton)
    contentView.addSubview(_nickNameLabel)
  }
  
  fileprivate func _layoutSubviews() {
    _coverImageView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
      make.bottom.equalTo(contentView.snp.bottom)
    }
    
    _starImageview.snp.makeConstraints { (make) in
      make.width.equalTo(33)
      make.height.equalTo(17)
      make.top.equalTo(contentView.snp.top).offset(5)
      make.trailing.equalTo(contentView.snp.trailing).offset(-10)
    }
    
    _locationButton.snp.makeConstraints { (make) in
      make.width.equalTo(100)
      make.top.equalTo(contentView.snp.top).offset(10)
      make.leading.equalTo(contentView.snp.leading).offset(10)
    }
  }
  
}

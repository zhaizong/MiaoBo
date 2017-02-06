//
//  HomeTitleScrollView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/24.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 导航栏下面的标签选择视图

// @since 1.0.0
// @author 赵林洋
enum HomeType: UInt {
  case hot
  case new
  case care
}

fileprivate struct Common {
  static let Titles = ["热门", "最新", "关注", "才艺", "附近", "海外", "官方"]
  static let Margin = 10
  static let Width = 60
}

class HomeTitleScrollView: UIView {

  // MARK: - Property
  
  var selectedType: HomeType! {
    didSet {
      _selectedButton.isSelected = false
      for view in _titleScrollView.subviews {
        if view.isKind(of: UIButton.self) && view.tag == Int(bitPattern: selectedType.rawValue) {
          _selectedButton = view as! UIButton
          (view as! UIButton).isSelected = true
        }
      }
    }
  }
  
  var isClickButton: Bool = false
  
  var buttonDidClickClosure: ((_ selectedType: HomeType) -> Void)?
  
  fileprivate(set) var underLine: UIView!
  fileprivate var _titleScrollView: UIScrollView!
  
  fileprivate var _hotButton: UIButton!
  fileprivate var _selectedButton: UIButton!
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension HomeTitleScrollView {
  
  @objc fileprivate func _buttonDidClick(_ sender: UIButton) {
    guard sender.tag <= 1 else { return }
      
    _selectedButton.isSelected = false
    sender.isSelected = true
    _selectedButton = sender
    
    UIView.animate(withDuration: 0.5) {
      self.underLine.frame.origin.x = sender.frame.origin.x
    }
    underLine.snp.updateConstraints({ (make) in
      make.centerX.equalTo(self._titleScrollView.snp.leading).offset(sender.frame.origin.x + CGFloat(Common.Width) * 0.5)
    })
    isClickButton = true
    buttonDidClickClosure?(HomeType(rawValue: UInt(sender.tag))!)
  }
  
}

extension HomeTitleScrollView {
  
  fileprivate func _setupApperance() {
    _titleScrollView = UIScrollView(frame: .zero)
    _titleScrollView.showsVerticalScrollIndicator = false
    _titleScrollView.showsHorizontalScrollIndicator = false
    _titleScrollView.backgroundColor = PBK_Main_Background_Color
    _titleScrollView.contentSize = CGSize(width: Common.Titles.count * Common.Width, height: 0)
    _titleScrollView.bounces = false
    addSubview(_titleScrollView)
    _titleScrollView.snp.makeConstraints { (make) in
      make.center.equalTo(snp.center)
      make.size.equalTo(snp.size)
    }
    
    for index in 0..<Common.Titles.count {
      let button = UIButton(type: .custom)
      button.setTitle(Common.Titles[index], for: .normal)
      button.setTitleColor(PBK_Title_Nor_Color, for: .normal)
      button.setTitleColor(PBK_Title_Sele_Color, for: .selected)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
      button.tag = index
      button.addTarget(self, action: #selector(_buttonDidClick(_:)), for: .touchUpInside)
      _titleScrollView.addSubview(button)
      if index == 0 {
        button.isSelected = true
        _hotButton = button
        _selectedButton = button
        button.snp.makeConstraints({ (make) in
          make.width.equalTo(Common.Width)
          make.centerY.equalTo(self)
          make.centerX.equalTo(_titleScrollView.snp.leading).offset(Common.Width - Common.Margin - 20)
        })
      } else {
        button.snp.makeConstraints({ (make) in
          make.width.equalTo(Common.Width)
          make.centerY.equalTo(self)
          make.centerX.equalTo(_titleScrollView.snp.leading).offset(index * Common.Width + Common.Margin + 20)
        })
      }
    }
    
    underLine = UIView(frame: .zero)
    underLine.backgroundColor = PBK_Title_SeparatorLine_Color
    _titleScrollView.addSubview(underLine)
    underLine.snp.makeConstraints { (make) in
      make.width.equalTo(Common.Width)
      make.height.equalTo(2)
      make.centerX.equalTo(_titleScrollView.snp.leading).offset(Common.Width - Common.Margin - 20)
      make.centerY.equalTo(snp.bottom).offset(-4)
    }
    
    let separatorLine = UIView(frame: .zero)
    separatorLine.backgroundColor = .lightGray
    addSubview(separatorLine)
    separatorLine.snp.makeConstraints { (make) in
      make.width.equalTo(PBK_Screen_Width)
      make.height.equalTo(0.5)
      make.leading.equalTo(0)
      make.bottom.equalTo(snp.bottom)
    }
    
    layoutIfNeeded()
    
  }
  
}

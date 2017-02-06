//
//  HomeBannerReusableView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/30.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 热门 显示轮播图的UICollectionReusableView

// @since 1.0.0
// @author 赵林洋
class HomeBannerReusableView: UICollectionReusableView {
  
  // MARK: - Property
  
  var imgString: [String]? {
    didSet {
      guard let imgString = imgString, imgString.count != 0 else { return }
      _bannerView.imgStrings = imgString
    }
  }
  
  fileprivate var _bannerView: PBKBannerView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    _bannerView.frame = CGRect(origin: .zero, size: CGSize(width: PBK_Screen_Width, height: 100))
  }
  
}

extension HomeBannerReusableView {
  
  fileprivate func _setupApperance() {
    _bannerView = PBKBannerView(frame: .zero)
    _bannerView.time = 2
    addSubview(_bannerView)
  }
  
}

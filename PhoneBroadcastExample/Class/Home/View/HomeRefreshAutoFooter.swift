//
//  HomeRefreshAutoFooter.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/27.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

class HomeRefreshAutoFooter: MJRefreshAutoStateFooter {

  var activityIndicatorViewStyle: UIActivityIndicatorViewStyle! {
    didSet {
      guard let _ = activityIndicatorViewStyle else { return }
      _loadingView = nil
      setNeedsLayout()
    }
  }
  
  fileprivate lazy var _loadingView: UIActivityIndicatorView? = { [weak self] in
    guard let weakSelf = self else { return UIActivityIndicatorView() }
    let lazilyCreatedView = UIActivityIndicatorView(activityIndicatorStyle: weakSelf.activityIndicatorViewStyle)
    lazilyCreatedView.hidesWhenStopped = true
    weakSelf.addSubview(lazilyCreatedView)
    return lazilyCreatedView
  }()

  override func prepare() {
    super.prepare()
    activityIndicatorViewStyle = .gray
  }
  
  override func placeSubviews() {
    super.placeSubviews()
    guard let _loadingView = _loadingView else { return }
    if _loadingView.constraints.count == 0 {
      return
    }
//    圈圈
    var loadingCenterX = mj_w * 0.5
    if isRefreshingTitleHidden == false {
      loadingCenterX -= stateLabel.mj_textWith() * 0.5 + labelLeftInset
    }
    let loadingcenterY = mj_h * 0.5
    _loadingView.center = CGPoint(x: loadingCenterX, y: loadingcenterY)
  }
  
  override var state: MJRefreshState {
    set {
      let oldState = self.state
      if newValue == oldState {
        return
      }
      super.state = newValue
//      根据状态做事情
      if newValue == .noMoreData || newValue == .idle {
        _loadingView?.stopAnimating()
      } else if newValue == .refreshing {
        _loadingView?.startAnimating()
      }
    }
    get {
      return self.state
    }
  }
  
}

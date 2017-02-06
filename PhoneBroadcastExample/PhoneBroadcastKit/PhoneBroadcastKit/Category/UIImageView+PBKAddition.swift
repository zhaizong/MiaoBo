//
//  UIImageView+PBKAddition.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/2/1.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
  
//  播放GIF
  public func playGifAnimate(_ images: [UIImage]) {
    guard images.count > 0 else { return }
//    动画图片数组
    animationImages = images
//    执行一次完整动画所需的时长
    animationDuration = 0.5
//    动画重复次数, 设置成0 就是无限循环
    animationRepeatCount = 0
    
    startAnimating()
  }
  
  public func stopGifAnimate() {
    if isAnimating {
      stopAnimating()
    }
    removeFromSuperview()
  }
}

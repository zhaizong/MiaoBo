//
//  UIColor+PBKAddition.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

public extension UIColor {
  
  // MARK: - Hex
  
  public convenience init(hexRGB: Int) {
    self.init(red:CGFloat((hexRGB >> 16) & 0xff) / 255.0,
              green:CGFloat((hexRGB >> 8) & 0xff) / 255.0,
              blue:CGFloat(hexRGB & 0xff) / 255.0,
              alpha: 1.0)
  }
}

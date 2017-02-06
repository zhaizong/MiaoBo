//
//  PBKNavigationController.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

public class PBKNavigationController: UINavigationController {

  override public class func initialize() {
    let bar = UINavigationBar.appearance()
    bar.setBackgroundImage(UIImage(named: "navBar_bg_414x70"), for: .default)
  }
  
  override public var childViewControllerForStatusBarStyle: UIViewController? {
    return self.topViewController
  }
  
  override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if childViewControllers.count != 0 {
      viewController.hidesBottomBarWhenPushed = true
    }
    super.pushViewController(viewController, animated: animated)
  }

}

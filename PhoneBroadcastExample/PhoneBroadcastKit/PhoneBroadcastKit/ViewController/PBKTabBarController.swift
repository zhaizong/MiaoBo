//
//  PBKTabBarController.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

public class PBKTabBarController: UITabBarController {

  // MARK: - Commons
  
  fileprivate let kHomeTabIndex = 0
  
  // MARK: - Property
  
  fileprivate var _homeNavigationViewController: UINavigationController!
  /*
  public override var selectedIndex: Int {
    didSet {
      
    }
  }
  */
  override public func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    _setupContentViewControllers()
  }

}

extension PBKTabBarController {
  
  fileprivate func _setupContentViewControllers() {
    UIApplication.shared.statusBarStyle = .lightContent
    _homeNavigationViewController = UIStoryboard.homeStoryboard().instantiateInitialViewController() as! UINavigationController
    
    viewControllers = [_homeNavigationViewController]
    
    if let homeTabItem = tabBar.items?[kHomeTabIndex] {
      homeTabItem.image = UIImage(named: "toolbar_home")?.withRenderingMode(.alwaysOriginal)
      homeTabItem.selectedImage = UIImage(named: "toolbar_home_sel")?.withRenderingMode(.alwaysOriginal)
      homeTabItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
  }
  
}

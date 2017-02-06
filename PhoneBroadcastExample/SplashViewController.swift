//
//  SplashViewController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, PBKStoryboardViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // TODO: - 用户账号管理相关的类 (iOS) 在此处判断是否登陆过
    let director = PBCDirector()
    PBCDirector.resetDefaultDirector(director)
    PBCDirector.default()?.resetManagers()
    // PBCDirector.default()?.signIn()...
    
    _setupApperance()
  }
  
  static func instanceFromStoryboard<T> () -> T {
    let vc = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "SplashViewController")
    return vc as! T
  }

}

extension SplashViewController {
  
  fileprivate func _setupApperance() {
    AppDelegate.pbe_sharedInstance().tabbarController = UIStoryboard.mainStoryboard().instantiateInitialViewController() as! PBKTabBarController
    SceneController.sharedController.replaceSceneWithHomeView()
  }
  
}

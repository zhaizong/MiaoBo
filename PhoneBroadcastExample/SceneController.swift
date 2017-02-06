//
//  SceneController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import Foundation
import UIKit

// 用于各个ViewController之间的切换
class SceneController {
  
  static let sharedController = SceneController()
  
  func replaceSceneWithSplashView() {
    let splashVC: SplashViewController = SplashViewController.instanceFromStoryboard()
    AppDelegate.pbe_sharedInstance().window?.rootViewController = splashVC
  }
  
  func replaceSceneWithHomeView() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController = appDelegate.tabbarController
    appDelegate.tabbarController.selectedIndex = 0
  }
  
}

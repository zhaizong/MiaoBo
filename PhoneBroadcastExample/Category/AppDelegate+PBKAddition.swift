//
//  AppDelegate+PBKAddition.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate {
  
  class func pbe_sharedInstance() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
  }
  
}

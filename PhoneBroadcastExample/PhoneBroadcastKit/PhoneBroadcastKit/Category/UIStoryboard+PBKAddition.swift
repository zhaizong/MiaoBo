//
//  UIStoryboard+PBKAddition.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

public extension UIStoryboard {
  
  public class func mainStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Main", bundle: nil)
  }
  
  public class func homeStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Home", bundle: nil)
  }
  
  public class func cameraStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Camera", bundle: nil)
  }
  
  public class func meStoryboard() -> UIStoryboard {
    return UIStoryboard(name: "Me", bundle: nil)
  }
  
}

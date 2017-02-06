//
//  PBKStoryboardViewController.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

public protocol PBKStoryboardViewController {
  static func instanceFromStoryboard<T> () -> T
}

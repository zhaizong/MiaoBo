//
//  PBKPreference.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import Foundation
import UIKit

struct PreferenceCommons {
  //  代表App启动次数
  static let AppLaunchTimes = "applaunchtimes"
  
  static let AppLaunchLanguage = "cn"
}
// 用户偏好设置
public class PBKPreference: NSObject {
  
  // MARK: - Public
  
  /// 用户 App 是否第一次启动
  public var preferredAppLaunchTimes: String {
    get {
      assert(_isDevicePreference)
      return _preferredAppLaunchTimes
    }
    set(newAppLaunchTimes) {
      assert(_isDevicePreference)
      _preferredAppLaunchTimes = newAppLaunchTimes
      _saveValueToDeviceBiliPreference(value: newAppLaunchTimes as AnyObject?, forKey: PreferenceCommons.AppLaunchTimes)
    }
  }
  
  // MARK: - Property
  
//  static var devicePreference: BiliPreference = BiliPreference()
  
  fileprivate static var _sharedPreference: PBKPreference?
  
  fileprivate var _plistIOQueue: DispatchQueue
  
  fileprivate var _isDevicePreference: Bool
  fileprivate var _preferredAppLaunchTimes: String
  
  // MARK: - Lifecycle
  
  public class func sharedPreference() -> PBKPreference {
    
    if let preference = _sharedPreference {
      return preference
    } else {
      _sharedPreference = PBKPreference()
      return _sharedPreference!
    }
  }
  
  override init() {
//    _plistIOQueue = dispatch_queue_create("com.MybilibiliDemo.preference", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, -1))
    _plistIOQueue = DispatchQueue(label: "com.PhoneBroadcastExample.preference", qos: DispatchQoS(qosClass: .background, relativePriority: -1))
    _isDevicePreference = true
    _preferredAppLaunchTimes = ""
    
    super.init()
    
    let folderPath = _devicePreferenceFolderPath()
    let locationFileName = _deviceBiliPreferencePlistPath()
    
    if FileManager.default.fileExists(atPath: locationFileName) { // 如果已经存储过该信息
      if let dict = NSDictionary(contentsOfFile: locationFileName) {
        // App启动次数
        if let preferredAppLaunchTimes = dict[PreferenceCommons.AppLaunchTimes] as? String {
          _preferredAppLaunchTimes = preferredAppLaunchTimes
        }
      }
    } else { // 如果是第一次存储
      _preferredAppLaunchTimes = ""
      if FileManager.default.fileExists(atPath: locationFileName) == false {
        do {
          try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
          return
        }
      }
      let dict = NSMutableDictionary()
      dict.setValue("", forKey: PreferenceCommons.AppLaunchTimes)
      dict.write(toFile: locationFileName, atomically: false)
    }
    
  }
}

extension PBKPreference {
  
  // MARK: - Private utils
  
  fileprivate func _devicePreferenceFolderPath() -> String {
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let folderPath = documentsPath + "/miaobo"
    return folderPath
  }
  
  fileprivate func _deviceBiliPreferencePlistPath() -> String {
    
    let fileName = _devicePreferenceFolderPath() + "/preference.plist"
    return fileName
  }
  
  // 判断APP是否第一次启动不需要, 后面换成别的
  fileprivate func _saveValueToDeviceBiliPreference(value: AnyObject?, forKey key: String) {
    assert(_isDevicePreference)
    
    _plistIOQueue.async {
      let fileName = self._deviceBiliPreferencePlistPath()
      if FileManager.default.fileExists(atPath: fileName) {
        if let dict = NSMutableDictionary(contentsOfFile: fileName) {
          dict.setValue(value, forKey: key)
          dict.write(toFile: fileName, atomically: false)
        }
      }
    }
  }
}

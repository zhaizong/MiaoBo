//
//  HomeLiveRoomBottomView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/2/1.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 直播间底部工具栏

// @since 1.0.0
// @author 赵林洋
enum ToolType: UInt {
  case publicTalk
  case privateTalk
  case gift
  case rank
  case share
  case close
}

class HomeLiveRoomBottomView: UIView {

  // MARK: - Property
  
  var bottomToolBarClosure: ((_ type: ToolType) -> Void)?
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension HomeLiveRoomBottomView {
  
  fileprivate func _setupApperance() {
    let _tools: [String] = ["talk_public_40x40_",
                            "talk_private_40x40_",
                            "talk_sendgift_40x40_",
                            "talk_rank_40x40_",
                            "talk_share_40x40_",
                            "talk_close_40x40_"]
    let wh: CGFloat = 40
    let margin: CGFloat = (PBK_Screen_Width - wh * CGFloat(_tools.count)) / CGFloat(_tools.count + 1)
    var x: CGFloat = 0
    let y: CGFloat = 0
    for index in 0..<_tools.count {
      x = margin + (margin + wh) * CGFloat(index)
      let toolView = UIImageView(image: UIImage(named: _tools[index]))
      toolView.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: wh, height: wh))
      toolView.isUserInteractionEnabled = true
      toolView.tag = index
      toolView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_toolViewDidClick(_:))))
      addSubview(toolView)
    }
  }
  
  @objc fileprivate func _toolViewDidClick(_ tap: UITapGestureRecognizer) {
    bottomToolBarClosure?(ToolType(rawValue: UInt(tap.view!.tag))!)
  }
  
}

//
//  HomeLiveRoomCatEarView.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/2/2.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 直播间, 同类型直播视图

// @since 1.0.0
// @author 赵林洋
class HomeLiveRoomCatEarView: UIView {

  // MARK: - Property
  
  var live: PBCHot? {
    didSet {
      guard let live = live else { return }
      _live = live
      // 设置只播放视频, 不播放声音
      // github详解: https://github.com/Bilibili/ijkplayer/issues/1491#issuecomment-226714613
      let option = IJKFFOptions()
      option.setPlayerOptionValue("1", forKey: "an")
//      开启硬解码
      option.setPlayerOptionValue("1", forKey: "videotoolbox")
      
      if let ijkPlayer = IJKFFMoviePlayerController(contentURLString: live.flv, with: option) {
        ijkPlayer.view.frame = _playView.bounds
        ijkPlayer.scalingMode = .aspectFill
//        设置自动播放
        ijkPlayer.shouldAutoplay = true
        
        _playView.addSubview(ijkPlayer.view)
        ijkPlayer.prepareToPlay()
        _ijkPlayer = ijkPlayer
      }
      
    }
  }
  fileprivate var _live: PBCHot!
  
  fileprivate var _playView: UIView
  fileprivate var _catEarImageView: UIImageView
  // 直播播放器
  fileprivate var _ijkPlayer: IJKFFMoviePlayerController?

  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _playView = UIView(frame: .zero)
    _catEarImageView = UIImageView(frame: .zero)
    super.init(frame: frame)
    
    _catEarImageView.image = UIImage(named: "public_catEar_98x25_")
    
    addSubview(_playView)
    addSubview(_catEarImageView)
    
    _playView.snp.makeConstraints { (make) in
      make.top.equalTo(snp.top)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
      make.bottom.equalTo(snp.bottom)
    }
    _catEarImageView.snp.makeConstraints { (make) in
      make.top.equalTo(snp.top)
      make.leading.equalTo(snp.leading)
      make.width.equalTo(98)
      make.height.equalTo(25)
    }
    
    _playView.layer.cornerRadius = _playView.frame.size.height * 0.5
    _playView.layer.masksToBounds = true
  }
  
  override func removeFromSuperview() {
    guard let _ = _ijkPlayer else {
      super.removeFromSuperview()
      return
    }
    _ijkPlayer?.shutdown()
    _ijkPlayer?.view.removeFromSuperview()
    _ijkPlayer = nil
    super.removeFromSuperview()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

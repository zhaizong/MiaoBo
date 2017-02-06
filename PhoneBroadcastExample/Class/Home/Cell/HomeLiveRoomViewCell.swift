//
//  HomeLiveRoomViewCell.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/31.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

class HomeLiveRoomViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  var closeClosure: (() -> Void)?
  
  // 直播数据源
  var live: AnyObject? {
    didSet {
      guard let live = live else { return }
      if live.isKind(of: PBCHot.self) {
        let hot = live as! PBCHot
        _topAnchorView.live = hot
        _playerFlv(hot.flv, placeholder: hot.bigpic)
      } else if live.isKind(of: PBCNewest.self) {
        let newest = live as! PBCNewest
        _topAnchorView.user = newest
        _playerFlv(newest.flv, placeholder: newest.photo)
      }
    }
  }
  // 相关的直播或者主播
//  var relateLive: Any?

//  gif 
  fileprivate var _gifImageView: UIImageView?
  
//  fileprivate var _timer: Timer?
//  直播播放器
  fileprivate var _ijkPlayer: IJKFFMoviePlayerController?
//  粒子动画
  fileprivate lazy var _emitterLayer: CAEmitterLayer? = { [weak self] in
    guard let weakSelf = self else { return nil }
    let lazilyCreatedEmitter = CAEmitterLayer()
    if let ijkPlayer = weakSelf._ijkPlayer {
//    发射器在xy平面的中心位置
      lazilyCreatedEmitter.emitterPosition = CGPoint(x: ijkPlayer.view.frame.size.width - 50,
                                                     y: ijkPlayer.view.frame.size.height - 50)
      ijkPlayer.view.layer.insertSublayer(lazilyCreatedEmitter, below: weakSelf._catEarView!.layer)
    }
//    发射器的尺寸大小
    lazilyCreatedEmitter.emitterSize = CGSize(width: 20, height: 20)
    var cells: [CAEmitterCell] = []
    // create emitter
    for index in 1...9 {
//      发射单元
      let stepCell = CAEmitterCell()
//      粒子的创建速率，默认为1/s
      stepCell.birthRate = 1
//      粒子存活时间
      stepCell.lifetime = Float(arc4random_uniform(4) + 1)
//      粒子的生存时间容差
      stepCell.lifetimeRange = 1.5
//      粒子显示的内容 good1_30x30_
      stepCell.contents = UIImage(named: "good\(index)_30x30_")?.cgImage
//      粒子的运动速度
      stepCell.velocity = CGFloat(arc4random_uniform(100) + 100)
//      粒子速度的容差
      stepCell.velocityRange = 80
//      粒子在xy平面的发射角度
      stepCell.emissionLongitude = CGFloat(M_PI + M_PI_2)
//      粒子发射角度的容差
      stepCell.emissionRange = CGFloat(M_PI_2 / 6)
//      缩放比例
      stepCell.scale = 0.3
      cells.append(stepCell)
    }
    lazilyCreatedEmitter.emitterCells = cells
    return lazilyCreatedEmitter
  }()
//  同一个工会的主播/相关主播
  fileprivate lazy var _otherImageView: UIImageView! = { [weak self] in
    guard let weakSelf = self else { return UIImageView(frame: .zero) }
    let lazilyCreatedOtherImageView = UIImageView(frame: .zero)
    lazilyCreatedOtherImageView.image = UIImage(named: "private_icon_70x70_")
    lazilyCreatedOtherImageView.isUserInteractionEnabled = true
    lazilyCreatedOtherImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_otherViewDidClick(_:))))
    if let ijkPlayer = weakSelf._ijkPlayer {
      ijkPlayer.view.addSubview(lazilyCreatedOtherImageView)
    }
    lazilyCreatedOtherImageView.snp.makeConstraints({ (make) in
      make.right.equalTo(weakSelf._catEarView!.snp.right)
      make.bottom.equalTo(weakSelf._catEarView!.snp.top).offset(-40)
    })
    return lazilyCreatedOtherImageView
  }()
//  同类型直播视图
  fileprivate lazy var _catEarView: HomeLiveRoomCatEarView? = { [weak self] in
    guard let weakSelf = self else { return HomeLiveRoomCatEarView(frame: .zero) }
    let lazilyCreatedCatEarView = HomeLiveRoomCatEarView(frame: .zero)
    lazilyCreatedCatEarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_catEarViewDidClick(_:))))
    if let ijkPlayer = weakSelf._ijkPlayer {
      ijkPlayer.view.addSubview(lazilyCreatedCatEarView)
      lazilyCreatedCatEarView.snp.makeConstraints({ (make) in
        make.right.equalTo(-30)
        make.centerY.equalTo(ijkPlayer.view.snp.centerY)
        make.size.equalTo(98)
      })
    }
    return lazilyCreatedCatEarView
  }()
//  直播开始前的占位图
  fileprivate var _placeholderImageView: UIImageView?
//  直播间顶部主播相关视图
  fileprivate var _topAnchorView: HomeLiveRoomTopAnchorView
//  底部的工具栏
  fileprivate var _bottomToolView: HomeLiveRoomBottomView
//  直播结束的界面
  fileprivate var _liveEndView: HomeLiveRoomEndView
  
  fileprivate var _isSelected: Bool = false
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _topAnchorView = HomeLiveRoomTopAnchorView(frame: .zero)
    _bottomToolView = HomeLiveRoomBottomView(frame: .zero)
    _liveEndView = HomeLiveRoomEndView(frame: .zero)
    super.init(frame: frame)
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension HomeLiveRoomViewCell {
  
  fileprivate func _setupApperance() {
    let placeholderImageView = UIImageView(image: UIImage(named: "profile_user_414x414"))
    placeholderImageView.frame = contentView.bounds
    placeholderImageView.contentMode = .scaleAspectFill
    _placeholderImageView = placeholderImageView
    
    _bottomToolView.bottomToolBarClosure = { [weak self] (type) in
      guard let weakSelf = self else { return }
      switch type {
      case .publicTalk:
        weakSelf._isSelected = !weakSelf._isSelected
      case .close:
        weakSelf._close()
      default:
        break
      }
    }
    
    _liveEndView.isHidden = true
    _liveEndView.closeClosure = { [weak self] in
      guard let weakSelf = self else { return }
      weakSelf._close()
    }
    
    contentView.addSubview(placeholderImageView)
    contentView.insertSubview(_topAnchorView, aboveSubview: placeholderImageView)
    contentView.insertSubview(_bottomToolView, aboveSubview: placeholderImageView)
    contentView.addSubview(_liveEndView)
  }
  
  fileprivate func _layoutSubviews() {
    _topAnchorView.snp.makeConstraints { (make) in
      make.left.equalTo(contentView.snp.left)
      make.right.equalTo(contentView.snp.right)
      make.top.equalTo(contentView.snp.top)
      make.height.equalTo(120)
    }
    
    _bottomToolView.snp.makeConstraints { (make) in
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
      make.bottom.equalTo(contentView.snp.bottom).offset(-10)
      make.height.equalTo(40)
    }
    
    _liveEndView.snp.makeConstraints { (make) in
      make.edges.equalTo(0)
    }
    
  }
  
  fileprivate func _setupObserver() {
    guard let ijkPlayer = _ijkPlayer else { return }
//    监听是否播放完成
    NotificationCenter.default.addObserver(self, selector: #selector(_didFinish), name: .IJKMPMoviePlayerPlaybackDidFinish, object: ijkPlayer)
//    当网络状态发生变化时
    NotificationCenter.default.addObserver(self, selector: #selector(_stateDidChange), name: .IJKMPMoviePlayerLoadStateDidChange, object: ijkPlayer)
  }
  
}

extension HomeLiveRoomViewCell {
  
  @objc fileprivate func _catEarViewDidClick(_ tap: UITapGestureRecognizer) {
    
  }
  
  @objc fileprivate func _otherViewDidClick(_ tap: UITapGestureRecognizer) {
    
  }
  
  fileprivate func _close() {
    if let _ = _ijkPlayer {
      _ijkPlayer?.shutdown()
      NotificationCenter.default.removeObserver(self)
    }
    closeClosure?()
  }
  
  @objc fileprivate func _didFinish() {
    guard let ijkPlayer = _ijkPlayer else { return }
    debugPrint("加载状态: \(ijkPlayer.loadState.rawValue), \(ijkPlayer.playbackState.rawValue)")
//    因为网速或者其他原因导致直播stop了, 也要显示GIF
    if ijkPlayer.loadState == .stalled  {
      showGifLoadingAnimate(nil, inView: ijkPlayer.view)
      return
    }
//    1、重新获取直播地址，服务端控制是否有地址返回。
//    2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    
  }
  
  @objc fileprivate func _stateDidChange() {
    guard let ijkPlayer = _ijkPlayer else { return }
    
    if ijkPlayer.loadState == [.playthroughOK, .playable]  {
      if ijkPlayer.isPlaying() == false {
        ijkPlayer.play()
        let dispatch_time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: dispatch_time, execute: { 
          if let _ = self._placeholderImageView {
            self._placeholderImageView?.removeFromSuperview()
            self._placeholderImageView = nil
//            [self.moviePlayer.view addSubview:_renderer.view];
          }
          self.hideGifLoadingAnimate()
        })
      } else {
//        如果是网络状态不好, 断开后恢复, 也需要去掉加载
        let dispatch_time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: dispatch_time, execute: {
          self.hideGifLoadingAnimate()
        })
      }
    } else if ijkPlayer.loadState == .stalled { // 网速不佳, 自动暂停状态
      showGifLoadingAnimate(nil, inView: ijkPlayer.view)
    }
  }
}

extension HomeLiveRoomViewCell {
  
  fileprivate func _playerFlv(_ flv: String, placeholder: String) {
    if let ijkPlayer = _ijkPlayer {
      if let _placeholderImageView = _placeholderImageView {
        contentView.insertSubview(_placeholderImageView, aboveSubview: ijkPlayer.view)
      }
      _catEarView?.removeFromSuperview()
      _catEarView = nil
      
      _ijkPlayer?.shutdown()
      _ijkPlayer?.view.removeFromSuperview()
      _ijkPlayer = nil
      NotificationCenter.default.removeObserver(self)
    }
//    如果切换主播, 取消之前的动画
    if let _ = _emitterLayer {
      _emitterLayer?.removeFromSuperlayer()
      _emitterLayer = nil
    }
 
    YYWebImageManager.shared().requestImage(with: URL(string: placeholder)!, options: .useNSURLCache, progress: nil, transform: nil) { (image, url, type, stage, error) in
      DispatchQueue.main.async {
        if let image = image {
          if let _placeholderImageView = self._placeholderImageView {
            self.showGifLoadingAnimate(nil, inView: _placeholderImageView)
//            _placeholderImageView.image = UIImage.blurImage(image, blur: 0.1)
            _placeholderImageView.image = image
          }
        }
      }
    }
 
    let options = IJKFFOptions()
    options.setPlayerOptionIntValue(1, forKey: "videotoolbox")
//    帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    options.setPlayerOptionIntValue(Int64(29.97), forKey: "r")
//    -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    options.setPlayerOptionIntValue(512, forKey: "vol")
    
    if let ijkPlayer = IJKFFMoviePlayerController(contentURLString: flv, with: options) {
      ijkPlayer.view.frame = contentView.bounds
//    填充fill
      ijkPlayer.scalingMode = .aspectFill
//    设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
      ijkPlayer.shouldAutoplay = false
//    默认不显示
      ijkPlayer.shouldShowHudView = false
      
      contentView.insertSubview(ijkPlayer.view, at: 0)
      ijkPlayer.prepareToPlay()
      
      _ijkPlayer = ijkPlayer
    }
//    设置监听
    _setupObserver()
//    显示工会其他主播和类似主播
//    _ijkPlayer?.view.bringSubview(toFront: _otherImageView)
//    开启来访动画
    _emitterLayer?.isHidden = false
  }
  
}

extension HomeLiveRoomViewCell {
  
  //  显示GIF加载动画
  func showGifLoadingAnimate(_ images: [UIImage]?, inView view: UIView) {
    let gifImageView = UIImageView(frame: .zero)
    view.addSubview(gifImageView)
    gifImageView.snp.makeConstraints { (make) in
      make.center.equalTo(view.snp.center)
      make.width.equalTo(60)
      make.height.equalTo(70)
    }
    _gifImageView = gifImageView
    
    if let images = images {
      if images.count != 0 {
        gifImageView.playGifAnimate(images)
      }
    } else {
      let images: [UIImage] = [UIImage(named: "hold1_60x72")!,
                               UIImage(named: "hold2_60x72")!,
                               UIImage(named: "hold3_60x72")!]
      gifImageView.playGifAnimate(images)
    }
  }
  
  //  取消GIF加载动画
  func hideGifLoadingAnimate() {
    _gifImageView?.stopGifAnimate()
    _gifImageView = nil
  }
}

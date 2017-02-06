//
//  PBKBannerView.swift
//  PhoneBroadcastKit
//
//  Created by Crazy on 2017/1/23.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 轮播图控件 UIScrollView 思路

// @since 1.0.0
// @author 赵林洋
fileprivate struct DefaultCommon {
  static let Time: TimeInterval = 2
}

public class PBKBannerView: UIView {

  // MARK: - Property
  
  public var imgStrings: [String]? {
    didSet {
      guard let imgStrings = imgStrings, imgStrings.count != 0 else { return }
      _images.removeAll(keepingCapacity: false)
      for index in 0..<imgStrings.count {
        _images.append(_placeholderImage)
        _downloadImage(index)
      }
      _pageControl.numberOfPages = imgStrings.count
      
      layoutSubviews()
    }
  }
  
  /**
   *  每一页停留时间，默认为5s，最少2s
   *  当设置的值小于2s时，则为默认值
   */
  public var time: TimeInterval = 5 {
    didSet {
      _startTimer()
    }
  }
  
  fileprivate var _images: [UIImage] = []
  fileprivate var _currIndex: Int = 0
  fileprivate var _nextIndex: Int = 0
  
  fileprivate var _timer: Timer?
  fileprivate var _currImageView: UIImageView!
  fileprivate var _otherImageView: UIImageView!
  
  fileprivate lazy var _pageControl: UIPageControl = {
    let lazilyCreatedPageControl = UIPageControl(frame: .zero)
    lazilyCreatedPageControl.isUserInteractionEnabled = false
    lazilyCreatedPageControl.hidesForSinglePage = true
    return lazilyCreatedPageControl
  }()
  fileprivate lazy var _scrollView: UIScrollView = { [weak self] in
    guard let weakSelf = self else { return UIScrollView() }
    let lazilyCreatedScrollView = UIScrollView(frame: .zero)
    lazilyCreatedScrollView.backgroundColor = PBK_Main_Background_Color
    lazilyCreatedScrollView.isPagingEnabled = true
    lazilyCreatedScrollView.showsHorizontalScrollIndicator = false
    lazilyCreatedScrollView.bounces = false
    lazilyCreatedScrollView.delegate = self
    weakSelf._currImageView = UIImageView(frame: .zero)
    weakSelf._otherImageView = UIImageView(frame: .zero)
    lazilyCreatedScrollView.addSubview(weakSelf._currImageView)
    lazilyCreatedScrollView.addSubview(weakSelf._otherImageView)
    return lazilyCreatedScrollView
    }()
  fileprivate lazy var _placeholderImage: UIImage = {
    let lazilyCreatedImage = UIImage.generateCenterImageWithBgColor(PBK_Main_Background_Color, bgImageSize: CGSize(width: PBK_Screen_Width, height: 100), centerImage: UIImage(named: "placeHolder_ad_414x100")!)
    return lazilyCreatedImage!
  }()
  fileprivate lazy var _queue: OperationQueue = {
    let lazilyCreatedOperationQueue = OperationQueue()
    return lazilyCreatedOperationQueue
  }()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    _setupApperance()
  }
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  public override func layoutSubviews() {
    super.layoutSubviews()
    _scrollView.frame = bounds
    _scrollView.contentInset = .zero
    _pageControl.frame.origin.y = bounds.size.height - bounds.origin.y
      
    _setupScrollViewSize()
  }
}

extension PBKBannerView {
  
  fileprivate func _startTimer() {
//    如果只有一张图片，则直接返回，不开启定时器
    guard _images.count > 0 else { return }
//    如果定时器已开启，先停止再重新开启
    if let _ = _timer {
      _stopTimer()
    }
    _timer = Timer(timeInterval: time < 2 ? DefaultCommon.Time : time, target: self, selector: #selector(_nextPage), userInfo: nil, repeats: true)
    RunLoop.current.add(_timer!, forMode: .commonModes)
  }
  
  fileprivate func _stopTimer() {
    _timer?.invalidate()
    _timer = nil
  }
  
  @objc fileprivate func _nextPage() {
    _scrollView.setContentOffset(CGPoint(x: _scrollView.frame.size.width * 3, y: 0), animated: true)
  }
  
}

extension PBKBannerView {
  
  fileprivate func _setupApperance() {
    backgroundColor = PBK_Main_Background_Color
    
    addSubview(_scrollView)
    addSubview(_pageControl)
  }
  
  fileprivate func _setupScrollViewSize() {
    if _images.count > 1 { // 图片大于一张
      _scrollView.contentSize = CGSize(width: _scrollView.frame.size.width * 5, height: 0)
      _scrollView.contentOffset = CGPoint(x: _scrollView.frame.size.width * 2, y: 0)
      _currImageView.frame = CGRect(origin: CGPoint(x: _scrollView.frame.size.width * 2, y: 0), size: _scrollView.frame.size)
    } else {
      _scrollView.contentSize = .zero
      _scrollView.contentOffset = .zero
      _currImageView.frame = CGRect(origin: .zero, size: _scrollView.frame.size)
    }
  }
  
  fileprivate func _downloadImage(_ index: Int) {
    let download = BlockOperation {
      do {
        if let url = URL(string: self.imgStrings![index]) {
          let data = try Data(contentsOf: url)
          if let image = UIImage(data: data) {
            self._images[index] = image
//            如果下载的图片为当前要显示的图片，直接到主线程给imageView赋值，否则要等到下一轮才会显示
            if self._currIndex == index {
              DispatchQueue.main.async {
                self._currImageView.image = image
              }
            }
          }
        }
      } catch {
        debugPrint(error)
      }
    }
    _queue.addOperation(download)
  }
  
}

extension PBKBannerView: UIScrollViewDelegate {
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !__CGSizeEqualToSize(.zero, scrollView.contentSize) else { return }
    
    let offsetX = scrollView.contentOffset.x
    //    滚动过程中改变pageControl的当前页码
    _changeCurrentPage(Offset: offsetX)
    //    向右滚动
    if offsetX < _scrollView.frame.size.width * 2 {
      _otherImageView.frame = CGRect(origin: CGPoint(x: _scrollView.frame.size.width, y: 0), size: _scrollView.frame.size)
      _nextIndex = _currIndex - 1
      if _nextIndex < 0 {
        _nextIndex = _images.count - 1
      }
      if offsetX <= _scrollView.frame.size.width {
        _changeToNext()
      }
    } else if offsetX > _scrollView.frame.size.width * 2 { // 向左滚动
      _otherImageView.frame = CGRect(origin: CGPoint(x: _currImageView.frame.maxX, y: 0), size: _scrollView.frame.size)
      _nextIndex = (_currIndex + 1) % _images.count
      if offsetX >= _scrollView.frame.size.width * 3 {
        _changeToNext()
      }
    }
    _otherImageView.image = _images[_nextIndex]
  }
  fileprivate func _changeCurrentPage(Offset offsetX: CGFloat) {
    if offsetX < _scrollView.frame.size.width * 1.5 {
      var index = _currIndex - 1
      if index < 0 {
        index = _images.count - 1
      }
      _pageControl.currentPage = index
    } else if offsetX > _scrollView.frame.size.width * 2.5 {
      _pageControl.currentPage = (_currIndex + 1) % _images.count
    } else {
      _pageControl.currentPage = _currIndex
    }
  }
  fileprivate func _changeToNext() {
    //    切换到下一张图片
    _currImageView.image = _otherImageView.image
    _scrollView.contentOffset = CGPoint(x: _scrollView.frame.size.width * 2, y: 0)
    _currIndex = _nextIndex
    _pageControl.currentPage = _currIndex
  }
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    _stopTimer()
  }
  
  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    _startTimer()
  }
  
}

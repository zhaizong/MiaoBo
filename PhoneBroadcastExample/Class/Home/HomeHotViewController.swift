//
//  HomeHotViewController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/30.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 热门

// @since 1.0.0
// @author 赵林洋
enum HotScrollDirection: Int {
  case none
  case up
  case down
}

fileprivate struct Common {
  static let BannerReuseIdentifier = "banner_header"
  static let HotCellReuseIdentifier = "hot_cell"
  static let ItemSizeHeight: CGFloat = 375
}

class HomeHotViewController: UIViewController, PBKStoryboardViewController {

  // MARK: - Property
  
  fileprivate var _currentPage: UInt = 0
  
  fileprivate var _banners: [PBCLiveBanner] = []
  fileprivate var _hots: [PBCHot] = []
  
  fileprivate var _hotCollectionView: UICollectionView!
  
  var offsetChangedClosure: ((_ offsetY: CGFloat, _ direction: HotScrollDirection) -> Void)?
  var hotScrollDirection: HotScrollDirection = .none
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    _setupApperance()
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "HomeHotViewController")
    return vc as! T
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard let change = change else { return }
    
    let newOffsetY = (change[.newKey] as! CGPoint).y
    let oldOffsetY = (change[.oldKey] as! CGPoint).y
    if newOffsetY > oldOffsetY {
      hotScrollDirection = .up
    } else if newOffsetY < oldOffsetY {
      hotScrollDirection = .down
    }
    offsetChangedClosure?(newOffsetY, hotScrollDirection)
  }
  
  deinit {
    _hotCollectionView.removeObserver(self, forKeyPath: "contentOffset")
  }
  
}

extension HomeHotViewController {
  
  fileprivate func _setupApperance() {
    view.backgroundColor = PBK_Main_Background_Color
    _currentPage = 1
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: PBK_Screen_Width, height: Common.ItemSizeHeight)
    layout.sectionInset = .zero
    _hotCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    _hotCollectionView.register(HomeBannerReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Common.BannerReuseIdentifier)
    _hotCollectionView.register(HomeHotViewCell.self, forCellWithReuseIdentifier: Common.HotCellReuseIdentifier)
    _hotCollectionView.backgroundColor = PBK_Main_Background_Color
    _hotCollectionView.showsVerticalScrollIndicator = false
    _hotCollectionView.dataSource = self
    _hotCollectionView.delegate = self
    view.addSubview(_hotCollectionView)
    _hotCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(view.snp.top)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.bottom.equalTo(view.snp.bottom)
    }
    
    _hotCollectionView.mj_header = HomeRefreshGifHeader {
      self._currentPage = 1
      self._hots.removeAll(keepingCapacity: false)
      self._setupHot()
      self._setupBanner()
    }
    /*
     * HomeRefreshAutoFooter 有点问题暂时不用
    _hotCollectionView.mj_footer = HomeRefreshAutoFooter {
      self._currentPage += 1
      self._setupHot()
    }
    */
    _hotCollectionView.mj_footer = MJRefreshAutoFooter {
      self._currentPage += 1
      self._setupHot()
    }
    _hotCollectionView.mj_header.beginRefreshing()
    
    _hotCollectionView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
  }
  
  fileprivate func _setupHot() {
    PBCHotManager.default().getHotByPage(_currentPage, success: { (hots) in
      self._hotCollectionView.mj_header.endRefreshing()
      self._hotCollectionView.mj_footer.endRefreshing()
      if hots.isEmpty {
        debugPrint("暂时没有更多最新数据")
        self._currentPage -= 1
      } else {
        hots.forEach {
          self._hots.append($0)
        }
        self._hotCollectionView.reloadData()
      }
    }) { (error) in
      debugPrint(error)
      self._hotCollectionView.mj_header.endRefreshing()
      self._hotCollectionView.mj_footer.endRefreshing()
      self._currentPage -= 1
    }
  }
  
  fileprivate func _setupBanner() {
    PBCLiveBannerManager.default().getLiveBannerSuccess({ (banners) in
      self._banners.removeAll(keepingCapacity: false)
      self._banners = banners
      self._hotCollectionView.reloadData()
    }) { (error) in
      // ignore
    }
  }
  
}

extension HomeHotViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  
  // MARK: UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return _hots.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.HotCellReuseIdentifier, for: indexPath) as! HomeHotViewCell
    cell.hots = _hots[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Common.BannerReuseIdentifier, for: indexPath) as! HomeBannerReusableView
      var strs: [String] = []
      _banners.forEach {
        strs.append($0.imageUrl)
      }
      view.imgString = strs
      return view
    }
    return UICollectionReusableView(frame: .zero)
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: PBK_Screen_Width, height: Common.ItemSizeHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: PBK_Screen_Width, height: 100)
  }
  
  // MARK: UICollectionViewDelegate
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    
    let liveRoomVC: HomeLiveRoomCollectionViewController = HomeLiveRoomCollectionViewController.instanceFromStoryboard()
    liveRoomVC.lives = _hots
    liveRoomVC.currentIndex = indexPath.item
    present(liveRoomVC, animated: true, completion: nil)
  }
  
}

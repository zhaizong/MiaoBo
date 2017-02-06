//
//  HomeHotViewController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/25.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 热门 UICollectionViewController版，暂时不用

// @since 1.0.0
// @author 赵林洋
fileprivate struct Common {
  static let BannerCellReuseIdentifier = "banner_cell"
  static let HotCellReuseIdentifier = "hot_cell"
}

class HomeHotCollectionViewController: UICollectionViewController, PBKStoryboardViewController {

  // MARK: - Property
  
  fileprivate var _currentPage: Int = 0
  
  fileprivate var _banners: [PBCLiveBanner] = []
  fileprivate var _hots: [PBCLiveHot] = []
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: PBK_Screen_Width, height: 445)
    layout.sectionInset = .zero
    collectionView!.collectionViewLayout = layout
    collectionView!.backgroundColor = PBK_Main_Background_Color
    collectionView!.showsVerticalScrollIndicator = false
    
    // Register cell classes
    self.collectionView!.register(HomeBannerViewCell.self, forCellWithReuseIdentifier: Common.BannerCellReuseIdentifier)
    self.collectionView!.register(HomeHotViewCell.self, forCellWithReuseIdentifier: Common.HotCellReuseIdentifier)

    // Do any additional setup after loading the view.
    _setupApperance()
  }
  fileprivate func _setupApperance() {
    _currentPage = 1
    collectionView?.mj_header = HomeRefreshGifHeader(refreshingBlock: {
      self._currentPage = 1
      self._setupHots()
    })
    collectionView?.mj_footer = HomeRefreshAutoFooter(refreshingBlock: { 
      self._currentPage += 1
      self._setupHots()
    })
    collectionView?.mj_header.beginRefreshing()
  }
  
  fileprivate func _setupHots() {
    PBCLiveHotManager.default().getLiveHot(byPage: UInt(_currentPage), success: { (hots: [PBCLiveHot]) in
      self.collectionView?.mj_header.endRefreshing()
      self.collectionView?.mj_footer.endRefreshing()
      self._hots.removeAll(keepingCapacity: false)
      self._hots = hots
      self.collectionView?.reloadData()
    }) { (error) in
      self.collectionView?.mj_header.endRefreshing()
      self.collectionView?.mj_footer.endRefreshing()
      self._currentPage -= 1
    }
  }
  fileprivate func _setupBanners() {
    PBCLiveBannerManager.default().getLiveBannerSuccess({ (banners: [PBCLiveBanner]) in
      self._banners.removeAll(keepingCapacity: false)
      self._banners = banners;
      self.collectionView?.reloadData()
    }) { (error) in
      // ignore
    }
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "HomeHotCollectionViewController")
    return vc as! T
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension HomeHotCollectionViewController: UICollectionViewDelegateFlowLayout {
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return _hots.count + 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.BannerCellReuseIdentifier, for: indexPath) as! HomeBannerViewCell
      
      var strs: [String] = []
      _banners.forEach {
        strs.append($0.imageUrl)
      }
      cell.imgString = strs
      
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.HotCellReuseIdentifier, for: indexPath) as! HomeHotViewCell
    
    // Configure the cell
    cell.hots = _hots[indexPath.item - 1]
    
    return cell
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if indexPath.item == 0 {
      return CGSize(width: view.frame.size.width, height: 100)
    }
    return CGSize(width: view.frame.size.width, height: 445)
  }
  
  // MARK: UICollectionViewDelegate
  
  /*
   // Uncomment this method to specify if the specified item should be highlighted during tracking
   override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment this method to specify if the specified item should be selected
   override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
   return true
   }
   */
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
}

//
//  HomeNewCollectionViewController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/30.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 最新

// @since 1.0.0
// @author 赵林洋
fileprivate struct Common {
  static let NewCellReuseIdentifier = "newest_cell"
}

class HomeNewestCollectionViewController: UICollectionViewController, PBKStoryboardViewController {

  // MARK: - Property
  
  fileprivate var _currentPage: UInt = 0
  
  fileprivate var _anchors: [PBCNewest] = []
  
  fileprivate var _timer: Timer?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Register cell classes
    self.collectionView!.register(HomeNewestViewCell.self, forCellWithReuseIdentifier: Common.NewCellReuseIdentifier)

    // Do any additional setup after loading the view.
    _setupApperance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    首先自动刷新一次
    _autoRefresh()
//    然后开启每一分钟自动更新
    _timer = Timer(timeInterval: 60, target: self, selector: #selector(_autoRefresh), userInfo: nil, repeats: true)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    _timer?.invalidate()
    _timer = nil
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "HomeNewestCollectionViewController")
    return vc as! T
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension HomeNewestCollectionViewController {
  
  @objc fileprivate func _autoRefresh() {
    collectionView?.mj_header.beginRefreshing()
  }
  
}

extension HomeNewestCollectionViewController {
  
  fileprivate func _setupApperance() {
    _currentPage = 1
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 1
    layout.minimumInteritemSpacing = 1
    layout.itemSize = CGSize(width: (PBK_Screen_Width - 3) / 3, height: (PBK_Screen_Width - 3) / 3)
    collectionView?.collectionViewLayout = layout
    collectionView?.backgroundColor = PBK_Main_Background_Color
    collectionView?.showsVerticalScrollIndicator = false
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.alwaysBounceVertical = true
    collectionView?.mj_header = HomeRefreshGifHeader {
      self._currentPage = 1
      self._anchors.removeAll(keepingCapacity: false)
      self._setupDataSource()
    }
    collectionView?.mj_footer = HomeRefreshAutoFooter {
      self._currentPage += 1
      self._setupDataSource()
    }
    collectionView?.mj_header.beginRefreshing()
  }
  
  fileprivate func _setupDataSource() {
    PBCNewestManager.default().getNewestByPage(_currentPage, success: { (newests) in
      self.collectionView?.mj_header.endRefreshing()
      self.collectionView?.mj_footer.endRefreshing()
      if newests[0].msg == "success" {
        newests.forEach {
          self._anchors.append($0)
        }
        self.collectionView?.reloadData()
      } else {
        self.collectionView?.mj_footer.endRefreshingWithNoMoreData()
        self._currentPage -= 1
      }
    }) { (error) in
      self.collectionView?.mj_header.endRefreshing()
      self.collectionView?.mj_footer.endRefreshing()
      self._currentPage -= 1
    }
  }
  
}

extension HomeNewestCollectionViewController {
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return _anchors.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.NewCellReuseIdentifier, for: indexPath) as! HomeNewestViewCell
    
    // Configure the cell
    cell.newest = _anchors[indexPath.item]
    
    return cell
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

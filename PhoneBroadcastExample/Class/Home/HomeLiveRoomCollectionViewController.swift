//
//  HomeLiveRoomCollectionViewController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/31.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// Home tap 中的直播间页面

// @since 1.0.0
// @author 赵林洋
private let reuseIdentifier = "live_room_cell"

fileprivate struct Common {
  
}

class HomeLiveRoomCollectionViewController: UICollectionViewController, PBKStoryboardViewController {

  // MARK: - Property
  
  // 直播间数据源
  var lives: [AnyObject] = []
  // 当前的index
  var currentIndex: Int = 0
  
  fileprivate var _timer: Timer?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Do any additional setup after loading the view.
    _setupApperance()
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "HomeLiveRoomCollectionViewController")
    return vc as! T 
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

extension HomeLiveRoomCollectionViewController {
  
  fileprivate func _setupApperance() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .vertical
    layout.itemSize = collectionView!.bounds.size
    
    // Register cell classes
    collectionView?.register(HomeLiveRoomViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    collectionView?.collectionViewLayout = layout
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.showsVerticalScrollIndicator = false
    collectionView?.backgroundColor = PBK_Main_Background_Color
    let header = HomeRefreshGifHeader {
      self.collectionView?.mj_header.endRefreshing()
      self.currentIndex += 1
      if self.currentIndex == self.lives.count {
        self.currentIndex = 0
      }
      self.collectionView?.reloadData()
    }
    header?.stateLabel.isHidden = false
    header?.setTitle("下拉切换另一个主播", for: .pulling)
    header?.setTitle("下拉切换另一个主播", for: .idle)
    collectionView?.mj_header = header
    
    // TODO: - notification
  }
  
}

extension HomeLiveRoomCollectionViewController {
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeLiveRoomViewCell
    cell.closeClosure = { [weak self] in
      guard let weakSelf = self else { return }
      weakSelf.dismiss(animated: true, completion: nil)
    }
    
    // Configure the cell
    cell.live = lives[currentIndex]
    var relateIndex = currentIndex
    if currentIndex + 1 == lives.count {
      relateIndex = 0
    } else {
      relateIndex += 1
    }
    // TODO: - setup 相关主播
    
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

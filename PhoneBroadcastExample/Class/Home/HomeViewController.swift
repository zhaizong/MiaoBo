//
//  HomeViewController.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/24.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

// 首页根视图

// @since 1.0.0
// @author 赵林洋
class HomeViewController: UIViewController, PBKStoryboardViewController {

  // MARK: - Property
  
  fileprivate let _titleScrollViewHeight: CGFloat = 44
  
  fileprivate var _topSelectedView: HomeTopSelectedView!
  
  fileprivate var _titleScrollView: HomeTitleScrollView!
  
  fileprivate var _homeCollectionView: UICollectionView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    _setupApperance()
  }
  
  static func instanceFromStoryboard<T>() -> T {
    let vc = UIStoryboard.homeStoryboard().instantiateViewController(withIdentifier: "HomeViewController")
    return vc as! T
  }

}

extension HomeViewController {
  
  fileprivate func _setupApperance() {
    UIApplication.shared.statusBarStyle = .lightContent
    view.backgroundColor = PBK_Main_Background_Color
    
//    debugPrint(PBK_Screen_Height)
//    debugPrint(tabBarController!.tabBar.frame.origin.y)
//    debugPrint(tabBarController!.tabBar.frame.size.height)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_15x14"), style: .done, target: self, action: nil)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "head_crown_24x24"), style: .done, target: self, action: nil)
    
    _topSelectedView = HomeTopSelectedView(frame: navigationController!.navigationBar.bounds)
    _topSelectedView.frame.origin = CGPoint(x: 45, y: _topSelectedView.frame.origin.y)
    _topSelectedView.frame.size = CGSize(width: PBK_Screen_Width - 45 * 2, height: _topSelectedView.frame.size.height)
    navigationController?.navigationBar.addSubview(_topSelectedView)
    
    let titleScrollViewFrame = CGRect(origin: CGPoint(x: 0, y: 64), size: CGSize(width: PBK_Screen_Width, height: 44))
    _titleScrollView = HomeTitleScrollView(frame: titleScrollViewFrame)
    view.addSubview(_titleScrollView)
    _titleScrollView.buttonDidClickClosure = { [weak self] (selectedType) in
      guard let weakSelf = self else { return }
      weakSelf._homeCollectionView.scrollToItem(at: IndexPath(item: Int(selectedType.rawValue), section: 0), at: .right, animated: true)
    }
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    layout.itemSize = UIScreen.main.bounds.size
    layout.sectionInset = .zero
    let homeframe = CGRect(origin: CGPoint(x: 0, y: 64 + _titleScrollViewHeight), size: CGSize(width: PBK_Screen_Width, height: PBK_Screen_Height))
    _homeCollectionView = UICollectionView(frame: homeframe, collectionViewLayout: layout)
    _homeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    _homeCollectionView.backgroundColor = PBK_Main_Background_Color
    _homeCollectionView.showsHorizontalScrollIndicator = false
    _homeCollectionView.isPagingEnabled = true
    _homeCollectionView.bounces = false
    _homeCollectionView.dataSource = self
    _homeCollectionView.delegate = self
    view.addSubview(_homeCollectionView)
    
    _setupChildViewController()
  }
  
  fileprivate func _setupChildViewController() {
    let hotViewController: HomeHotViewController = HomeHotViewController.instanceFromStoryboard()
    addChildViewController(hotViewController)
    /*hotViewController.offsetChangedClosure = { [weak self] (offsetY: CGFloat, direction: HotScrollDirection) in
      guard let weakSelf = self else { return }
      guard offsetY > 0 else { return }
      if direction == .up { // 向上滑动，隐藏
        if weakSelf.tabBarController!.tabBar.frame.origin.y < PBK_Screen_Height {
          weakSelf.tabBarController?.tabBar.frame.origin.y += 1
        }
      } else if direction == .down { // 向下滑动，显示
        if weakSelf.tabBarController!.tabBar.frame.origin.y > PBK_Screen_Height - 49 {
          weakSelf.tabBarController?.tabBar.frame.origin.y -= 1
        }
      }
    }
    */
    let newViewController: HomeNewestCollectionViewController = HomeNewestCollectionViewController.instanceFromStoryboard()
    addChildViewController(newViewController)
  }
  
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return childViewControllers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//    移除之前的子控件
    cell.contentView.subviews.forEach {
      $0.removeFromSuperview()
    }
//    添加控制器
    let vc = childViewControllers[indexPath.item]
    vc.view.frame = CGRect(origin: .zero, size: _homeCollectionView.frame.size)
    cell.contentView.addSubview(vc.view)
    return cell
  }
  
  // MARK: - UICollectionViewDelegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard _titleScrollView.isClickButton == false else { return }
    let page = scrollView.contentOffset.x / PBK_Screen_Width
    let offsetX = scrollView.contentOffset.x / PBK_Screen_Width * 60
    _titleScrollView.underLine.frame.origin.x = offsetX

    _titleScrollView.selectedType = HomeType(rawValue: UInt(page + 0.5))
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    _titleScrollView.isClickButton = false
  }
  
}

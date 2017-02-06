//
//  HomeRefreshGifHeader.swift
//  PhoneBroadcastExample
//
//  Created by Crazy on 2017/1/27.
//  Copyright © 2017年 Crazy. All rights reserved.
//

import UIKit

class HomeRefreshGifHeader: MJRefreshGifHeader {

  override init(frame: CGRect) {
    super.init(frame: frame)
    lastUpdatedTimeLabel.isHidden = true
    stateLabel.isHidden = true
    setImages([UIImage(named: "reflesh1_60x55")!, UIImage(named: "reflesh2_60x55")!, UIImage(named: "reflesh3_60x55")!], for: .refreshing)
    setImages([UIImage(named: "reflesh1_60x55")!, UIImage(named: "reflesh2_60x55")!, UIImage(named: "reflesh3_60x55")!], for: .pulling)
    setImages([UIImage(named: "reflesh1_60x55")!, UIImage(named: "reflesh2_60x55")!, UIImage(named: "reflesh3_60x55")!], for: .idle)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

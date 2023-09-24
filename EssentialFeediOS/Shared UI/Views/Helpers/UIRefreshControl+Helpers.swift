//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Silverius Daniel Wijono on 15/07/23.
//

import UIKit

extension UIRefreshControl {
  func update(isRefreshing: Bool) {
    isRefreshing ? beginRefreshing() : endRefreshing()
  }
}

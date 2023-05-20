//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Silverius Daniel Wijono on 11/04/23.
//

import UIKit
import EssentialFeed

protocol FeedRefreshViewControllerDelegate {
  func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
  @IBOutlet private var view: UIRefreshControl?
  
  var delegate: FeedRefreshViewControllerDelegate?
  
  @IBAction func refresh() {
    delegate?.didRequestFeedRefresh()
  }
  
  func display(_ viewModel: FeedLoadingViewModel) {
    if viewModel.isLoading {
      view?.beginRefreshing()
    } else {
      view?.endRefreshing()
    }
  }
}

//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Silverius Daniel Wijono on 28/02/23.
//

import UIKit

final public class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
  private var refreshController: FeedRefreshViewController?
  private var imageLoader: FeedImageDataLoader?
  var tableModel = [FeedImageCellController]() {
    didSet { tableView.reloadData() }
  }
  private var cellControllers = [IndexPath: FeedImageCellController]()
  
  convenience init(refreshController: FeedRefreshViewController) {
    self.init()
    self.refreshController = refreshController
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = refreshController?.view
    tableView.prefetchDataSource = self
    refreshController?.refresh()
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableModel.count
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return cellController(forRowAt: indexPath).view()
  }
  
  public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cancelCellController(forRowAt: indexPath)
  }
  
  public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach { indexPath in
      cellController(forRowAt: indexPath).preload()
    }
  }
  
  public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach(cancelCellController)
  }
  
  private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
    return tableModel[indexPath.row]
  }
  
  private func cancelCellController(forRowAt indexPath: IndexPath) {
    cellController(forRowAt: indexPath).cancelLoad()
  }
  
}

//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 29/09/22.
//

import Foundation

public enum LoadFeedResult {
  case success([FeedImage])
  case failure(Error)
}

public protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}

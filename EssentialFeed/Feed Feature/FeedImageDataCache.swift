//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 29/08/23.
//

import Foundation

public protocol FeedImageDataCache {
  typealias Result = Swift.Result<Void, Error>
  
  func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

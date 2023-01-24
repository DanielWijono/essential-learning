//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 29/09/22.
//

import Foundation

public protocol FeedLoader {
  typealias Result = Swift.Result<[FeedImage], Error>
  
  func load(completion: @escaping (Result) -> Void)
}

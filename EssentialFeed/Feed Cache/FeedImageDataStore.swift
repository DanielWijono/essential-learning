//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 01/08/23.
//

import Foundation

public protocol FeedImageDataStore {
  typealias Result = Swift.Result<Data?, Error>

  func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}

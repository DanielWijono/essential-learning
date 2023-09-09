//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 01/10/22.
//

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
  convenience init(url: URL, client: HTTPClient) {
    self.init(url: url, client: client, mapper: FeedItemsMapper.map)
  }
}



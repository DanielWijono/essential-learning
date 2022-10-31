//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 31/10/22.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
  internal let id: UUID
  internal let description: String?
  internal let location: String?
  internal let image: URL
}

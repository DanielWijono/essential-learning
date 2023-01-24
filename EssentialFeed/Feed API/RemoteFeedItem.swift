//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 31/10/22.
//

import Foundation

struct RemoteFeedItem: Decodable {
  let id: UUID
  let description: String?
  let location: String?
  let image: URL
}

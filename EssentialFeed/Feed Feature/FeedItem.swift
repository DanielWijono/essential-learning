//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 29/09/22.
//

import Foundation

public struct FeedItem: Equatable {
  let id: UUID
  let description: String?
  let location: String?
  let imageURL: URL
}

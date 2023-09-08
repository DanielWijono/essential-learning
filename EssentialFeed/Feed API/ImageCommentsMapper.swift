//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 08/09/23.
//

import Foundation

final class ImageCommentsMapper {
  private struct Root: Decodable {
    let items: [RemoteFeedItem]
  }
  
  static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
    guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw RemoteImageCommentsLoader.Error.invalidData
    }
    
    return root.items
  }
}

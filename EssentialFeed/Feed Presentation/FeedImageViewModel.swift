//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 16/07/23.
//

import Foundation

public struct FeedImageViewModel {
  public let description: String?
  public let location: String?
  
  public var hasLocation: Bool {
    return location != nil
  }
}

//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 15/07/23.
//

public struct FeedErrorViewModel {
  public let message: String?
  
  static var noError: FeedErrorViewModel {
    return FeedErrorViewModel(message: nil)
  }
  
  static func error(message: String) -> FeedErrorViewModel {
    return FeedErrorViewModel(message: message)
  }
}

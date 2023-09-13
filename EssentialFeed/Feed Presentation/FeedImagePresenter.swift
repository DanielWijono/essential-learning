//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 16/07/23.
//

import Foundation

public final class FeedImagePresenter {
  
  public static func map(_ image: FeedImage) -> FeedImageViewModel {
    FeedImageViewModel(
      description: image.description,
      location: image.location)
  }
}

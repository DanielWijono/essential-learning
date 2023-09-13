//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Silverius Daniel Wijono on 14/09/23.
//

import Foundation

public struct ResourceErrorViewModel {
  public let message: String?
  
  static var noError: ResourceErrorViewModel {
    return ResourceErrorViewModel(message: nil)
  }
  
  static func error(message: String) -> ResourceErrorViewModel {
    return ResourceErrorViewModel(message: message)
  }
}

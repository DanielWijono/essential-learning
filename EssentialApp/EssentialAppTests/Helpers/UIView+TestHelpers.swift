//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Silverius Daniel Wijono on 31/08/23.
//

import UIKit

extension UIView {
  func enforceLayoutCycle() {
    layoutIfNeeded()
    RunLoop.current.run(until: Date())
  }
}

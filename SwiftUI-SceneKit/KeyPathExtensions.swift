//
//  KeyPathExtensions.swift
//  SwiftUI-SceneKit
//
//  Created by ryohey on 2020/05/30.
//  Copyright © 2020 ryohey. All rights reserved.
//

import Foundation

extension KeyPath where Root: NSObject {
    var string: String {
        NSExpression(forKeyPath: self).keyPath
    }
}

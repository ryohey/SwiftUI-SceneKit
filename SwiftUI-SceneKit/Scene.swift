//
//  Scene.swift
//  SwiftUI-SceneKit
//
//  Created by ryohey on 2020/05/30.
//  Copyright © 2020 ryohey. All rights reserved.
//

import SceneKit

protocol SceneProtocol {
    var scene: SCNScene { get }
}

struct Scene: SceneProtocol {
    let scene: SCNScene

    init(@NodeBuilder content: () -> Node) {
        scene = SCNScene()
        scene.rootNode.addChildNode(content().scnNode)
    }
}

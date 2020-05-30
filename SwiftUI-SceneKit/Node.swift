//
//  Node.swift
//  SwiftUI-SceneKit
//
//  Created by ryohey on 2020/05/30.
//  Copyright © 2020 ryohey. All rights reserved.
//

import SceneKit

struct Node: NodeProtocol {
    typealias Body = Never
    var body: Body { fatalError() }
    let scnNode: SCNNode

    init(scnNode: SCNNode) {
        self.scnNode = scnNode
    }

    init(childNodes: [SCNNode]) {
        scnNode = SCNNode()
        childNodes.forEach(scnNode.addChildNode)
    }

    init(configure: ((SCNNode) -> Void)? = nil) {
        let node = SCNNode()
        configure?(node)
        scnNode = node
    }
}

extension NodeProtocol {
    func geometry(_ geometry: SCNGeometry?) -> Self {
        getNode().scnNode.geometry = geometry
        return self
    }

    func light(_ light: SCNLight?) -> Self {
        getNode().scnNode.light = light
        return self
    }

    func camera(_ camera: SCNCamera?) -> Self {
        getNode().scnNode.camera = camera
        return self
    }

    func position(_ position: SCNVector3) -> Self {
        getNode().scnNode.position = position
        return self
    }
}

extension Never: NodeProtocol {

}

@_functionBuilder struct NodeBuilder {
    static func buildBlock(_ content: Node) -> Node {
        content
    }

    static func buildBlock<C0>(_ c0: C0) -> Node where C0: NodeProtocol {
        return Node { node in
            node.addChildNode(c0.getNode().scnNode)
        }
    }

    static func buildBlock<C0, C1>(
        _ c0: C0,
        _ c1: C1
    ) -> Node where
        C0: NodeProtocol,
        C1: NodeProtocol {
            return Node(childNodes: [
                c0.getNode().scnNode,
                c1.getNode().scnNode,
            ])
    }

    static func buildBlock<C0, C1, C2>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2
    ) -> Node where
        C0: NodeProtocol,
        C1: NodeProtocol,
        C2: NodeProtocol {
            return Node(childNodes: [
                c0.getNode().scnNode,
                c1.getNode().scnNode,
                c2.getNode().scnNode,
            ])
    }

    static func buildBlock<C0, C1, C2, C3>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) -> Node where
        C0: NodeProtocol,
        C1: NodeProtocol,
        C2: NodeProtocol,
        C3: NodeProtocol {
            return Node(childNodes: [
                c0.getNode().scnNode,
                c1.getNode().scnNode,
                c2.getNode().scnNode,
                c3.getNode().scnNode,
            ])
    }
}

extension NodeProtocol {
    func getNode() -> Node {
        if let node = self as? Node {
            return node
        } else {
            return body.getNode()
        }
    }
}

protocol NodeProtocol {
    associatedtype Body: NodeProtocol
    var body: Self.Body { get }
}

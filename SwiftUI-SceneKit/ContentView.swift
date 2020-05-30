//
//  ContentView.swift
//  SwiftUI-SceneKit
//
//  Created by ryohey on 2020/05/30.
//  Copyright © 2020 ryohey. All rights reserved.
//

import SwiftUI
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

@_functionBuilder struct SceneBuilder {
    static func buildBlock<Content>(_ content: Content) -> Content where Content : SceneProtocol {
        content
    }
}

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

struct SceneView: UIViewRepresentable {
    typealias UIViewType = SCNView
    let content: SceneProtocol

    init(@SceneBuilder content: () -> SceneProtocol) {
        self.content = content()
    }

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        view.scene = content.scene
        view.allowsCameraControl = true
        view.showsStatistics = true
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
    }
}

protocol NodeProtocol {
    associatedtype Body: NodeProtocol
    var body: Self.Body { get }
}

struct Camera: NodeProtocol {
    var body: some NodeProtocol {
        Node()
            .camera(SCNCamera())
            .position(SCNVector3(x:0, y:0, z:5))
    }
}

struct OmniLight: NodeProtocol {
    var body: some NodeProtocol {
        Node()
            .light(light)
            .position(SCNVector3(x:0, y:10, z:10))
    }

    private let light = SCNLight()

    init() {
        light.type = .omni
    }
}

struct AmbientLight: NodeProtocol {
    var body: some NodeProtocol {
        Node()
            .light(light)
    }

    private let light = SCNLight()

    init() {
        light.type = .ambient
        light.color = UIColor.darkGray
    }
}

struct Box: NodeProtocol {
    var body: some NodeProtocol {
        Node { $0.addAnimation(self.animation, forKey: nil) }
            .geometry(geometry)
    }

    private let animation = CABasicAnimation(keyPath: (\SCNNode.rotation).string)
    private let geometry = SCNBox(width:1, height:1, length:1, chamferRadius:0.02)

    init() {
        // create and configure a material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.specular.contents = UIColor.gray
        material.locksAmbientWithDiffuse = true

        // set the material to the 3D object geometry
        geometry.firstMaterial = material

        animation.toValue = NSValue(scnVector4:SCNVector4(x:1, y:1, z:0, w:Float.pi * 2))
        animation.duration = 5
        animation.repeatCount = MAXFLOAT // repeat forever
    }
}

extension KeyPath where Root: NSObject {
    var string: String {
        NSExpression(forKeyPath: self).keyPath
    }
}

struct ContentView: View {
    var body: some View {
        SceneView {
            Scene {
                Camera()
                    .position(SCNVector3(x:0, y:0, z:5))
                OmniLight()
                AmbientLight()
                Box()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

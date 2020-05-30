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

    init(configure: ((SCNNode) -> Void)? = nil) {
        let node = SCNNode()
        configure?(node)
        scnNode = node
    }

    func geometry(_ geometry: SCNGeometry?) -> Self {
        scnNode.geometry = geometry
        return self
    }

    func light(_ light: SCNLight?) -> Self {
        scnNode.light = light
        return self
    }

    func camera(_ camera: SCNCamera?) -> Self {
        scnNode.camera = camera
        return self
    }

    func position(_ position: SCNVector3) -> Self {
        scnNode.position = position
        return self
    }
}

extension Never: NodeProtocol {

}

@_functionBuilder struct SCNNodeBuilder {
    static func buildBlock<Content>(_ content: Content) -> Content where Content : SCNNode {
        content
    }
}

@_functionBuilder struct NodeBuilder {
    static func buildBlock(_ content: Node) -> Node {
        content
    }

    static func buildBlock(_ contents: Node...) -> Node {
        return Node { node in
            contents.forEach { node.addChildNode($0.scnNode) }
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

struct AmbientLight: NodeProtocol {
    let light = SCNLight()

    var body: some NodeProtocol {
        Node()
            .light(light)
    }

    init() {
        light.type = .ambient
        light.color = UIColor.darkGray
    }
}

struct ContentView: View {
    var body: some View {
        SceneView {
            Scene {
                Node()
                    .camera(SCNCamera())
                    .position(SCNVector3(x:0, y:0, z:5))

                Node()
                    .light({
                        let light = SCNLight()
                        light.type = .omni
                        return light
                        }())
                    .position(SCNVector3(x:0, y:10, z:10))


                // create and add a 3D box to the scene
                Node { node in
                    // animate the 3D object
                    let animation:CABasicAnimation = CABasicAnimation(keyPath:"rotation")
                    animation.toValue = NSValue(scnVector4:SCNVector4(x:1, y:1, z:0, w:Float.pi * 2))
                    animation.duration = 5
                    animation.repeatCount = MAXFLOAT // repeat forever
                    node.addAnimation(animation, forKey:nil)
                }
                .geometry({
                    let geometry = SCNBox(width:1, height:1, length:1, chamferRadius:0.02)

                    // create and configure a material
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor.green
                    material.specular.contents = UIColor.gray
                    material.locksAmbientWithDiffuse = true

                    // set the material to the 3D object geometry
                    geometry.firstMaterial = material

                    return geometry
                    }())
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

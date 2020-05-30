//
//  ContentView.swift
//  SwiftUI-SceneKit
//
//  Created by ryohey on 2020/05/30.
//  Copyright © 2020 ryohey. All rights reserved.
//

import SwiftUI
import SceneKit

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
    private let geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.02)

    init() {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        material.specular.contents = UIColor.gray
        material.locksAmbientWithDiffuse = true
        geometry.firstMaterial = material

        animation.toValue = NSValue(scnVector4:SCNVector4(x: 1, y: 1, z: 0, w: Float.pi * 2))
        animation.duration = 5
        animation.repeatCount = MAXFLOAT
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

//
//  SceneView.swift
//  SwiftUI-SceneKit
//
//  Created by ryohey on 2020/05/30.
//  Copyright © 2020 ryohey. All rights reserved.
//

import UIKit
import SwiftUI
import SceneKit

@_functionBuilder struct SceneBuilder {
    static func buildBlock<Content>(_ content: Content) -> Content where Content : SceneProtocol {
        content
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

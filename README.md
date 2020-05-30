# SwiftUI-SceneKit

Experimental Declarative Style SceneKit for SwiftUI

![Screenshot](https://user-images.githubusercontent.com/5355966/83318906-2e9a6d80-a274-11ea-8e1d-ac42f8286faa.png)

## Example

```swift
struct ContentView: View {
    var body: some View {
        SceneView {
            Scene {
                Camera()
                    .position(SCNVector3(x: 0, y: 0, z: 5))
                OmniLight()
                AmbientLight()
                Box()
            }
        }
    }
}

struct Camera: NodeProtocol {
    var body: some NodeProtocol {
        Node()
            .camera(SCNCamera())
            .position(SCNVector3(x: 0, y: 0, z: 5))
    }
}

struct OmniLight: NodeProtocol {
    var body: some NodeProtocol {
        Node()
            .light(light)
            .position(SCNVector3(x: 0, y: 10, z: 10))
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
```

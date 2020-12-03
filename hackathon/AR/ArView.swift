//
//  ContentView.swift
//  test
//
//  Created by Timo Blattner on 21.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//
//https://heartbeat.fritz.ai/introduction-to-realitykit-on-ios-entities-gestures-and-ray-casting-8f6633c11877

import SwiftUI
import RealityKit
import ARKit

struct ArView : View {
    var painting: Painting
    
    var body: some View {
        return ARViewContainer(painting: painting).edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    var painting: Painting
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        //create painting
        var material = SimpleMaterial()
        material.baseColor = try! .texture(.load(named: painting.imageName))
        let x = (Float(painting.width))
        let y = (Float(painting.height))
        let sc = Float(2)
        let mesh: MeshResource = .generateBox(width: 0.01 * sc, height: 0.01 * sc, depth: 0.02)
        let modelComponent = ModelComponent(mesh: mesh, materials: [material])
        if let box = boxAnchor.imageFrame {
            box.components[ModelComponent] = modelComponent
            box.transform.scale = SIMD3<Float>(sc * x, sc * y, 1)
        } else {
            print("got no box")
        }
        
        
        
        //change text

        let textMesh = MeshResource.generateText(
            painting.name,
            extrusionDepth: 0.1,
            font: .systemFont(ofSize: 2),
            containerFrame: .zero,
            alignment: .left,
            lineBreakMode: .byTruncatingTail)
        let textMaterial = SimpleMaterial(color: .gray, isMetallic: false)
        let entity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        entity.scale = SIMD3<Float>(0.05, 0.05, 0.1)
        entity.setPosition(SIMD3<Float>(-x/2, 0, 0), relativeTo: boxAnchor)
        boxAnchor.addChild(entity)
        
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

extension ARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        //coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        //Ready to add entities next?
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ArView(painting: paintingData[0])
    }
}
#endif

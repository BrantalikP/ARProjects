//
//  ObjOnPlaneVC.swift
//  ARProjects
//
//  Created by Petr Brantalík on 30/05/2020.
//  Copyright © 2020 Petr Brantalík. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ObjOnPlaneVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        registerGestureRecognizers()
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    private func registerGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        let sceneView = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitResult.isEmpty {
            
            guard let hitResult = hitResult.first else {
                return
            }
            
            addBox(hitResult: hitResult)
            
        }
    }
    
    private func addBox(hitResult: ARHitTestResult) {
        
        let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.name = "Color"
        material.diffuse.contents = UIColor.red
        
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
    
  
    
}

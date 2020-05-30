//
//  OverlayPlaneVC.swift
//  ARProjects
//
//  Created by Petr Brantalík on 30/05/2020.
//  Copyright © 2020 Petr Brantalík. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum BodyType : Int {
    case box = 1
    case plane = 2
    case car = 3
}

class OverlayPlaneVC: UIViewController, ARSCNViewDelegate {

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
           
           // Set the scene to the view
        registerGestureRecognizers()
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
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.1, chamferRadius: 0)
        
        let material = SCNMaterial()
     
        material.diffuse.contents = UIColor.red
        
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + Float(box.height / 2 ), hitResult.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
    }
       
       func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
           
           if !(anchor is ARPlaneAnchor) {
               return
           }
           
           let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
           self.planes.append(plane)
           node.addChildNode(plane)
       }
       
       func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
           
           let plane = self.planes.filter { plane in
               return plane.anchor.identifier == anchor.identifier
               }.first
           
           if plane == nil {
               return
           }
           
           plane?.update(anchor: anchor as! ARPlaneAnchor)
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           
           // Pause the view's session
           sceneView.session.pause()
       }
       

}

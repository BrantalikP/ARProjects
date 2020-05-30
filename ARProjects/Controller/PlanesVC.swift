//
//  PlanesVC.swift
//  ARProjects
//
//  Created by Petr Brantalík on 30/05/2020.
//  Copyright © 2020 Petr Brantalík. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlanesVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    private let label : UILabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.label.frame = CGRect(x: 0, y: 0, width: self.sceneView.frame.size.width, height: 44)
        self.label.center = self.sceneView.center
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        self.label.font = UIFont.preferredFont(forTextStyle: .headline)
        self.label.alpha = 0
        
        self.sceneView.addSubview(self.label)
        
        navigationController?.isNavigationBarHidden = true
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        // Create a new scene
        let scene = SCNScene()
        
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
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            self.label.text = "Plane Detected"
            
            UIView.animate(withDuration: 3.0, animations: {
                self.label.alpha = 1.0
            }) { (completion: Bool) in
                self.label.alpha = 0.0
            }
            
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

//
//  ViewController.swift
//  Finding Surfaces
//
//  Created by Александр Макаров on 17.09.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = [.horizontal]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func createFloor(planeAnchor: ARPlaneAnchor) -> SCNNode {
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        let geometry = SCNPlane(width: width, height: height)
        geometry.firstMaterial?.diffuse.contents = UIImage(named: "grass-lawn-green-carpet-24994")
        
        let node = SCNNode()
        node.geometry = geometry
        
        node.eulerAngles.x = -Float.pi / 2
        node.opacity = 1
        
        
        
        return node
    }
    
    func createCube() -> SCNNode {
        
        let cube = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)
        cube.firstMaterial?.diffuse.contents = UIImage(named: "BrickRound0105_5_S")
        
        let obj = SCNNode()
        obj.geometry = cube
        obj.position = SCNVector3(x: 0, y: 0.2, z: 0)
        obj.opacity = 1
        
        return obj
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let floor = createFloor(planeAnchor: planeAnchor)
        let obj = createCube()
        node.addChildNode(floor)
        node.addChildNode(obj)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let floor = node.childNodes.first,
            let geometry = floor.geometry as? SCNPlane else { return }
        
        geometry.width = CGFloat(planeAnchor.extent.x)
        geometry.height = CGFloat(planeAnchor.extent.z)
        
        floor.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

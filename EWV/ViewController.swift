//
//  ViewController.swift
//  artest
//
//  Created by Niklas Grenningloh on 21.04.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var timer = Timer()
    
    @IBOutlet weak var Amplitude: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        // startTimer()
        showNodes()
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        // Set the scene to the view
        //sceneView.scene = scene
        
    }
    
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(removeNodes), userInfo: nil, repeats: true)
    }
    
    var nodesArray: [SCNNode] = []
    
    @objc func removeNodes() {
        for nodeAdded in nodesArray{
            nodeAdded.removeFromParentNode()
        }
        
        nodesArray.removeAll()
    }
    
    @objc func showNodes(){
        removeNodes()
        for x in stride(from: 0, to: 1, by: 0.015) {
            for z in stride(from: -1, through: 1, by: 0.015) {
                let node = SCNNode();
                node.geometry = SCNSphere(radius: 0.01)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                node.position = SCNVector3(x, calculateY(x: x, z: z), z)
                sceneView.scene.rootNode.addChildNode(node)
                nodesArray.append(node)
            }
        }
    }
    
    func calculateY(x: Double, z: Double) -> Double {
        let sqrt = (x * x + z * z).squareRoot()
        let sqrt1 = (sqrt / 0.25)
        let f = (2 * Double.pi * sqrt1)
        // f.round()
        let i = Double(Amplitude.value/10) * sin(f) * 1
        return (i / sqrt)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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

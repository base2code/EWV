//
//  ARViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 26.04.21.
//

import UIKit
import SceneKit
import ARKit

class ThreeDARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var timer = Timer()
    
    var amplitudevalue = 1.0
    var frequencyValue = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        removeNodes()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        startTimer()
//        showNodes()
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        // Set the scene to the view
        //sceneView.scene = scene
        
        print("Start: " + String(amplitudevalue))
        
        
        
    }
    
    @objc func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(spawnNewNodes), userInfo: nil, repeats: true)
    }
    
    var nodesArray: [SCNNode] = []
    
    @objc func removeNodes() {
        for nodeAdded in nodesArray{
            nodeAdded.removeFromParentNode()
        }
        
        nodesArray.removeAll()
    }
    
    var step = 0.0
    
    @objc func spawnNewNodes() {
        if step >= 5.01 {
            step = 0.0
        }
        
        let x = step
            for z in stride(from: -0.2, to: 0.2, by: 0.015) {
                let node = SCNNode();
                node.geometry = SCNSphere(radius: 0.01)
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
                let tmp1 = Double((Double(frequencyValue) * 1.0 / 2.5) + x)
                let tmp2 = Double((Double(frequencyValue) * 1.0 / 2.5) + z)
                node.position = SCNVector3(Double(0), calculateY(x: Double(tmp1), z: Double(tmp2)), Double(0))
                
                var z1 = 0.0
                if z < 0 {
                    z1 = Double(frequencyValue * 1.0 / 2.5) * 5 * z * -1;
                }else if z > 0{
                    z1 = Double(frequencyValue * 1.0 / 2.5) * 5 * z;
                }
                
//                let z1 = Double(Periode.value * 1.0 / 2.5) * z
                
                let x1 = Double(frequencyValue * 1.0 / 2.5)
//                let x1 = 2 * Double(Periode.value) * Double(step) + x
//                if x < 0 {
//                    x1 = 32 * x * -1
//                }else if x > 0 {
//                    x1 = 32 * x
//                }
                
                var move = SCNAction()

                if z <= 0 {
                    move = SCNAction.moveBy(x: CGFloat(x1), y: CGFloat(0), z: CGFloat(z1 * -1), duration: 5)
                }else{
                    move = SCNAction.moveBy(x: CGFloat(x1), y: CGFloat(0), z: CGFloat(z1), duration: 5)
                }
                node.runAction(move)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    node.removeFromParentNode()
                }
                sceneView.scene.rootNode.addChildNode(node)
                nodesArray.append(node)
            }
    
        step += 0.01
    
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
        let sqrt1 = (sqrt / 0.25) / 1
        let f = (2 * Double.pi * sqrt1)
        // f.round()
        let i = Double(amplitudevalue / 10) * sin(f) * 1
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
    
    override open var shouldAutorotate: Bool {
        return false
    }

}

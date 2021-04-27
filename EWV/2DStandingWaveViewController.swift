//
//  2DStandingWaveViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 27.04.21.
//

import UIKit
import ARKit
import SceneKit

class _DStandingWaveViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var timer = Timer()
    
    var amplitudevalue = Double()
    var periodeValue = Double()
    var distance = 0.3
    var radius = 0.001

    var timing = 1
    
    var step = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeNodes()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        
        print(amplitudevalue)
        
//        startTimer()
        spawnNodesWithAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @objc func removeNodes() {
        for nodeAdded in nodesArray{
            nodeAdded.removeFromParentNode()
        }
        
        nodesArray.removeAll()
        step = 0.0
    }
    
    var nodesArray: [SCNNode] = []
    
    @objc func spawnNodesWithAnimation() {
        for x in stride(from: 0.0, to: distance, by: radius) {
            let node = SCNNode();
            node.geometry = SCNSphere(radius: CGFloat(radius))
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
            node.position = SCNVector3(x, calculateY(x: Double(x)), Double(0))
            
            nodesArray.append(node)
            
            sceneView.scene.rootNode.addChildNode(node)
            
        }
        
        Timer.scheduledTimer(timeInterval: TimeInterval(timing), target: self, selector: #selector(calculateAllNodes), userInfo: nil, repeats: true)
    }
    
    @objc func calculateAllNodes() {
        for node in nodesArray {
            let y = calculateY(x: (Double(node.position.x))) * sin(step) - Double(node.position.y)
            let action = SCNAction.moveBy(x: CGFloat(0), y: CGFloat(y), z: 0, duration: TimeInterval(timing))
            node.runAction(action)
                                        
        }
        step += radius * 100
    
    }
    
    @objc func calculateY(x: Double) -> Double {
        return ((sin(x * 10 * 1.0 / (periodeValue))) * amplitudevalue) / 10
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

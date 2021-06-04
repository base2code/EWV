//
//  2DStandingWaveViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 27.04.21.
//

import UIKit
import ARKit
import SceneKit

class _2DStandingWaveViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var timer = Timer()
    
    var amplitudevalue = Double()
    var periodeValue = Double()
    var distance = Double()
    var radius = Double()
    
    var showAnchor = Bool()

    var timing = Double()
    
    var step = 1.0
    var startstep = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeNodes()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        if showAnchor {
            sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        }
        
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
        step = 1.0
        startstep = 1.0
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
            let y = calculateY(x: (Double(node.position.x))) * step - Double(node.position.y)
            let action = SCNAction.moveBy(x: CGFloat(0), y: CGFloat(y), z: 0, duration: TimeInterval(timing))
            node.runAction(action)
                                        
        }
        calculateStep()
        startstep += 0.005
    }
    
    @objc func calculateY(x: Double) -> Double {
        return ((sin(x * 10 * 1.0 / (periodeValue))) * amplitudevalue) / 10
    }

    @objc func calculateStep() {
        // Picture of function: /media/triangle_function.jpeg
        let p1 = 2 * amplitudevalue / Double.pi
        let p2 = ((2 * Double.pi) / periodeValue) * startstep
        let p3 = sin(p2)
        let p4 = asin(p3)
        step = p1 * p4
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        if(touch.view == self.sceneView){
            let viewTouchLocation:CGPoint = touch.location(in: sceneView)
            guard let result = sceneView.hitTest(viewTouchLocation, options: nil).first else {
                return
            }
            if nodesArray.contains(result.node) {
                measurement.text = getExperimentCurrent(node: result.node)
            }

        }
    }
    @IBOutlet weak var measurement: UILabel!
    
    @objc func getExperimentCurrent(node: SCNNode) -> String {
        // TODO: Insert formular to calculate voltage when measured in experiment
        return "Hallo"
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

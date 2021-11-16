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
    let radius = 0.001
    
    var timer = Timer()
    
    var frequencyValue = Double()
    var distance = Double()
    
    var showAnchor = Bool()

    var timing = Double()
    
    var step = 1.0
    var startstep = 1.0
    
    @IBOutlet weak var xmove: UISlider!
    @IBOutlet weak var ymove: UISlider!
    @IBOutlet weak var zmove: UISlider!
    
    var xmovealready = 0.0;
    
    let c = 299792458.0

    func calculatePeriode(frequency: Double) -> Double {
        return c / frequency
    }

    
    @IBAction func xmoveaction(_ sender: Any) {
        for node in nodesArray {
            let action = SCNAction.moveBy(x: CGFloat(Double(xmove.value) / 100.0 - xmovealready), y: CGFloat(0), z: CGFloat(0), duration: TimeInterval(timing))
            node.runAction(action)
        }
        xmovealready = Double(xmove.value / 100.0)
    }
    
    var zmovealready = 0.0;
    
    @IBAction func zmoveaction(_ sender: Any) {
        for node in nodesArray {
            let action = SCNAction.moveBy(x: CGFloat(0), y: CGFloat(0), z: CGFloat(Double(zmove.value) / 100.0 - zmovealready), duration: TimeInterval(timing))
            node.runAction(action)
        }
        zmovealready = Double(zmove.value / 100.0)
    }
    
    var originArray: [SCNNode] = []
    @IBOutlet weak var originButton: UISwitch!
    
    @IBAction func originAction(_ sender: Any) {
        if originButton.isOn {
            var x0 = SCNVector3();
            x0.x = xmove.value / 100.0
            x0.y = ymove.value / 100.0
            x0.z = zmove.value / 100.0
            
            var x1 = SCNVector3();
            x1.x = xmove.value / 100.0
            x1.y = ymove.value / 100.0
            x1.z = zmove.value / 100.0
            
            x1.x = xmove.value / 100.0 + Float(0.5)
            let xdir = lineBetweenNodes(positionA: x0, positionB: x1, inScene: sceneView.scene, color: UIColor.red)
            
            x1.x = xmove.value / 100.0
            x1.y = ymove.value / 100.0 + Float(0.5)
            let ydir = lineBetweenNodes(positionA: x0, positionB: x1, inScene: sceneView.scene, color: UIColor.green)
            
            x1.y = ymove.value / 100.0
            x1.z = zmove.value / 100.0 + Float(0.5)
            let zdir = lineBetweenNodes(positionA: x0, positionB: x1, inScene: sceneView.scene, color: UIColor.blue)
            
            
            print(ymove.value / 100.0)
            
            sceneView.scene.rootNode.addChildNode(xdir)
            sceneView.scene.rootNode.addChildNode(ydir)
            sceneView.scene.rootNode.addChildNode(zdir)
            
            originArray.append(xdir)
            originArray.append(ydir)
            originArray.append(zdir)
        }else{
            for node in originArray {
                node.removeFromParentNode()
            }
        }
    }
    
    func lineBetweenNodes(positionA: SCNVector3, positionB: SCNVector3, inScene: SCNScene, color: UIColor) -> SCNNode {
            let vector = SCNVector3(positionA.x - positionB.x, positionA.y - positionB.y, positionA.z - positionB.z)
            let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
            let midPosition = SCNVector3 (x:(positionA.x + positionB.x) / 2, y:(positionA.y + positionB.y) / 2, z:(positionA.z + positionB.z) / 2)

            let lineGeometry = SCNCylinder()
            lineGeometry.radius = 0.002
            lineGeometry.height = CGFloat(distance)
            lineGeometry.radialSegmentCount = 5
            lineGeometry.firstMaterial!.diffuse.contents = color

            let lineNode = SCNNode(geometry: lineGeometry)
            lineNode.position = midPosition
            lineNode.look (at: positionB, up: inScene.rootNode.worldUp, localFront: lineNode.worldUp)
            return lineNode
        }
    
    
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
        for x in stride(from: 0.0, to: distance + 1, by: radius) {
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
            let y = calculateY(x: ((Double(node.position.x))) - xmovealready) - Double(node.position.y)
            let action = SCNAction.moveBy(x: CGFloat(0), y: CGFloat(y) + CGFloat((ymove.value / 100.0)), z: 0, duration: TimeInterval(timing))
            node.runAction(action)
                                        
        }
        calculateStep()
        startstep += 0.005
    }
    
    @objc func calculateY(x: Double) -> Double {
        let lamda = calculatePeriode(frequency: frequencyValue * 1000000000)
        return (sin(x*((2*Double.pi)/lamda)-step)+sin(x*((2*Double.pi)/lamda)+step)) / 100
        //return (sin(x * 10 * 1.0 / (calculatePeriode(frequency: frequencyValue * 1000000000))))
    }

    @objc func calculateStep() {
        // Picture of function: /media/triangle_function.jpeg
        //let p1 = 2 * 0.10 / Double.pi
        //let p2 = ((2 * Double.pi) / calculatePeriode(frequency: frequencyValue * 1000000000)) * startstep
        //let p3 = sin(p2)
        //let p4 = asin(p3)
        //step = p1 * p4
        step += 0.2
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}

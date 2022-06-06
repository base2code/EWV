//
//  2DStandingWaveViewController.swift
//  EWV
//
//  Created by Niklas Grenningloh on 27.04.21.
//

import UIKit
import ARKit
import SceneKit
import GLKit

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
        
        /*plateNode.position.x = xmove.value
        senderNode.position.x = Float(xmove.value + Float(distance))*/
        
        if (originButton.isOn) {
            originFunction(show: false)
            originFunction(show: true)
        }
    }
    
    var zmovealready = 0.0;
    
    @IBAction func zmoveaction(_ sender: Any) {
        for node in nodesArray {
            let action = SCNAction.moveBy(x: CGFloat(0), y: CGFloat(0), z: CGFloat(Double(zmove.value) / 100.0 - zmovealready), duration: TimeInterval(timing))
            node.runAction(action)
        }
        zmovealready = Double(zmove.value / 100.0)
        
        if (originButton.isOn) {
            originFunction(show: false)
            originFunction(show: true)
        }
    }
    
    @IBAction func ymoveaction(_ sender: Any) {
        if (originButton.isOn) {
            originFunction(show: false)
            originFunction(show: true)
        }
    }
    
    
    var originArray: [SCNNode] = []
    @IBOutlet weak var originButton: UISwitch!
    
    func originFunction(show: Bool) {
        if show {
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
    
    @IBAction func originAction(_ sender: Any) {
        originFunction(show: originButton.isOn)
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
    
    let arVew: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeNodes()
        
        // Set the view's delegate
        
        

        view.addSubview(arVew)
        configuration.planeDetection = .horizontal
        
        arVew.session.run(configuration, options: [])
        arVew.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @objc func removeNodes() {
        for nodeAdded in nodesArray{
            nodeAdded.removeFromParentNode()
        }
        
        nodesArray.removeAll()
        step = 1.0
    }
    
    var nodesArray: [SCNNode] = []
    
    let plateNode = SCNNode();
    let senderNode = SCNNode();
    
    @objc func spawnNodesWithAnimation() {
        // Platte
        var x1 = SCNVector3()
        x1.x = 0
        x1.y = -0.05
        x1.z = -0.05
        
        var x2 = SCNVector3()
        x2.x = 0
        x2.y = 0.05
        x2.z = -0.05
        
        var x3 = SCNVector3()
        x3.x = 0
        x3.y = 0.05
        x3.z = 0.05
        
        var x4 = SCNVector3()
        x4.x = 0
        x4.y = -0.05
        x4.z = 0.05
        
        
        
        /*let line1 = lineBetweenNodes(positionA: x1, positionB: x2, inScene: sceneView.scene, color: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8))
        
        plateArray.append(line1)
        
        sceneView.scene.rootNode.addChildNode(line1)*/
        
        let plane = SCNPlane(width: 0.1, height: 0.1);
        plane.cornerRadius = 0.01
        
        plateNode.geometry = plane
        plateNode.geometry?.firstMaterial?.diffuse.contents = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
        //planeNode.rotation = SCNVector4(0.0, 0.0, 0.0, )
        plateNode.position = SCNVector3(0.0, 0.0, 0.0)
        plateNode.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi/2));
        //planeNode.transform = SCNMatrix4Mult(planeNode.transform, SCNMatrix4MakeRotation(90.0, 1, 0, 0))
        
        sceneView.scene.rootNode.addChildNode(plateNode)
        
        
        let senderPlane = SCNPlane(width: 0.05, height: 0.05)
        senderPlane.cornerRadius = 0.005
        
        senderNode.geometry = senderPlane;
        senderNode.geometry?.firstMaterial?.diffuse.contents = UIColor.init(red: 0, green: 0, blue: 100, alpha: 0.8)
        senderNode.position = SCNVector3(distance, 0.0, 0.0)
        senderNode.rotation = SCNVector4Make(0, -1, 0, Float(Double.pi/2));
        
        sceneView.scene.rootNode.addChildNode(senderNode)
        
        
        for x in stride(from: 0.0, to: distance, by: radius) {
            let node = SCNNode();
            node.geometry = SCNSphere(radius: CGFloat(radius))
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
            node.position = SCNVector3(x, calculateY(x: Double(x)), Double(0))
            
            nodesArray.append(node)
            
            sceneView.scene.rootNode.addChildNode(node)
            
        }
        
        Timer.scheduledTimer(timeInterval: TimeInterval(timing),
                             target: self,
                             selector: #selector(calculateAllNodes),
                             userInfo: nil, repeats: true)
    }
    
    @objc func calculateAllNodes() {
        for node in nodesArray {
            let y = calculateY(x: ((Double(node.position.x))) - xmovealready) - Double(node.position.y)
            let action = SCNAction.moveBy(x: CGFloat(0), y: CGFloat(y) + CGFloat((ymove.value / 100.0)), z: 0, duration: TimeInterval(timing))
            node.runAction(action)
        }
        step += 0.2
    }
    
    @objc func calculateY(x: Double) -> Double {
        let lamda = calculatePeriode(frequency: frequencyValue * 1000000000)
        return (sin(x*((2*Double.pi)/lamda)-step)+sin(x*((2*Double.pi)/lamda)+step)) / 100
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        print("Plane detetcted")
    }


}

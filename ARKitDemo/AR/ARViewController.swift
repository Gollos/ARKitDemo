//
//  ARViewController.swift
//  ARKitDemo
//
//  Created by Golos on 1/12/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ReSwift
import ARKitReduxState

class ARViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addButton: UIButton!
    
    struct Model: ViewControllerModel {
        let pockemonType: PockemonType?
        let error: String?
    }

    var pressedTimes = 0
    
    var model: Model! { didSet { render(model) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.antialiasingMode = .multisampling4X
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.debugOptions = [.showFeaturePoints]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPressAction(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
        
        mainStore.subscribe(self) { $0.select(PockemonLens.lens) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        mainStore.unsubscribe(self)
    }
    
    @objc private func onPressAction(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        
        switch pressedTimes {
        case 0:
            addNode(location: tapLocation)
            pressedTimes += 1
        case 1:
            rotate(location: tapLocation)
            pressedTimes += 1
        default:
            deleteNode(location: tapLocation)
            pressedTimes = 0
        }
    }
    
    private func addNode(location: CGPoint) {
        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        
        guard let hitTestResult = hitTestResults.first else { return }
        let translation = hitTestResult.worldTransform.columns.3
        
        guard let pockemonName = model.pockemonType?.rawValue,
            let modelScene = SCNScene(named: "art.scnassets/\(pockemonName).DAE") else { return }
        let modelNode = modelScene.rootNode
        
        modelNode.position = SCNVector3(translation.x, translation.y, translation.z)
        modelNode.name = pockemonName + modelNode.position.stringValue
        sceneView.scene.rootNode.addChildNode(modelNode)
    }
    
    private func pressedNode(location: CGPoint) -> SCNNode? {
        let hitResults = sceneView.hitTest(location, options: [SCNHitTestOption.boundingBoxOnly: true])
        guard let hit = hitResults.first else { return nil }
        
        return getParent(hit.node)
    }
    
    private func deleteNode(location: CGPoint) {
        let node = pressedNode(location: location)
        node?.removeFromParentNode()
    }
    
    private func rotate(location: CGPoint) {
        guard let node = pressedNode(location: location) else { return }
        
        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 2)
        node.runAction(rotateOne)
    }
    
    private func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        guard let node = nodeFound,
            let name = model.pockemonType?.rawValue else { return nil }

        if node.name == name + node.position.stringValue {
            return node

        } else if let parent = node.parent {
            return getParent(parent)
        }
        return nil
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: model.error, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceView = addButton
        
        PockemonType.allCases.forEach {
            let action = UIAlertAction(title: $0.rawValue, style: .default) {
                mainStore.dispatch(PockemonState.ActionCreators.didTapOnPockemon(name: $0.title))
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {}

//MARK: StoreSubscriber
extension ARViewController: StoreSubscriber {
    func newState(state: (pockemonType: PockemonType?, error: String?)) {
        model = Model(pockemonType: state.pockemonType, error: state.error)
    }
}

// MARK: ViewControllerModelSupport
extension ARViewController: ViewControllerModelSupport, ErrorHandlerController {
    func render(_ model: Model) {
        show(error: model.error)
    }
}

extension SCNVector3 {
    var stringValue: String {
        return "\(x)\(y)\(z)"
    }
}

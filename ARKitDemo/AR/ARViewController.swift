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
    
    struct Model: ViewControllerModel {
        let pockemonType: PockemonType?
        let error: String?
    }

    var model: Model! { didSet { render(model) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.antialiasingMode = .multisampling4X
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else { return }
        let hitResults = sceneView.hitTest(location, options: [SCNHitTestOption.boundingBoxOnly: true])
        
        if let hit = hitResults.first,
            let node = getParent(hit.node) {
            node.removeFromParentNode()
            return
        }
        
        let hitResultsFeaturePoints = sceneView.hitTest(location, types: .featurePoint)
        
        if let hit = hitResultsFeaturePoints.first {
            guard let currentFrame = sceneView.session.currentFrame else { return }
            // Get the rotation matrix of the camera
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(currentFrame.camera.eulerAngles.y, 0, 1, 0))
            
            // Combine the matrices
            let finalTransform = simd_mul(hit.worldTransform, rotate)
            sceneView.session.add(anchor: ARAnchor(transform: finalTransform))
        }
    }
    
    private func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        guard let node = nodeFound else { return nil }
        
        if node.name == model.pockemonType?.rawValue {
            return node
            
        } else if let parent = node.parent {
            return getParent(parent)
        }
        return nil
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: model.error, message: nil, preferredStyle: .actionSheet)
        
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
extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !anchor.isKind(of: ARPlaneAnchor.self) else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let pockemonName = self?.model.pockemonType?.rawValue,
                let modelScene = SCNScene(named: "art.scnassets/\(pockemonName).DAE") else { return }
            
            modelScene.rootNode.position = SCNVector3Zero
            node.addChildNode(modelScene.rootNode)
        }
    }
}

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

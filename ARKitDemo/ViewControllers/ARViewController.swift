//
//  ARViewController.swift
//  ARKitDemo
//
//  Created by Golos on 1/12/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ARKit
import ReSwift
import ARKitReduxState

class ARViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.antialiasingMode = .multisampling4X
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.debugOptions = [.showFeaturePoints, .showBoundingBoxes]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPressAction(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
        mainStore.subscribe(self) { $0.select { $0.pockemonState }}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        mainStore.unsubscribe(self)
    }
    
    @objc private func onPressAction(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: [.boundingBoxOnly: true])
        let identifier = hitResults.first?.node.name
        
        mainStore.dispatch(tappedLocation(point: location, identifier: identifier))
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        mainStore.dispatch(showPockemonsSheet())
    }
    
    private func hitTest(location: CGPoint, identifier: String?) -> SCNNode? {
        let hitResults = sceneView.hitTest(location, options: [.boundingBoxOnly: true])
        let node = hitResults.first { $0.node.name == identifier }?.node
        
        return node
    }
    
    private func addNode(location: CGPoint, type: PockemonType) {
        let hitTestResults = sceneView.hitTest(location, types: .estimatedHorizontalPlane)

        guard let hitTestResult = hitTestResults.first else { return }
        
        let anchor = ARAnchor(name: type.rawValue, transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }
    
    private func deleteNode(location: CGPoint, identifier: String) {
        let node = hitTest(location: location, identifier: identifier)
        node?.removeFromParentNode()
    }
    
    private func rotate(location: CGPoint, identifier: String) {
        guard let node = hitTest(location: location, identifier: identifier) else { return }

        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 2)
        node.runAction(rotateOne)
    }
    
    private func getParent(_ nodeFound: SCNNode?, identifier: String) -> SCNNode? {
        guard let node = nodeFound else { return nil }

        if node.name == identifier {
            return node

        } else if let parent = node.parent {
            return getParent(parent, identifier: identifier)
        }
        return nil
    }
    
    private func showAlertSheet(titles: [String]) {
        guard !titles.isEmpty else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceView = addButton
        
        titles.forEach {
            let action = UIAlertAction(title: $0, style: .default) {
                mainStore.dispatch(setSelectedPockemon(name: $0.title ?? ""))
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: ARSCNViewDelegate
extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let modelName = anchor.name,
            let modelNode = SCNNode.create(with: modelName) else { return }
        
        modelNode.name = anchor.identifier.uuidString
        modelNode.simdTransform = anchor.transform
        node.addChildNode(modelNode)
    }
}

//MARK: StoreSubscriber
extension ARViewController: StoreSubscriber {
    func newState(state: PockemonState) {
        showAlertSheet(titles: state.pockemonSheetTypes)
        
        guard let location = state.lastLocation else { return }
        
        let identifier = state.lastIdentififer ?? ""
        let evolutionState = state.evolutionInfo[identifier] ?? .none

        switch evolutionState {
        case .none:
            guard let type = state.selectedType else { return }
            addNode(location: location, type: type)
            
        case .middle, .top:
            rotate(location: location, identifier: identifier)
            
        case .grand:
            deleteNode(location: location, identifier: identifier)
        }
    }
}

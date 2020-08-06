//
//  ViewController.swift
//  CALayerTransformExample
//
//  Created by 長内幸太郎 on 2020/08/06.
//  Copyright © 2020 長内幸太郎. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet var rotationGesture: UIRotationGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var canvasView: UIView!
    var targetLayer: CALayer!
    
    var rotation: CGFloat = 0
    var scale: CGFloat = 1.0
    var tx: CGFloat = 0
    var ty: CGFloat = 0
    
    var editingRotation: CGFloat = 0
    var editingScale: CGFloat = 1.0
    var editingTx: CGFloat = 0
    var editingTy: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGestureRecognizer.delegate = self

        canvasView = UIView(frame: CGRect(x: 50, y: 50, width: 300, height: 600))
        canvasView.backgroundColor = .lightGray
        view.addSubview(canvasView)
        
        targetLayer = addRandomColoredLayer()
        targetLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        canvasView.layer.addSublayer(targetLayer)
    }
    
    
    func createColoredLayer(width: CGFloat, height: CGFloat) -> CALayer {
        let newLayer = CALayer()
        newLayer.backgroundColor = UIColor.red.cgColor      //generateRandomColor().cgColor
        newLayer.anchorPoint = CGPoint(x: 0, y: 0)
        newLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return newLayer
    }
    
    func addRandomColoredLayer() -> CALayer {
        let coloredLayer = createColoredLayer(width: 50, height: 100)
        coloredLayer.position = CGPoint(x: 30.0, y: 30.0)
        
        return coloredLayer
    }
    
    @IBAction func pinched(_ sender: UIPinchGestureRecognizer) {
        editingScale = sender.scale * scale
        
        print(editingScale)

        switch sender.state {
        case .changed:
            transformLayer(layer: targetLayer,
                           transform: CATransform3D.create(tx: editingTx, ty: editingTy, scale: editingScale, rotation: editingRotation))
        case .ended:
            scale = editingScale
        case .cancelled:
            transformLayer(layer: targetLayer,
                           transform: CATransform3D.create(tx: tx, ty: ty, scale: sender.scale * scale, rotation: rotation))
        default:
            break
        }
    }
    
    @IBAction func rotated(_ sender: UIRotationGestureRecognizer) {
        editingRotation = sender.rotation + rotation

        print(targetLayer.anchorPoint, "あ")
        
        
        print(editingRotation)

        switch sender.state {
        case .changed:
            transformLayer(layer: targetLayer,
                           transform: CATransform3D.create(tx: editingTx, ty: editingTy, scale: editingScale, rotation: editingRotation))
        case .ended:
            rotation = editingRotation
        case .cancelled:
            transformLayer(layer: targetLayer,
                           transform: CATransform3D.create(tx: tx, ty: ty, scale: scale, rotation: rotation))
        default:
            break
        }
    }
    
    @IBAction func paned(_ sender: UIPanGestureRecognizer) {
        let point: CGPoint = sender.translation(in: self.view)
        
        print(point)

        editingTx = tx + point.x //* cos(editingRotation) + point.y * sin(editingRotation)
        editingTy = ty + point.y //* cos(editingRotation) - point.x * sin(editingRotation)

        switch sender.state {
        case .changed:
            transformLayer(layer: targetLayer,
                           transform: CATransform3D.create(tx: editingTx, ty: editingTy, scale: editingScale, rotation: editingRotation))
        case .ended:
            tx = editingTx
            ty = editingTy
        case .cancelled:
            transformLayer(layer: targetLayer,
                           transform: CATransform3D.create(tx: tx, ty: ty, scale: scale, rotation: rotation))
        default:
            break
        }
    }
    
    func transformLayer(layer: CALayer, transform: CATransform3D) {
        // Animationさせない
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        layer.transform = transform
        
        CATransaction.commit()
    }
    
}

extension CATransform3D {
    static func create(tx: CGFloat, ty: CGFloat, scale: CGFloat, rotation: CGFloat) -> CATransform3D {
        var transform = CATransform3DMakeTranslation(tx, ty, 0)
        // rotate
        transform = CATransform3DRotate(transform, rotation, 0.0, 0.0, 1.0)
        // scale
        transform = CATransform3DScale(transform, scale, scale, 1.0)

        return transform
    }
}


extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /// Multiple GestureRecognizerを許可
        return true
    }
}

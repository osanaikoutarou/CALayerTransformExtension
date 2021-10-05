//
//  AnimViewController.swift
//  CALayerTransformExample
//
//  Created by 長内幸太郎 on 2021/10/05.
//  Copyright © 2021 長内幸太郎. All rights reserved.
//

import UIKit

class AnimViewController: UIViewController {

    @IBOutlet weak var redView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tappedButton(_ sender: Any) {
        UIView.animate(withDuration: 1.0) {
            self.redView.transform = CGAffineTransform(rotationAngle: 180.radian)
        }
    }

}

private extension CGFloat {
    var radian: CGFloat {
        return self * CGFloat.pi / 180.0
    }
}
private extension Int {
    var radian: CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}

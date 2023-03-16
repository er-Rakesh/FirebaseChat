//
//  WolfTabBar.swift
//  grabnow
//
//  Created by Wolf on 03/05/20.
//  Copyright © 2020 Wolf. All rights reserved.
//

import UIKit
@IBDesignable
class WolfTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    private func addShape() {
        let shapeLayer = CAShapeLayer()
       // shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        //The below 4 lines are for shadow above the bar. you can skip them if you do not want a shadow
        shapeLayer.shadowOffset = CGSize(width:2, height:-4)
        shapeLayer.shadowRadius = 5
        shapeLayer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shapeLayer.shadowOpacity = 1
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    override func draw(_ rect: CGRect) {
     let v = UIImageView(image:  UIImage(named: "HomeNav"))
//        self.addSubview(v)
        self.insertSubview(v, at: 0)
//          self.backgroundColor = UIColor(patternImage:   UIImage(named: "HomeNav")!)
        self.roundCorners(corners: [.topLeft,.topRight], radius: 20)
        //self.addShape()
    }
    func createPath() -> CGPath {
       // let height: CGFloat = 30.0
        let path = UIBezierPath()
       // let centerWidth = self.frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
       // the beginning of the trough
     //   path.addLine(to: CGPoint(x: (centerWidth - 45), y: 0)) // the beginning of the trough
        
//        path.addCurve(to: CGPoint(x: centerWidth, y: 40),
//                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 40, y: 35))
//
//        path.addCurve(to: CGPoint(x: (centerWidth + 45), y: 0),
//                      controlPoint1: CGPoint(x: centerWidth + 40, y: 35), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
    
}

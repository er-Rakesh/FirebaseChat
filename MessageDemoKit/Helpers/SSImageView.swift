//
//  SSImageView.swift
//  AtoZ
//
//  Created by Emizen Tech Subhash on 04/05/21.
//

import UIKit
@IBDesignable
class SSView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //super.draw(self.bounds)
        self.curve()
    }
    
    func curve(){
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.path().cgPath
           shapeLayer.frame = self.bounds
           shapeLayer.masksToBounds = true
           self.layer.mask = shapeLayer
    }
    func path()->UIBezierPath{
        let path =  UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to:CGPoint(x: self.frame.size.width, y: 0) )
        path.addLine(to:CGPoint(x: self.frame.size.width, y: self.frame.size.height) )
        path.addCurve(to:CGPoint(x: self.frame.size.width-45, y:  self.frame.size.height-45) , controlPoint1: CGPoint(x: self.frame.size.width-8, y:  self.frame.size.height-15), controlPoint2: CGPoint(x: self.frame.size.width-15, y:  self.frame.size.height-38))
        path.addLine(to: CGPoint(x: 45, y:self.frame.size.height-45 ))
        path.addCurve(to:CGPoint(x: 0, y:  self.frame.size.height-90) , controlPoint1: CGPoint(x: 23, y:  self.frame.size.height-45), controlPoint2: CGPoint(x: 8, y:  self.frame.size.height-60))
        
        path.addLine(to: CGPoint(x: 0, y:0))
        path.close()
        
        return path
    }
}

@IBDesignable
class SSProgressIndicatorView: UIView {
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        //super.draw(self.bounds)
        self.curve()
    }
    func curve(){
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.path().cgPath
           shapeLayer.frame = self.bounds
           shapeLayer.masksToBounds = true
           self.layer.mask = shapeLayer
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    func path()->UIBezierPath{
        let path =  UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to:CGPoint(x: self.frame.size.width, y: 0) )
        path.addLine(to:CGPoint(x: self.frame.size.width, y: self.frame.size.height - 5) )
        path.addLine(to:CGPoint(x: (self.frame.size.width/2) + 5 , y: self.frame.size.height - 5) )
        
        path.addLine(to: CGPoint(x: (self.frame.size.width/2), y:self.frame.size.height ))
        path.addLine(to: CGPoint(x: (self.frame.size.width/2) - 5 , y:self.frame.size.height-5 ))
        path.addLine(to: CGPoint(x: 0 , y:self.frame.size.height-5 ))
        path.addLine(to: CGPoint(x: 0, y:0))
        path.close()
        
        return path
    }
}

@IBDesignable
class RoundedStar : UIView {
    
    @IBInspectable var cRnew: CGFloat = 10.00 { didSet { setNeedsDisplay() } }
    @IBInspectable var rotation: CGFloat = 54     { didSet { setNeedsDisplay() } }
    @IBInspectable var fillColor = UIColor.yellow    { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        makeStar()
    }
    
    func makeStar(){
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.path().cgPath
           shapeLayer.frame = self.bounds
           shapeLayer.masksToBounds = true
           self.layer.mask = shapeLayer
        
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.yellow.cgColor
       // self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func path()->UIBezierPath{
        let path = UIBezierPath()
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        let r = self.frame.width / 2
        let rc = cRnew
        let rn = r * 0.95 - rc
    
        var cangle = rotation
        for i in 1 ... 5 {
            // compute center point of tip arc
            let cc = CGPoint(x: center.x + rn * cos(cangle * .pi / 180), y: center.y + rn * sin(cangle * .pi / 180))

            // compute tangent point along tip arc
            let p = CGPoint(x: cc.x + rc * cos((cangle - 72) * .pi / 180), y: cc.y + rc * sin((cangle - 72) * .pi / 180))

            if i == 1 {
                path.move(to: p)
            } else {
                path.addLine(to: p)
            }

            // add 144 degree arc to draw the corner
            path.addArc(withCenter: cc, radius: rc, startAngle: (cangle - 72) * .pi / 180, endAngle: (cangle + 72) * .pi / 180, clockwise: true)

            cangle += 144
        }
        path.close()
//        UIColor.yellow.setStroke()
//        path.lineWidth = 10
//        path.stroke()
        
        fillColor.setFill()
        path.fill()
        return path
    }
}

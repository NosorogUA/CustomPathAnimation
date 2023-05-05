//
//  CustomPath.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

enum ShapeState {
    case start, finish
}

class CustomPath: UIView {
    
    var currentFrame: CGRect
    var currentState: ShapeState = .start
    var currentPath: UIBezierPath?
    let controlDelta: CGFloat = 30
    private let shapeLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    private var isAnimating: Bool = false
    
    
    override init(frame: CGRect) {
        self.currentFrame = frame
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        currentPath = getShape(state: .start)
        
        shapeLayer.path = currentPath?.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        maskLayer.path = shapeLayer.path
        maskLayer.position =  shapeLayer.position
        
        self.layer.addSublayer(self.shapeLayer)
    }
    
    func changeShape() {
        
//        if isAnimating {
//            print("go to next animation")
//            finishAnimation()
//        } else {
            print("Finish animation")
            guard let currentPath else { return }
            self.shapeLayer.path = currentPath.cgPath
            currentState = currentState == .start ? .finish : .start
//        }
    }
    
    func animateShape() {
        self.shapeLayer.removeAllAnimations()
//        isAnimating = true
        print("animate to midle path")
        
        let animation1 = CABasicAnimation(keyPath: "path")
        
        animation1.duration = 1
        animation1.fromValue = currentPath?.cgPath
        animation1.toValue = midPath()
        animation1.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        
//        animation.delegate = self
        
        var new: UIBezierPath
        switch currentState {
        case .start:
            new = getShape(state: .finish)
        case .finish:
            new = getShape(state: .start)
        }

        let animation2 = CABasicAnimation(keyPath: "finishPath")

        animation2.duration = 1
        animation2.fromValue = midPath()
        animation2.toValue = new.cgPath
        animation2.fillMode = .forwards
        animation2.isRemovedOnCompletion = false
        animation2.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation2.delegate = self
        isAnimating = false
        currentPath = new
        
        let group: CAAnimationGroup
        group.duration = 2
        group.animations = [animation1, animation2]
        group.delegate = self
        
        self.shapeLayer.add(group, forKey: "waves")
        maskLayer.add(group, forKey: "waves")
    }
    
    private func finishAnimation() {

        print("animate to finish path")
        var new: UIBezierPath
        switch currentState {
        case .start:
            new = getShape(state: .finish)
        case .finish:
            new = getShape(state: .start)
        }

        let animation = CABasicAnimation(keyPath: "finishPath")

        animation.duration = 1
        animation.fromValue = currentPath?.cgPath
        animation.toValue = new.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.delegate = self
        isAnimating = false
        currentPath = new
        self.shapeLayer.add(animation, forKey: "waves")
        shapeLayer.add(CAAnimation, forKey: <#T##String?#>)
    }
}

extension CustomPath: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.changeShape()
        }
    }
}
// MARK: Custom Shapes
extension CustomPath {
    private func getShape(state: ShapeState) -> UIBezierPath {
        
        var firstAnchorDelta: CGFloat = 0
        var midleAnchorDelta: CGFloat = 0
        var secondAnchorDelta: CGFloat = 0
        
        switch state {
        case .start:
            firstAnchorDelta = 80
            midleAnchorDelta = 75
            secondAnchorDelta = 60
        case .finish:
            firstAnchorDelta = 60
            midleAnchorDelta = 70
            secondAnchorDelta = 80
        }
        
        let path = UIBezierPath()
        let step = currentFrame.width/4
        // wave points from right to left
        let point1: CGPoint =  CGPoint(x: currentFrame.maxX,
                                       y: currentFrame.minY+midleAnchorDelta)
        let point2: CGPoint =  CGPoint(x: currentFrame.maxX - step,
                                       y: currentFrame.minY+firstAnchorDelta)
        let point3: CGPoint =  CGPoint(x: currentFrame.maxX - step*2,
                                       y: currentFrame.minY+secondAnchorDelta)
        let point4: CGPoint =  CGPoint(x: currentFrame.maxX - step*3,
                                       y: currentFrame.minY+firstAnchorDelta)
        let point5: CGPoint =  CGPoint(x: currentFrame.maxX - step*4,
                                       y: currentFrame.minY+secondAnchorDelta)
        
        path.move(to: CGPoint(x: currentFrame.minX, y: currentFrame.minY))
        path.addLine(to: CGPoint(x: currentFrame.maxX, y: currentFrame.minY))
        path.addLine(to: point1)
        path.addCurve(to: point2,
                      controlPoint1: CGPoint(x: point1.x-controlDelta, y: point1.y),
                      controlPoint2: CGPoint(x: point2.x+controlDelta, y: point2.y))
        path.addCurve(to: point3,
                      controlPoint1: CGPoint(x: point2.x-controlDelta, y: point2.y),
                      controlPoint2: CGPoint(x: point3.x+controlDelta, y: point3.y))
        path.addCurve(to: point4,
                      controlPoint1: CGPoint(x: point3.x-controlDelta, y: point3.y),
                      controlPoint2: CGPoint(x: point4.x+controlDelta, y: point4.y))
        path.addCurve(to: point5,
                      controlPoint1: CGPoint(x: point4.x-controlDelta, y: point4.y),
                      controlPoint2: CGPoint(x: point5.x+controlDelta, y: point5.y))
        return path
    }
    
    private func midPath() -> UIBezierPath {
       
        let controlDeltaY: CGFloat = 14
        let firstAnchorDelta: CGFloat = 80
        let midleAnchorDelta: CGFloat = 70
        let secondAnchorDelta: CGFloat = 60
       
        let path = UIBezierPath()
        let step = currentFrame.width/4
        // wave points from right to left
        let point1: CGPoint =  CGPoint(x: currentFrame.maxX,
                                       y: currentFrame.minY+firstAnchorDelta)
        let point2: CGPoint =  CGPoint(x: currentFrame.maxX - step,
                                       y: currentFrame.minY+midleAnchorDelta)
        let point3: CGPoint =  CGPoint(x: currentFrame.maxX - step*2,
                                       y: currentFrame.minY+midleAnchorDelta)
        let point4: CGPoint =  CGPoint(x: currentFrame.maxX - step*3,
                                       y: currentFrame.minY+midleAnchorDelta)
        let point5: CGPoint =  CGPoint(x: currentFrame.maxX - step*4,
                                       y: currentFrame.minY+midleAnchorDelta)
        
        path.move(to: CGPoint(x: currentFrame.minX, y: currentFrame.minY))
        path.addLine(to: CGPoint(x: currentFrame.maxX, y: currentFrame.minY))
        path.addLine(to: point1)
        path.addCurve(to: point2,
                      controlPoint1: CGPoint(x: point1.x-controlDelta, y: point1.y),
                      controlPoint2: CGPoint(x: point2.x+controlDelta, y: point2.y+controlDeltaY))
        path.addCurve(to: point3,
                      controlPoint1: CGPoint(x: point2.x-controlDelta, y: point2.y-controlDeltaY),
                      controlPoint2: CGPoint(x: point3.x+controlDelta, y: point3.y-controlDeltaY))
        path.addCurve(to: point4,
                      controlPoint1: CGPoint(x: point3.x-controlDelta, y: point3.y+controlDeltaY),
                      controlPoint2: CGPoint(x: point4.x+controlDelta, y: point4.y+controlDeltaY))
        path.addCurve(to: point5,
                      controlPoint1: CGPoint(x: point4.x-controlDelta, y: point4.y-controlDeltaY),
                      controlPoint2: CGPoint(x: point5.x+controlDelta, y: point5.y))
        return path
    }
}

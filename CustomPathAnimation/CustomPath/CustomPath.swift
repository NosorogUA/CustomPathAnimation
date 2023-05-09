//
//  CustomPath.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

enum ShapeState {
    case splash, start, finish
}

class CustomPath: UIView {
    
    private let currentFrame: CGRect
    private let color: UIColor
    private var currentState: ShapeState = .splash
    
    private let controlDeltaX: CGFloat
    private let controlDeltaY: CGFloat
    private let step: CGFloat
    private let duration: TimeInterval = 0.4
    private var delay: TimeInterval
    
    private let minWaveY: CGFloat = 60
    private let maxWaveY: CGFloat = 80
    private var midleAnchorDelta: CGFloat {
        return (minWaveY+maxWaveY)/2
    }
    
    private let shapeLayer = CAShapeLayer()
//    private let shapeLayer2 = CAShapeLayer()
//    private let shapeLayer3 = CAShapeLayer()
//    private let shapeLayer4 = CAShapeLayer()
    
    var animationHandler: ((Bool) -> Void)?
    
    init(frame: CGRect, color: UIColor, delay: TimeInterval = 0.0) {
        self.currentFrame = frame
        self.color = color
        self.delay = delay
        step = currentFrame.width/4
        controlDeltaX = currentFrame.width/10
        controlDeltaY = currentFrame.width/50
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Wave view deinit")
    }
    
    private func setup() {
        switch currentState {
        case .splash:
            self.shapeLayer.path = getShape(state: .splash).cgPath
        case .start:
            self.shapeLayer.path = getShape(state: .start).cgPath
        case .finish:
            self.shapeLayer.path = getShape(state: .finish).cgPath
        }
        shapeLayer.fillColor = color.cgColor
        self.layer.addSublayer(self.shapeLayer)
//        shapeLayer2.path = getShape(state: .finish).cgPath
//        shapeLayer3.path = midPath(isFirst: true).cgPath
//        shapeLayer4.path = midPath(isFirst: false).cgPath
        
//        shapeLayer.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor
//        shapeLayer2.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5).cgColor
//        shapeLayer3.fillColor = UIColor(red: 0, green: 1, blue: 0.5, alpha: 0.5).cgColor
//        shapeLayer4.fillColor = UIColor(red: 0.5, green: 0, blue: 1, alpha: 0.5).cgColor
        
//        self.layer.addSublayer(self.shapeLayer2)
//        self.layer.addSublayer(self.shapeLayer3)
//        self.layer.addSublayer(self.shapeLayer4)
    }
    
    func changeShape() {
        print("Finish animation")
        switch currentState {
        case .splash:
            self.shapeLayer.path = getShape(state: .splash).cgPath
        case .start:
            self.shapeLayer.path = getShape(state: .start).cgPath
        case .finish:
            self.shapeLayer.path = getShape(state: .finish).cgPath
        }
        animationHandler?(false)
    }
    
    func animateShape(isForward: Bool) {
        animationHandler?(true)
        print("animate to midle path")
        var new: UIBezierPath
        var animationDuration: TimeInterval = duration
        var animationDelay: TimeInterval = delay
        switch currentState {
        case .splash:
            animationDuration = (isForward ? 1.3 : 1.0) - delay
            animationDelay = delay + (isForward ? 0.6 : 0.9)
            new = midPath(isFirst: isForward)
            currentState = isForward ? .start : .finish
        case .start:
            new = midPath(isFirst: isForward)
            currentState = .finish
        case .finish:
            new = midPath(isFirst: !isForward)
            currentState = .start
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self else { return }
            self.shapeLayer.path = new.cgPath
            self.finishAnimation()
        }
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.beginTime = CACurrentMediaTime() + animationDelay
        animation.duration = animationDuration
        animation.toValue = new.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        self.shapeLayer.add(animation, forKey: "waves")
        
        CATransaction.commit()
    }
    
    private func finishAnimation() {
        print("animate to finish path")
        var new: UIBezierPath
        switch currentState {
        case .start:
            new = getShape(state: .start)
        case .finish:
            new = getShape(state: .finish)
        case .splash:
            new = getShape(state: .start)
        }
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = duration
        animation.toValue = new.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.delegate = self
        
        self.shapeLayer.add(animation, forKey: "waves")
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
        var firstAnchorDelta: CGFloat
        var secondAnchorDelta: CGFloat
        var midAnchor: CGFloat = midleAnchorDelta
        
        switch currentState {
        case .splash:
            firstAnchorDelta = currentFrame.height
            secondAnchorDelta = currentFrame.height
            midAnchor = currentFrame.height
        case .start:
            firstAnchorDelta = maxWaveY
            secondAnchorDelta = minWaveY
        case .finish:
            firstAnchorDelta = minWaveY
            secondAnchorDelta = maxWaveY
        }
        
        let path = UIBezierPath()
        
        // wave points from right to left
        let point1: CGPoint =  CGPoint(x: currentFrame.maxX,
                                       y: currentFrame.minY+midAnchor)
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
                      controlPoint1: CGPoint(x: point1.x-controlDeltaX, y: point1.y),
                      controlPoint2: CGPoint(x: point2.x+controlDeltaX, y: point2.y))
        path.addCurve(to: point3,
                      controlPoint1: CGPoint(x: point2.x-controlDeltaX, y: point2.y),
                      controlPoint2: CGPoint(x: point3.x+controlDeltaX, y: point3.y))
        path.addCurve(to: point4,
                      controlPoint1: CGPoint(x: point3.x-controlDeltaX, y: point3.y),
                      controlPoint2: CGPoint(x: point4.x+controlDeltaX, y: point4.y))
        path.addCurve(to: point5,
                      controlPoint1: CGPoint(x: point4.x-controlDeltaX, y: point4.y),
                      controlPoint2: CGPoint(x: point5.x+controlDeltaX, y: point5.y))
        return path
    }
    
    private func midPath(isFirst: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        // wave points from right to left
        let point1: CGPoint =  CGPoint(x: currentFrame.maxX,
                                       y: currentFrame.minY+midleAnchorDelta)
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
        
        if isFirst {
            path.addCurve(to: point2,
                          controlPoint1: CGPoint(x: point1.x, y: point1.y),
                          controlPoint2: CGPoint(x: point2.x+controlDeltaX, y: point2.y+controlDeltaY))
            path.addCurve(to: point3,
                          controlPoint1: CGPoint(x: point2.x-controlDeltaX, y: point2.y-controlDeltaY),
                          controlPoint2: CGPoint(x: point3.x+controlDeltaX, y: point3.y-controlDeltaY))
            path.addCurve(to: point4,
                          controlPoint1: CGPoint(x: point3.x-controlDeltaX, y: point3.y+controlDeltaY),
                          controlPoint2: CGPoint(x: point4.x+controlDeltaX, y: point4.y+controlDeltaY))
            path.addCurve(to: point5,
                          controlPoint1: CGPoint(x: point4.x-controlDeltaX, y: point4.y-controlDeltaY),
                          controlPoint2: CGPoint(x: point5.x+controlDeltaX, y: point5.y))
        } else {
            path.addCurve(to: point2,
                          controlPoint1: CGPoint(x: point1.x-controlDeltaX, y: point1.y-controlDeltaY),
                          controlPoint2: CGPoint(x: point2.x+controlDeltaX, y: point2.y-controlDeltaY))
            path.addCurve(to: point3,
                          controlPoint1: CGPoint(x: point2.x-controlDeltaX, y: point2.y+controlDeltaY),
                          controlPoint2: CGPoint(x: point3.x+controlDeltaX, y: point3.y+controlDeltaY))
            path.addCurve(to: point4,
                          controlPoint1: CGPoint(x: point3.x-controlDeltaX, y: point3.y-controlDeltaY),
                          controlPoint2: CGPoint(x: point4.x+controlDeltaX, y: point4.y-controlDeltaY))
            path.addCurve(to: point5,
                          controlPoint1: CGPoint(x: point4.x-controlDeltaX, y: point4.y+controlDeltaY),
                          controlPoint2: CGPoint(x: point5.x+controlDeltaX, y: point5.y+controlDeltaY))
        }
        
        return path
    }
}

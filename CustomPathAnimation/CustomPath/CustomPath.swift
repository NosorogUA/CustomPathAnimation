//
//  CustomPath.swift
//  CustomPathAnimation
//
//  Created by mac on 5/4/23.
//

import UIKit

class CustomPath: UIView {
    
    private let currentFrame: CGRect
    private let color: UIColor
    private var currentState: ShapeState = .splash
    
    private let stepCounter: CGFloat = 4
    private let waveHeightDelta: CGFloat = 20
    
    private let mainDuration: TimeInterval = 0.4
    private let duration: TimeInterval
    private var delay: TimeInterval
    
    private let maxWaveY: CGFloat
   
    private let shapeLayer = CAShapeLayer()
    
    var animationHandler: ((Bool) -> Void)?
    
    init(frame: CGRect, color: UIColor, delay: TimeInterval = 0.0, duration: TimeInterval = 1.5, maxHeight: CGFloat = 100) {
        self.currentFrame = frame
        maxWaveY = maxHeight
        self.color = color
        self.delay = delay
        self.duration = duration
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
            self.shapeLayer.path = FlashAnimationState()
                .getMainShape(frame: currentFrame,
                              maxY: maxWaveY,
                              stepCounter: stepCounter,
                              waveDelta: waveHeightDelta).cgPath
        case .start:
            self.shapeLayer.path = FirstAnimationState()
                .getMainShape(frame: currentFrame,
                              maxY: maxWaveY,
                              stepCounter: stepCounter,
                              waveDelta: waveHeightDelta).cgPath
        case .finish:
            self.shapeLayer.path = SecondAnimationState()
                .getMainShape(frame: currentFrame,
                              maxY: maxWaveY,
                              stepCounter: stepCounter,
                              waveDelta: waveHeightDelta).cgPath
        }
        shapeLayer.fillColor = color.cgColor
        self.layer.addSublayer(self.shapeLayer)
    }
    
    func changeShape() {
        switch currentState {
        case .splash:
            self.shapeLayer.path = FlashAnimationState()
                .getMainShape(frame: currentFrame,
                              maxY: maxWaveY,
                              stepCounter: stepCounter,
                              waveDelta: waveHeightDelta).cgPath
        case .start:
            self.shapeLayer.path = FirstAnimationState()
                .getMainShape(frame: currentFrame,
                              maxY: maxWaveY,
                              stepCounter: stepCounter,
                              waveDelta: waveHeightDelta).cgPath
        case .finish: /////////
            let state = SecondAnimationState()
            let path = state.getMainShape(frame: currentFrame,
                                          maxY: maxWaveY,
                                          stepCounter: stepCounter,
                                          waveDelta: waveHeightDelta).cgPath
            self.shapeLayer.path = path
        }
        animationHandler?(false)
    }
    
    func animateShape(isForward: Bool) {
        animationHandler?(true)
        var new: UIBezierPath
        var animationDuration: TimeInterval = mainDuration
        var animationDelay: TimeInterval = 0.0
        
        switch currentState {
        case .splash:
            animationDuration = duration
            animationDelay = delay
            let pathState: TransitionPathState = isForward ? .mid1 : .mid2
            new = FlashAnimationState()
                .midTransitionPath(state: pathState,
                                   frame: currentFrame,
                                   maxY: maxWaveY,
                                   stepCounter: stepCounter,
                                   waveDelta: waveHeightDelta)
            currentState = isForward ? .start : .finish
            
        case .start:
            let pathState: TransitionPathState = isForward ? .mid1 : .mid2
            new = FirstAnimationState()
                .midTransitionPath(state: pathState,
                                   frame: currentFrame,
                                   maxY: maxWaveY,
                                   stepCounter: stepCounter,
                                   waveDelta: waveHeightDelta)
            currentState = .finish
            
        case .finish:
            let pathState: TransitionPathState = isForward ? .mid2 : .mid1
            new = FirstAnimationState()
                .midTransitionPath(state: pathState,
                                   frame: currentFrame,
                                   maxY: maxWaveY,
                                   stepCounter: stepCounter,
                                   waveDelta: waveHeightDelta)
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
        var new: UIBezierPath
        switch currentState {
        case .start, .splash:
            new = FirstAnimationState().getMainShape(frame: currentFrame, maxY: maxWaveY, stepCounter: stepCounter, waveDelta: waveHeightDelta)
        case .finish:
            new = SecondAnimationState().getMainShape(frame: currentFrame, maxY: maxWaveY, stepCounter: stepCounter, waveDelta: waveHeightDelta)
        }
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = mainDuration
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
    
   
}

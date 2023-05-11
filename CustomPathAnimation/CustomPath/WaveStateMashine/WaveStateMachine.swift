//
//  WaveStateMachine.swift
//  CustomPathAnimation
//
//  Created by mac on 5/11/23.
//

import UIKit

enum ShapeState {
    case splash, start, finish
}

class WaveStateMachine {
    
    private let flashState = FlashAnimationState()
    private let firstState = FirstAnimationState()
    private let secondState = SecondAnimationState()
    
    private let pathFactory: PathFactory
    private let stateInitEntity: StateInitEntity
    
    private let stepCounter: CGFloat = 4
    private let waveHeightDelta: CGFloat = 20
    
    var currentState: ShapeState
    
    init(currentFrame: CGRect, currentState: ShapeState = .splash, maxWaveY: CGFloat) {
        self.currentState = currentState
        pathFactory = PathFactory()
        stateInitEntity = StateInitEntity(frame: currentFrame,
                                          maxY: maxWaveY,
                                          stepCounter: stepCounter,
                                          waveDelta: waveHeightDelta,
                                          pathFactory: pathFactory)
    }
    
    func setupStartPath() -> UIBezierPath {
        switch currentState {
        case .splash:
            return flashState.getMainShape(initEntity: stateInitEntity)
        case .start:
            return firstState.getMainShape(initEntity: stateInitEntity)
        case .finish:
            return secondState.getMainShape(initEntity: stateInitEntity)
        }
        
    }
    
    func initStartShape(isDirectionForward: Bool) -> UIBezierPath {
        switch currentState {
        case .splash:
            currentState = isDirectionForward ? .start : .finish
            let pathState: TransitionPathState = isDirectionForward ? .mid1 : .mid2
            return flashState.midTransitionPath(state: pathState,
                                                initEntity: stateInitEntity)
            
        case .start:
            currentState = .finish
            let pathState: TransitionPathState = isDirectionForward ? .mid1 : .mid2
            return firstState.midTransitionPath(state: pathState,
                                                initEntity: stateInitEntity)
            
        case .finish:
            currentState = .start
            let pathState: TransitionPathState = isDirectionForward ? .mid2 : .mid1
            return secondState.midTransitionPath(state: pathState,
                                                initEntity: stateInitEntity)
        }
    }
    
    func initTransitionPath() -> UIBezierPath {
        switch currentState {
        case .start, .splash:
            return firstState.getMainShape(initEntity: stateInitEntity)
        case .finish:
            return secondState.getMainShape(initEntity: stateInitEntity)
        }
    }
}

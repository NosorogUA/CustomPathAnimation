//
//  WaveState.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

enum ShapeState {
    case splash, start, finish
}

protocol WaveState {
    func getMainShape(frame: CGRect,
                      maxY: CGFloat,
                      stepCounter: CGFloat,
                      waveDelta: CGFloat) -> UIBezierPath
    
    func midTransitionPath(state: TransitionPathState,
                           frame: CGRect,
                           maxY: CGFloat,
                           stepCounter: CGFloat,
                           waveDelta: CGFloat) -> UIBezierPath
}

extension WaveState {
    func midTransitionPath(state: TransitionPathState, frame: CGRect, maxY: CGFloat, stepCounter: CGFloat, waveDelta: CGFloat) -> UIBezierPath {
        let step: CGFloat = frame.width / stepCounter
        let controlDeltaX: CGFloat = frame.width / 10
        let controlDeltaY: CGFloat = frame.width / 50
        let maxY = maxY
        let minY = maxY - waveDelta
        let midAnchor = (maxY + minY) / 2
        
        let entity = TransitionPathEntity(state: state,
                                          frame: frame,
                                          step: step,
                                          firstAnchorDelta: maxY,
                                          secondAnchorDelta: minY,
                                          controlDeltaX: controlDeltaX,
                                          controlDeltaY: controlDeltaY,
                                          midleAnchor: midAnchor)
        
        return PathFactory.shared.getTransitionPath(pathEntity: entity)
    }
}

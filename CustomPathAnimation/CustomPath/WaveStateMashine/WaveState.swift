//
//  WaveState.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

protocol WaveState {
    func getMainShape(initEntity: StateInitEntity) -> UIBezierPath
    
    func midTransitionPath(state: TransitionPathState, initEntity: StateInitEntity) -> UIBezierPath
}

extension WaveState {
    func midTransitionPath(state: TransitionPathState, initEntity: StateInitEntity) -> UIBezierPath {
        let step: CGFloat = initEntity.frame.width / initEntity.stepCounter
        let controlDeltaX: CGFloat = initEntity.frame.width / 10
        let controlDeltaY: CGFloat = initEntity.frame.width / 50
        let maxY = initEntity.maxY
        let minY = initEntity.maxY - initEntity.waveDelta
        let midAnchor = (maxY + minY) / 2
        
        let entity = TransitionPathEntity(state: state,
                                          frame: initEntity.frame,
                                          step: step,
                                          firstAnchorDelta: maxY,
                                          secondAnchorDelta: minY,
                                          controlDeltaX: controlDeltaX,
                                          controlDeltaY: controlDeltaY,
                                          midleAnchor: midAnchor)
        
        return initEntity.pathFactory.getTransitionPath(pathEntity: entity)
    }
}

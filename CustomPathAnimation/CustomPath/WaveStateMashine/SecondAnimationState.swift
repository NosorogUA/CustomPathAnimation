//
//  SecondAnimationState.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

class SecondAnimationState: WaveState {
    
    func getMainShape(initEntity: StateInitEntity) -> UIBezierPath {
        
        let step: CGFloat = initEntity.frame.width / initEntity.stepCounter
        let maxY: CGFloat = initEntity.maxY
        let minY: CGFloat = initEntity.maxY - initEntity.waveDelta
        let midAnchor: CGFloat = (maxY + minY) / 2
        let controlDeltaX: CGFloat = initEntity.frame.width / 10
        
        
        let entity = MainPathEntity(frame: initEntity.frame,
                                    step: step,
                                    firstAnchorDelta: minY,
                                    secondAnchorDelta: maxY,
                                    midleAnchor: midAnchor,
                                    controlDeltaX: controlDeltaX)
        
        return initEntity.pathFactory.getMainShape(entity)
    }
}

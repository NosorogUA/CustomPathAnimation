//
//  FlashAnimationState.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

class FlashAnimationState: WaveState {
    
    func getMainShape(initEntity: StateInitEntity) -> UIBezierPath {
        let step: CGFloat = initEntity.frame.width / initEntity.stepCounter
        let maxY = initEntity.frame.height
        let minY = initEntity.frame.height
        let midAnchor: CGFloat = initEntity.frame.height
        let controlDeltaX: CGFloat = initEntity.frame.width / 10
        
        let entity = MainPathEntity(frame: initEntity.frame,
                                    step: step,
                                    firstAnchorDelta: maxY,
                                    secondAnchorDelta: minY,
                                    midleAnchor: midAnchor,
                                    controlDeltaX: controlDeltaX)
        
        return initEntity.pathFactory.getMainShape(entity)
    }
}

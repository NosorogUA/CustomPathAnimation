//
//  FlashAnimationState.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

class FlashAnimationState: WaveState {
    
    func getMainShape(frame: CGRect, maxY: CGFloat, stepCounter: CGFloat, waveDelta: CGFloat) -> UIBezierPath {
        let step: CGFloat = frame.width / stepCounter
        let maxY = frame.height
        let minY = frame.height
        let midAnchor: CGFloat = frame.height
        let controlDeltaX: CGFloat = frame.width / 10
        
        let entity = MainPathEntity(frame: frame,
                                    step: step,
                                    firstAnchorDelta: maxY,
                                    secondAnchorDelta: minY,
                                    midleAnchor: midAnchor,
                                    controlDeltaX: controlDeltaX)
        
        return PathFactory.shared.getMainShape(entity)
    }
}

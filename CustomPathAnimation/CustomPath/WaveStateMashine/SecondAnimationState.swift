//
//  SecondAnimationState.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

class SecondAnimationState: WaveState {
    private let pathFactory = PathFactory()
    
    func getMainShape(frame:CGRect, maxY: CGFloat, stepCounter: CGFloat, waveDelta: CGFloat) -> UIBezierPath {
        
    let step: CGFloat =  frame.width / stepCounter
    let maxY: CGFloat = maxY
    let minY: CGFloat = maxY - waveDelta
    let midAnchor: CGFloat = (maxY + minY) / 2
    let controlDeltaX: CGFloat = frame.width / 10
        
    
        let entity = MainPathEntity(frame: frame,
                                    step: step,
                                    firstAnchorDelta: minY,
                                    secondAnchorDelta: maxY,
                                    midleAnchor: midAnchor,
                                    controlDeltaX: controlDeltaX)
        
        return pathFactory.getMainShape(entity)
    }
}

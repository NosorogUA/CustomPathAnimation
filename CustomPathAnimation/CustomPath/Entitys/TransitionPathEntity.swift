//
//  TransitionPathEntity.swift
//  CustomPathAnimation
//
//  Created by mac on 5/11/23.
//

import Foundation

struct TransitionPathEntity {
    let state: TransitionPathState
    let frame: CGRect
    let step: CGFloat
    let firstAnchorDelta: CGFloat
    let secondAnchorDelta: CGFloat
    let controlDeltaX: CGFloat
    let controlDeltaY: CGFloat
    let midleAnchor: CGFloat
}

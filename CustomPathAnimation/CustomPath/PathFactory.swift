//
//  PathFactory.swift
//  CustomPathAnimation
//
//  Created by mac on 5/10/23.
//

import UIKit

enum TransitionPathState {
    case mid1, mid2
}

struct PathFactory {
    static let shared = PathFactory()
    
    func getMainShape(_ pathEntity: MainPathEntity) -> UIBezierPath {
        
        let path = UIBezierPath()
        
        // wave points from right to left
        let point1: CGPoint = CGPoint(x: pathEntity.frame.maxX,
                                      y: pathEntity.frame.minY + pathEntity.midleAnchor)
        let point2: CGPoint = CGPoint(x: pathEntity.frame.maxX - pathEntity.step,
                                      y: pathEntity.frame.minY + pathEntity.firstAnchorDelta)
        let point3: CGPoint = CGPoint(x: pathEntity.frame.maxX - pathEntity.step * 2,
                                      y: pathEntity.frame.minY + pathEntity.secondAnchorDelta)
        let point4: CGPoint = CGPoint(x: pathEntity.frame.maxX - pathEntity.step * 3,
                                      y: pathEntity.frame.minY + pathEntity.firstAnchorDelta)
        let point5: CGPoint = CGPoint(x: pathEntity.frame.maxX - pathEntity.step * 4,
                                      y: pathEntity.frame.minY + pathEntity.secondAnchorDelta)
        
        path.move(to: CGPoint(x: pathEntity.frame.minX,
                              y: pathEntity.frame.minY))
        path.addLine(to: CGPoint(x: pathEntity.frame.maxX,
                                 y: pathEntity.frame.minY))
        path.addLine(to: point1)
        path.addCurve(to: point2,
                      controlPoint1: CGPoint(x: point1.x - pathEntity.controlDeltaX,
                                             y: point1.y),
                      controlPoint2: CGPoint(x: point2.x + pathEntity.controlDeltaX,
                                             y: point2.y))
        path.addCurve(to: point3,
                      controlPoint1: CGPoint(x: point2.x - pathEntity.controlDeltaX,
                                             y: point2.y),
                      controlPoint2: CGPoint(x: point3.x + pathEntity.controlDeltaX,
                                             y: point3.y))
        path.addCurve(to: point4,
                      controlPoint1: CGPoint(x: point3.x - pathEntity.controlDeltaX,
                                             y: point3.y),
                      controlPoint2: CGPoint(x: point4.x + pathEntity.controlDeltaX,
                                             y: point4.y))
        path.addCurve(to: point5,
                      controlPoint1: CGPoint(x: point4.x - pathEntity.controlDeltaX,
                                             y: point4.y),
                      controlPoint2: CGPoint(x: point5.x + pathEntity.controlDeltaX,
                                             y: point5.y))
        return path
    }
    
    func getTransitionPath(pathEntity: TransitionPathEntity) -> UIBezierPath {
        let path = UIBezierPath()
        // wave points from right to left
        let point1: CGPoint =  CGPoint(x: pathEntity.frame.maxX,
                                       y: pathEntity.frame.minY + pathEntity.midleAnchor)
        let point2: CGPoint =  CGPoint(x: pathEntity.frame.maxX - pathEntity.step,
                                       y: pathEntity.frame.minY + pathEntity.midleAnchor)
        let point3: CGPoint =  CGPoint(x: pathEntity.frame.maxX - pathEntity.step * 2,
                                       y: pathEntity.frame.minY + pathEntity.midleAnchor)
        let point4: CGPoint =  CGPoint(x: pathEntity.frame.maxX - pathEntity.step * 3,
                                       y: pathEntity.frame.minY + pathEntity.midleAnchor)
        let point5: CGPoint =  CGPoint(x: pathEntity.frame.maxX - pathEntity.step * 4,
                                       y: pathEntity.frame.minY + pathEntity.midleAnchor)
        path.move(to: CGPoint(x: pathEntity.frame.minX,
                              y: pathEntity.frame.minY))
        path.addLine(to: CGPoint(x: pathEntity.frame.maxX,
                                 y: pathEntity.frame.minY))
        path.addLine(to: point1)
        
        switch pathEntity.state {
        case .mid1:
            path.addCurve(to: point2,
                          controlPoint1: CGPoint(x: point1.x,
                                                 y: point1.y),
                          controlPoint2: CGPoint(x: point2.x + pathEntity.controlDeltaX,
                                                 y: point2.y + pathEntity.controlDeltaY))
            path.addCurve(to: point3,
                          controlPoint1: CGPoint(x: point2.x - pathEntity.controlDeltaX,
                                                 y: point2.y - pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point3.x + pathEntity.controlDeltaX,
                                                 y: point3.y - pathEntity.controlDeltaY))
            path.addCurve(to: point4,
                          controlPoint1: CGPoint(x: point3.x - pathEntity.controlDeltaX,
                                                 y: point3.y + pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point4.x + pathEntity.controlDeltaX,
                                                 y: point4.y + pathEntity.controlDeltaY))
            path.addCurve(to: point5,
                          controlPoint1: CGPoint(x: point4.x - pathEntity.controlDeltaX,
                                                 y: point4.y - pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point5.x + pathEntity.controlDeltaX,
                                                 y: point5.y))
        case .mid2:
            path.addCurve(to: point2,
                          controlPoint1: CGPoint(x: point1.x - pathEntity.controlDeltaX,
                                                 y: point1.y - pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point2.x + pathEntity.controlDeltaX,
                                                 y: point2.y - pathEntity.controlDeltaY))
            path.addCurve(to: point3,
                          controlPoint1: CGPoint(x: point2.x - pathEntity.controlDeltaX,
                                                 y: point2.y + pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point3.x + pathEntity.controlDeltaX,
                                                 y: point3.y + pathEntity.controlDeltaY))
            path.addCurve(to: point4,
                          controlPoint1: CGPoint(x: point3.x - pathEntity.controlDeltaX,
                                                 y: point3.y - pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point4.x + pathEntity.controlDeltaX,
                                                 y: point4.y - pathEntity.controlDeltaY))
            path.addCurve(to: point5,
                          controlPoint1: CGPoint(x: point4.x - pathEntity.controlDeltaX,
                                                 y: point4.y + pathEntity.controlDeltaY),
                          controlPoint2: CGPoint(x: point5.x + pathEntity.controlDeltaX,
                                                 y: point5.y + pathEntity.controlDeltaY))
        }
        
        return path
    }
}

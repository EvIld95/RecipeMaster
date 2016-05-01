//
//  PlusButton.swift
//  MoodUpLabs
//
//  Created by Pawel Szudrowicz on 28.04.2016.
//  Copyright © 2016 Pawel Szudrowicz. All rights reserved.
//

import UIKit

@IBDesignable
class PlusButton: UIButton {

    @IBInspectable var buttonBackgroundColor: UIColor = UIColor.yellowColor()
    @IBInspectable var plusSignColor: UIColor = UIColor.whiteColor()
    @IBInspectable var plusHeight: CGFloat = 3.0
    
    override func drawRect(rect: CGRect) {
        //default bounds is equal to 80x80
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.5
        let path = UIBezierPath(ovalInRect: rect)
        buttonBackgroundColor.setFill()
        path.fill()
        
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - plusWidth/2 + 0.5))
        
        
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + plusWidth/2 + 0.5))
        
        plusSignColor.setStroke()
        plusPath.stroke()
        
    }
    
}

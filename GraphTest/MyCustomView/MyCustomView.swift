//
//  MyCustomView.swift
//  GraphTest
//
//  Created by PanaCloud on 6/23/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

@IBDesignable class MyCustomView: UIView {
    
    var graphPoints:[Int] = [4,6,7,10,8,4,11,5,1,1,1,5,5,6,7,9,8,11]
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet{
            layer.borderColor =  borderColor.CGColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    
    
    
    override func drawRect(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()

        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations:[CGFloat] = [0.0,1.0]
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
        
        
        //To calculate x coordinate
        
        let margin:CGFloat = 20
        var columnXPoint = {(column:Int)->CGFloat in
            let space = (width-margin*2-4)/CGFloat((self.graphPoints.count-1))
            var x:CGFloat = CGFloat(column)*space
            x += margin + 2
            return x
        }
        //To calculate y coordinate
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder
        let maxValue = maxElement(graphPoints)
        var columnYPoint = {(graphPoint:Int)->CGFloat in
            var y:CGFloat = CGFloat(graphPoint)/CGFloat(maxValue)*graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        //Draw the line
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //set up the points line
        var graphPath = UIBezierPath()
        //go to start of the line
        graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        //add points for each item in the graphPoints array
        //at the crrect (x,y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        graphPath.stroke()
        
        CGContextSaveGState(context)
        var clippingPath = graphPath.copy() as UIBezierPath
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(graphPoints.count-1), y: height))
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(0), y: height))
        clippingPath.closePath()
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x: margin, y: highestYPoint)
        endPoint = CGPoint(x: margin, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        CGContextRestoreGState(context)
        
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= 2.5
            point.y -= 2.5
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        var linePath = UIBezierPath()
        
        for i in 0..<graphPoints.count{
            linePath.moveToPoint(CGPoint(x:columnXPoint(i), y: 0))
            linePath.addLineToPoint(CGPoint(x:columnXPoint(i), y: height))
            let color = UIColor(white: 1.0, alpha: 0.1)
            color.setStroke()
            linePath.lineWidth = 1.0
            linePath.stroke()
        }

//
//        //Draw horizontal graph lines on the top of everything
//        var linePath = UIBezierPath()
//        
//        //top line
//        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
//        linePath.addLineToPoint(CGPoint(x: width - margin,
//            y:topBorder))
//        
//        //center line
//        linePath.moveToPoint(CGPoint(x:margin,
//            y: graphHeight/2 + topBorder))
//        linePath.addLineToPoint(CGPoint(x:width - margin,
//            y:graphHeight/2 + topBorder))
//        
//        //bottom line
//        linePath.moveToPoint(CGPoint(x:margin,
//            y:height - bottomBorder))
//        linePath.addLineToPoint(CGPoint(x:width - margin,
//            y:height - bottomBorder))
//        let color = UIColor(white: 1.0, alpha: 0.3)
//        color.setStroke()
//        
//        linePath.lineWidth = 1.0
//        linePath.stroke()
    }

}



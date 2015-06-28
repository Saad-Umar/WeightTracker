//
//  GraphView.swift
//  GraphTest
//
//  Created by PanaCloud on 6/24/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    var graphPoints:[Int] = [1,2,3,2,0,5,1,2,3,2,0,5,1,2,3,2,0,5,1,2,3,2,0,5,1,2,3,2,0,5,1,2]
    
    
    
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
    
    var numberOfDivisions: Int {
        get {
            return 4 //dayMap.keys.array.count
        }
    }
    
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    override func drawRect(rect: CGRect) {
   
        
        print(numberOfDivisions)
        let width = rect.width
        let height = rect.height
        
        //To make the corners of the rect rounded
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
        
        let margin:CGFloat = 80
        var columnXPoint = {(column:Int)->CGFloat in
            let space = (width-margin*2-4)/30
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
            //If the weight for the given day is null
            if graphPoints[i] == 0 {
                continue
            }
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        let animatedPath = CAShapeLayer()
        animatedPath.path = graphPath.CGPath
        animatedPath.strokeColor = UIColor.whiteColor().CGColor
        animatedPath.fillColor = UIColor.clearColor().CGColor
        animatedPath.lineWidth = 2.0
        animatedPath.lineCap = kCALineCapRound
        self.layer.addSublayer(animatedPath)
        
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 10.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        animatedPath.addAnimation(animateStrokeEnd, forKey: nil)
        var clippingPath = graphPath.copy() as UIBezierPath
        graphPath.removeAllPoints()
        graphPath.stroke()
        
        //To save the unclipped state
        CGContextSaveGState(context)
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
        
        //Restoring to unclipped state
        CGContextRestoreGState(context)
        
        //To draw the rounded tips
        for i in 0..<graphPoints.count {
            //If the weight for the given day is null
            if graphPoints[i] == 0 {
                continue
            }
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= 2.5
            point.y -= 2.5
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            let animatedPoints = CAShapeLayer()
            animatedPoints.path = circle.CGPath
            animatedPoints.strokeColor = UIColor.whiteColor().CGColor
            animatedPoints.fillColor = UIColor.whiteColor().CGColor
            animatedPoints.lineWidth = 0.5
            animatedPoints.lineCap = kCALineCapRound
            self.layer.insertSublayer(animatedPoints, above: animatedPath)
            
            let animateStrokeEnd1 = CABasicAnimation(keyPath: "strokeEnd")
            animateStrokeEnd1.duration = 5.0
            animateStrokeEnd1.fromValue = 0.0
            animateStrokeEnd1.toValue = 1.0
            animatedPath.addAnimation(animateStrokeEnd1, forKey: nil)
            //circle.fill()
        }
        var linePath = UIBezierPath()
        
        //To draw vertical divisions
        for i in 0..<numberOfDivisions {
            linePath.moveToPoint(CGPoint(x:(CGFloat(i) * (width/CGFloat(numberOfDivisions+2)))+80, y: 0))
            linePath.addLineToPoint(CGPoint(x:(CGFloat(i) * (width/CGFloat(numberOfDivisions+2)))+80, y: height-25))
            let color = UIColor(white: 1.0, alpha: 0.4)
            color.setStroke()
            linePath.lineWidth = 1.0
            linePath.stroke()
        }
        
        //To draw horizontal divisions
        for i in 0...12 {
            linePath.moveToPoint(CGPoint(x: 80 , y: height - 25 - CGFloat(i*26)))
            linePath.addLineToPoint(CGPoint(x:width, y: height - 25 - CGFloat(i*26)))
            let color = UIColor(white: 1.0, alpha: 0.4)
            color.setStroke()
            linePath.lineWidth = 1.0
            linePath.stroke()
        }
        
 


 
    }
}


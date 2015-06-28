//
//  ViewController.swift
//  GraphTest
//
//  Created by PanaCloud on 6/23/15.
//  Copyright (c) 2015 PanaCloud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var graphView: GraphView!
    @IBOutlet var weight: [UILabel]!
    
    var upperBound:Int = 60
    var lowerBound:Int = 58
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(NSDate())
        setupYaxis()
        drawSomething()
        //graphView.dayMap = [1:[1,2,3]]
        //graphView.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refresh(sender: AnyObject) {
        graphView.setNeedsDisplay()
    }
    
    func setupYaxis() {
        let range = upperBound - lowerBound
        let division:Float = Float(range) / 10
        for i in 0...10 {
            weight[i].text = "\((Float(i) * division)+Float(lowerBound))"
        }
    }
    func drawSomething() {

    }

}


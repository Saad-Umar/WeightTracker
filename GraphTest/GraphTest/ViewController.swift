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

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        println(NSDate())
        //graphView.dayMap = [1:[1,2,3]]
        //graphView.setNeedsDisplay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


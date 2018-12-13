//
//  ViewController.swift
//  ChatBot2018
//
//  Created by Samuel Downs on 12/11/18.
//  Copyright © 2018 Samuel Downs. All rights reserved.
//

import UIKit

//  Global definition
let TAP_OFF_DELAY = 0.6
let OFFER_DELAY = 1.0


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //  TRICK: Control the hidding of the StatusBar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Causes the OS to hide the Home Indicator (bottom)
    // after some delay - defined by OS
    //  TRICK: Control the hidding of the HomeInicator
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    



}


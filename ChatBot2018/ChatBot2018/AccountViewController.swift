//
//  AccountViewController.swift
//  ChatBot2018
//
//  Created by Samuel Downs on 12/11/18.
//  Copyright © 2018 Samuel Downs. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var offerView: UIView!
    
    
    
    var offerTimer : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        //  Reset the offer view - off screen
        var frame = offerView.frame
        
        frame.origin.y = -frame.size.height
        offerView.frame = frame
        
        offerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
            self.moveOffer(moveIn: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        offerTimer?.invalidate()
    }
    
    func moveOffer(moveIn:Bool) {
        //  Annimate the offer panel in or out

        let targetY = moveIn == true ? 0.0 : -offerView.frame.size.height
        
        var frame = offerView.frame
        frame.origin.y = targetY
        

        
        UIView.animate(withDuration: 1.0, animations:  {
            self.offerView.frame = frame
            })
    }

}

//
//  ProductViewController.swift
//  ChatBot2018
//
//  Created by Sam Downs on 12/12/18.
//  Copyright © 2018 Samuel Downs. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var offerView: UIView!

    @IBOutlet weak var questionField: UITextField!

    var offerTimer : Timer?

    var tapOffActive = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        questionField.delegate = self
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  Reset the offer view - off screen
        var frame = offerView.frame

        frame.origin.y = -frame.size.height
        offerView.frame = frame

        offerTimer = Timer.scheduledTimer(withTimeInterval: OFFER_DELAY, repeats: false) { timer in
            self.moveOffer(moveIn: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        offerTimer?.invalidate()
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


    // MARK: - Tap off support

    @IBAction func didTapOff(_ sender: Any) {
        moveOffer(moveIn: false)

        Timer.scheduledTimer(withTimeInterval: TAP_OFF_DELAY, repeats: false) { timer in
            self.tapOffActive = true
            self.hideKeyboard()
            self.dismiss(animated: true, completion: nil)
        }
    }

    //  MARK:  - Panel item support

    func moveOffer(moveIn:Bool) {
        //  Annimate the offer panel in or out
        let targetY = moveIn == true ? 0.0 : -offerView.frame.size.height

        var frame = offerView.frame
        frame.origin.y = targetY

        UIView.animate(withDuration: 0.50, animations:  {
            self.offerView.frame = frame
        })
    }

    @IBAction func didPressOfferButton( _ sender: UIButton) {
        startBotWith(text: sender.titleLabel!.text!)
    }

    //  MARK: - Text Entry Support

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //  Cause end of editing
        hideKeyboard()
        return true
    }

    func textFieldDidBeginEditing(_ textField:UITextField) {
        //print("Did start editing")
    }

    func textFieldDidEndEditing(_ textField:UITextField) {
        if tapOffActive {
            return
        }

        let value = questionField?.text ?? "Unknown"
        //print("did end editing: \(value)")

        startBotWith(text: value)
    }

    func hideKeyboard() {
        questionField?.resignFirstResponder()
    }

    //  MARK: - Bot Start processing

    func startBotWith(text:String) {
        //  Using the string - start the bot processing

        print("startBot : \(text)")

        //  TODO:  How to pass information to the botChatVC?

        if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "BotChatViewController") {
            presentedViewController.providesPresentationContextTransitionStyle = true
            presentedViewController.definesPresentationContext = true
            presentedViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
            presentedViewController.modalTransitionStyle = .crossDissolve

            let controller = presentedViewController as! BotChatViewController

            controller.assignIntent(intent: text)

            self.present(presentedViewController, animated: true, completion: nil)
        }
    }

}

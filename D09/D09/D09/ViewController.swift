//
//  ViewController.swift
//  D09
//
//  Created by Antoine JOUANNAIS on 4/15/17.
//  Copyright © 2017 Antoine JOUANNAIS. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    let context = LAContext()
    let kMsgShowFinger = "Show me your finger 👍"
    let kMsgShowReason = "🌛 You need to authenticate, baby 🌜"
    let kMsgFingerOK = "Login successful! ✅"
    
 
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var err: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &err) else {
                // Print the localized message received by the system
                message.text = err?.localizedDescription
                return
        }
        self.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: kMsgShowReason) {
            success, error in
            DispatchQueue.main.async { // necessaire pour affichage dans le main thread
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.message.text = "There was a problem verifying your identity."
                    case LAError.userCancel:
                        self.message.text = "Authentication was canceled by user."
                        // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        self.message.text = "The user tapped the fallback button (Fuu!)"
                    case LAError.systemCancel:
                        self.message.text = "Authentication was canceled by system."
                    case LAError.passcodeNotSet:
                        self.message.text = "Passcode is not set on the device."
                    case LAError.touchIDNotAvailable:
                        self.message.text = "Touch ID is not available on the device."
                    case LAError.touchIDNotEnrolled:
                        self.message.text = "Touch ID has no enrolled fingers."
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        self.message.text = "There were too many failed Touch ID attempts and Touch ID is now locked."
                    case LAError.appCancel:
                        self.message.text = "Authentication was canceled by application."
                    case LAError.invalidContext:
                        self.message.text = "LAContext passed to this call has been previously invalidated."
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        self.message.text = "Touch ID may not be configured"
                        break
                    }
                    return
                }
                // Good news! Everything went fine 👏
                self.message.text = self.kMsgFingerOK
                self.performSegue(withIdentifier: "SegueToSecond", sender: self)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showUnexpectedErrorMessage() {
        message.text = "Unexpected error! 😱"
    }

}


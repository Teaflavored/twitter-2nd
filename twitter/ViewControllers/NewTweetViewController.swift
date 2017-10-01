//
//  NewTweetViewController.swift
//  twitter
//
//  Created by Auster Chen on 10/1/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserHandleLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var charactersRemainingLabel: UILabel!
    @IBOutlet weak var viewToBottomConstraint: NSLayoutConstraint!
    
    let maxCharacters = 140
    var status: String?
    var charactersRemainingString: String? {
        get {
            if let status = status {
                return "\(maxCharacters - status.characters.count) characters remaining"
            }

            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWithCurrentUserInfo()
        statusTextView.becomeFirstResponder()
        status = ""
        charactersRemainingLabel.text = charactersRemainingString!

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancel(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onPost(_ sender: Any) {
        TwitterClient.instance.postStatus(
            status!,
            success: {
                () -> () in
                self.navigationController?.dismiss(animated: true, completion: nil)
            },
            failure: {
                (error: Error) in
            }
        )
    }

    func textViewDidChange(_ textView: UITextView) {
        status = textView.text
        charactersRemainingLabel.text = charactersRemainingString
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.characters.count < maxCharacters;
    }

    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        viewToBottomConstraint.constant = 8
    }
    
    @objc fileprivate func keyboardWillChangeFrame(_ notification: Notification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let animationDuration  = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let animationCurveRawNSN = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
        viewToBottomConstraint.constant = keyboardSize.height + 8
        UIView.animate(
            withDuration: TimeInterval(truncating: animationDuration),
            delay: 0,
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }

    fileprivate func updateWithCurrentUserInfo() {
        let user = User.currentUser!
        
        if let profileUrl = user.profileUrl {
            currentUserProfileImageView.setImageWith(profileUrl)
        }

        if let handle = user.twitterHandle {
            currentUserHandleLabel.text = handle
        }

        if let name = user.name {
            currentUserNameLabel.text = name
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

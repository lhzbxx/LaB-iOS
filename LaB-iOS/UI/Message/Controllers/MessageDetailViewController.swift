//
//  ChatViewController.swift
//  LaB-iOS
//
//  Created by 鲁浩 on 16/9/6.
//  Copyright © 2016年 鲁浩. All rights reserved.
//

import UIKit
import IBAnimatable
import Spring
import SnapKit

class MessageDetailViewController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var typeView: UIView!
    
    @IBOutlet weak var functionalButton: AnimatableButton!
    
    @IBOutlet weak var sendButton: AnimatableButton!
    
    @IBOutlet weak var typeField: UITextField!
    
    @IBOutlet weak var functionalView: UIStackView!
    
    @IBAction func typing(sender: AnyObject) {
        if (typeField.text == "" && functionalButton.hidden) {
            sendButton.zoomOut()
            functionalButton.zoomIn()
            functionalButton.hidden = false
        }
        if (typeField.text != "" && !functionalButton.hidden){
            sendButton.zoomIn()
            functionalButton.zoomOut()
            functionalButton.hidden = true
        }
    }
    
    var isFunctionalViewOpened: Bool = false
    
    var keyboardHeight: CGFloat = 0 {
        didSet {
            self.typeView.snp_makeConstraints {
                make in
                make.height.equalTo(keyboardHeight + 66)
            }
            self.functionalView.snp_makeConstraints {
                make in
                make.height.equalTo(keyboardHeight)
            }
        }
    }
    
    @IBAction func functionalButtonClicked(sender: AnyObject) {
        dismissKeyboard()
        UIView.animateWithDuration(0.25, animations: {
            self.messagesTableView.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight)
            self.typeView.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MessageDetailViewController.dismissKeyboardAndFunctionalView))
        self.messagesTableView.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardAndFunctionalView() {
        if (isFunctionalViewOpened) {
            UIView.animateWithDuration(0.25, animations: {
                self.messagesTableView.transform = CGAffineTransformIdentity
                self.typeView.transform = CGAffineTransformIdentity
            })
        }
        isFunctionalViewOpened = false
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        isFunctionalViewOpened = true
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageDetailViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MessageDetailViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        // 键盘高度
        self.keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
        // 动画时长
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            self.messagesTableView.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight)
            self.typeView.transform = CGAffineTransformMakeTranslation(0, -self.keyboardHeight)
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (isFunctionalViewOpened) {
            return
        }
        let userInfo = notification.userInfo!
        // 动画时长
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations: (() -> Void) = {
            self.messagesTableView.transform = CGAffineTransformIdentity
            self.typeView.transform = CGAffineTransformIdentity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

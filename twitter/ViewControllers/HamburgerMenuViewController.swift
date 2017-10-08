

//
//  HamburgerMenuViewController.swift
//  twitter
//
//  Created by Auster Chen on 10/7/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class HamburgerMenuViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {
        didSet(oldViewController) {
            view.layoutIfNeeded()

            if oldViewController != nil {
                oldViewController.willMove(toParentViewController: nil)
                oldViewController.removeFromParentViewController()
                oldViewController.didMove(toParentViewController: nil)
            }

            menuViewController.willMove(toParentViewController: self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMove(toParentViewController: self)
        }
    }
    var contentViewController: UIViewController! {
        didSet(oldViewController) {
            view.layoutIfNeeded()

            if oldViewController != nil {
                oldViewController.willMove(toParentViewController: nil)
                oldViewController.removeFromParentViewController()
                oldViewController.didMove(toParentViewController: nil)
            }

            contentViewController.willMove(toParentViewController: self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMove(toParentViewController: self)

            closeMenu()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if (menuViewController == nil) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            
            menuViewController.hamburgerMenuViewController = self
            self.menuViewController = menuViewController
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanContent(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = leftMarginConstraint.constant
        } else if sender.state == .changed {
            leftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == .ended {
            if velocity.x > 0 {
                openMenu()
            } else {
                closeMenu()
            }
        }
    }

    fileprivate func closeMenu() -> () {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
            self.leftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
        
    fileprivate func openMenu() -> () {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: [], animations: {
            self.leftMarginConstraint.constant = self.view.frame.size.width - 100
            self.view.layoutIfNeeded()
        }, completion: nil)
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

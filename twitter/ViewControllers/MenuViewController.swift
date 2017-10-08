//
//  MenuViewController.swift
//  twitter
//
//  Created by Auster Chen on 10/7/17.
//  Copyright © 2017 Auster Chen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var menuTableView: UITableView!

    var menuItems: [String] = ["Profile", "Timeline", "Mentions"]
    var menuViewControllers: [Any] = []
    var hamburgerMenuViewController: HamburgerMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        let timelineViewController = storyboard.instantiateViewController(withIdentifier: "TimelineNavigationController")
        
        menuViewControllers.append(profileViewController)
        menuViewControllers.append(timelineViewController)

        hamburgerMenuViewController.contentViewController = timelineViewController
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuViewControllers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = menuTableView.dequeueReusableCell(withIdentifier: "menuCell") else {
            return MenuCell()
        }
        let menuCell = cell as! MenuCell
        let menuItemLabel = menuItems[indexPath.row]

        menuCell.menuTitle.text = menuItemLabel

        return menuCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerMenuViewController.contentViewController = menuViewControllers[indexPath.row] as! UIViewController
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

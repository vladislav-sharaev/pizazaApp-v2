//
//  ReachabilityViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/9/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class ReachabilityViewController: UIViewController {
    
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton.setTitle(R.string.localizable.refreshBtn(), for: .normal)
    }
    
    @IBAction func refresh(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

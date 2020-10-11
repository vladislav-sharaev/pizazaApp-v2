//
//  OrderDetailViewController.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 10/7/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    var order: Order!
    
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var telephoneTxt: UILabel!
    @IBOutlet weak var addressTxt: UILabel!
    @IBOutlet weak var roomTxt: UILabel!
    @IBOutlet weak var porchTxt: UILabel!
    @IBOutlet weak var floorTxt: UILabel!
    @IBOutlet weak var codeTxt: UILabel!
    @IBOutlet weak var orderTimeTxt: UILabel!
    @IBOutlet weak var orderOnTimeTxt: UILabel!
    @IBOutlet weak var finalCostTxt: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var porchLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderOnTimeLabel: UILabel!
    @IBOutlet weak var finalCostLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLocalization()
        config()
    }
    
    @IBAction func moreBtnAction(_ sender: UIButton) {
        guard let vc = R.storyboard.simple.moreOrderDetailViewController() else { return }
        vc.order = order
        self.present(vc, animated: true, completion: nil)
    }
    
    func configLocalization() {
        let colon = ":"
        
        title = R.string.localizable.orderDetailTitle()
        nameTxt.text = R.string.localizable.nameTFPlaceholder() + colon
        telephoneTxt.text = R.string.localizable.telephoneTFPlaceholder() + colon
        addressTxt.text = R.string.localizable.addressPlaceholder() + colon
        roomTxt.text = R.string.localizable.roomPlaceholder() + colon
        porchTxt.text = R.string.localizable.porchPlaceholder() + colon
        floorTxt.text = R.string.localizable.floorPlaceholder() + colon
        codeTxt.text = R.string.localizable.intercomePlaceholder() + colon
        orderTimeTxt.text = R.string.localizable.orderTimeTxt() + colon
        orderOnTimeTxt.text = R.string.localizable.orderOnTimeTxt() + colon
        finalCostTxt.text = R.string.localizable.finalCostTxt() + colon
        moreBtn.setTitle(R.string.localizable.moreBtn(), for: .normal)
    }
    
    func config() {
        nameLabel.text = order.name
        telephoneLabel.text = order.telephone
        addressLabel.text = order.address
        roomLabel.text = order.room
        porchLabel.text = order.porch
        floorLabel.text = order.floor
        codeLabel.text = order.code
        orderTimeLabel.text = order.date
        orderOnTimeLabel.text = order.onDate
        finalCostLabel.text = String(order.finalCost) + " " + R.string.localizable.br()
    }
}

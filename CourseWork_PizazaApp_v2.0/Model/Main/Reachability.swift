//
//  Reachability.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/9/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
        } ) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) { return false }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    class func showNoneConnectionVC(on otherVC: UIViewController) {
        if !Reachability.isConnectedToNetwork() {
            guard let vc = R.storyboard.main.reachabilityViewController() else { return }
            vc.modalPresentationStyle = .fullScreen
            otherVC.present(vc, animated: true, completion: nil)
        }
    }
}

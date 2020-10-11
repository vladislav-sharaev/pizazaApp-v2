//
//  DoubleExtension.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/30/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

extension Double {
    func rounded(place: Int) -> Double {
        let divisor = pow(10.0, Double(place))
        return (self * divisor).rounded() / divisor
    }
}

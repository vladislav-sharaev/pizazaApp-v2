//
//  NetworkError.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/20/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

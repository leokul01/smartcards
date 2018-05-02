//
//  Set.swift
//  SmartCards
//
//  Created by LEONID KULIKOV on 25/04/2018.
//  Copyright © 2018 LEONID KULIKOV. All rights reserved.
//

import UIKit

struct SmartSet {
    var cover: UIImage?
    var name: String = ""
    var description: String = ""
//    var words: [String : String] = [String : String]()
    var words: [(knowledge: Double, front: String, back: String)] = [(knowledge: Double, front: String, back: String)]()
}

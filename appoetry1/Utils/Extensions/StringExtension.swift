//
//  StringExtension.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 16.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Foundation

public extension String {
    static func className(_ cls: AnyClass) -> String {
        return String(describing:cls).components(separatedBy: ".").last!
    }
}

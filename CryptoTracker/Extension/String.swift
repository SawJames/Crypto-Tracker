//
//  String.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 20/09/2021.
//

import Foundation

extension String {
    var removingHTMLOccurences : String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

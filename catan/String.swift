//
//  String.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

extension String {
    func strip() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isBlank() -> Bool {
        return strip().isEmpty
    }
    
    func isPresent() -> Bool {
        return !isBlank()
    }
}

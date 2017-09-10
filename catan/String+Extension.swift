//
//  String+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 10..
//  Copyright © 2017년 Parti. All rights reserved.
//

extension String {
    init(value: Int, max: Int) {
        if value >= max {
            self.init()
            self = "\(max)+"
        } else { self.init(value) }
    }
}

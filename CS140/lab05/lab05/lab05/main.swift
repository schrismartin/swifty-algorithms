#!/usr/bin/swift

//
//  main.swift
//  lab05
//
//  Created by Chris Martin on 9/2/16.
//  Copyright © 2016 Chris Martin. All rights reserved.
//

import Foundation

class MainApplication {
    
    init(args: [String]?) {
        
        var ounces = 0
        
        while let line = readLine() {
            ounces += value(of: line)
        }
        
        print(ounces)
    }
    
    func value(of string: String) -> Int {
        return string.unicodeScalars
                .map { ["-", "."].contains($0) ? 0 : modify(num: $0.value) }
                .reduce(0, +)
    }
    
    func modify(num: UInt32) -> Int {
        let base = Int(UnicodeScalar("A")!.value)
        return Int(num) - base + 1
    }
}

let args = Process().arguments
let application = MainApplication(args: args)

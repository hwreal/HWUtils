//
//  Bundle-Extension.swift
//  HWUtils
//
//  Created by hwreal on 2021/9/18.
//

import Foundation

public extension Bundle{
    func loadNib<T>(_ type: T.Type ) -> T?{
        if let arr = loadNibNamed("\(type)", owner: nil, options: nil) as? [T],
           let v = arr.first{
            return v
        }
        return nil
    }
}

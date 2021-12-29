//
//  CodableExtension.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/30.
//

import Foundation

extension Encodable {

    func convertToDict() -> [String: Any]? {
        var dict: [String: Any]? = nil
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        } catch {
            print(error)
        }
        return dict
    }

}

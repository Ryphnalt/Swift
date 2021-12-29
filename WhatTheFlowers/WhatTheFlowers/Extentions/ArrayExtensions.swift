//
//  ArrayExtensions.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/9.
//

import Foundation

extension Array {
    /// 陣列取值安全檢查，確認元素位置在陣列範圍內
    subscript(safe index: Int) -> Element? {
        return (index >= startIndex && index < endIndex) ? self[index] : nil
    }
}

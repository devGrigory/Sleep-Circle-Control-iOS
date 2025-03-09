//
//  Optional+Extension.swift
//  CircleControl
//
//  Created by Grigory G. on 10.07.22.
//

extension Optional where Wrapped == Time {
    func formattedTime(or defaultTime: String = "00:00") -> String {
        return self?.formattedTime() ?? defaultTime
    }
}

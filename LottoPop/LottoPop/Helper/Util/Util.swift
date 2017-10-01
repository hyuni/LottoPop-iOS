//
//  Util.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import Foundation

func prLog(_ message: Any? = "", showTime: Bool = false, file: String = #file, funcName: String = #function, line: Int = #line) {
    let fileName: String = (file as NSString).lastPathComponent
    var fullMessage = "\(fileName): \(funcName): \(line): \(String(describing: message))"
    
    if true == showTime {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy.MM.dd KK:mm:ss.SSS"
        let timeStr = dateFormatter.string(from: Date())
        fullMessage = "\(timeStr): " + fullMessage
    }
    
    print(fullMessage)
}

// MARK: - Base
class Util {
    enum NetworkType {
        case none
        case wifi
        case mobile
    }
}

// MARK: - String Function
extension Util {
    class func amountString(amount: Any?) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: amount)
    }
    
    class func localizedAmountString(amount: Any?) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(for: amount)
    }
}

// MARK: - Date Function
extension Util {
    class func latestDrwNumber(startDateString: String, dateFormat: String) -> Int {
        var latestNumber = 0
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = dateFormat
        if let startDate = formatter.date(from: startDateString) {
            var diffTime = startDate.timeIntervalSinceNow
            if 0 > diffTime {
                diffTime *= -1
            }
            if 0 != diffTime {
                latestNumber = Int(diffTime / (24*60*60) / 7)
            }
            latestNumber += 1
        }
        return latestNumber
    }
}


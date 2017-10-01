//
//  PLottoModel.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit
import CoreData

// MARK: - PLottoModel
class PLottoModel {
    internal let request = PrHttpRequest()
}

// MARK: - Function
extension PLottoModel {
    func getRecommendationNumbers() -> Array<Int> {
        // NOTE: This is a FAKE logic for open source, NOT Pranbi's logic.
        // You can create your own recommendation logic.
        
        var numbers = Array<Int>()
        for _ in 0..<2 {
            var number = 0
            repeat {
                number = Int(arc4random_uniform(7)) + 1
            } while true == numbers.contains(number)
            numbers.append(number)
        }
        numbers.sort()
        return numbers
    }
    
    func getWinResult(round: Int, success: ((Array<PLottoWinResult>?) -> Void)?, failure: ((String?) -> Void)?) {
        if let winResult = self.fetchPLottoWinResult(round: round) {
            success?(winResult)
        } else {
            self.request.getPLottoNumber(round: round, success: { (winResult) in
                success?(winResult)
            }) { (errMsg) in
                failure?(errMsg)
            }
        }
    }
    
    func getLatestWinResult(success: ((Array<PLottoWinResult>?) -> Void)?, failure: ((String?) -> Void)?) {
        let latestRound = Util.latestDrwNumber(startDateString: PLOTTO_START_DATE, dateFormat: "yyyy-MM-dd")
        if let winResult = self.fetchPLottoWinResult(round: latestRound) {
            success?(winResult)
        } else {
            self.request.getPLottoNumber(round: 0, success: { (winResult) in
                success?(winResult)
            }) { (errMsg) in
                if let winResult = self.fetchLatestPLottoWinResult() {
                    success?(winResult)
                } else {
                    failure?(errMsg)
                }
            }
        }
    }
}

// MARK: - Core Data
extension PLottoModel {
    func fetchPLottoWinResult() -> Array<PLottoWinResult>? {
        var winResultArr: Array<PLottoWinResult>? = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<PLottoWinResult>(entityName: "PLottoWinResult")
        do {
            winResultArr = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            prLog(error.localizedDescription)
        }
        return winResultArr
    }
    
    func fetchPLottoWinResult(round: Int) -> Array<PLottoWinResult>? {
        var winResult: Array<PLottoWinResult>? = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<PLottoWinResult>(entityName: "PLottoWinResult")
        fetchRequest.predicate = NSPredicate(format: "round == %@", argumentArray: [String(round)])
        fetchRequest.fetchLimit = 2
        do {
            let winResultArr = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            if 0 < winResultArr.count {
                winResult = winResultArr
            }
        } catch let error {
            prLog(error.localizedDescription)
        }
        return winResult
    }
    
    func fetchLatestPLottoWinResult() -> Array<PLottoWinResult>? {
        var winResult: Array<PLottoWinResult>? = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<PLottoWinResult>(entityName: "PLottoWinResult")
        fetchRequest.fetchLimit = 2
        do {
            let winResultArr = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            if 0 < winResultArr.count {
                winResult = winResultArr
            }
        } catch let error {
            prLog(error.localizedDescription)
        }
        return winResult
    }
    
    func save() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
}

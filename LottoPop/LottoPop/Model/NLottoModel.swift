//
//  NLottoModel.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit
import CoreData

// MARK: - NLottoModel
class NLottoModel {
    internal let request = PrHttpRequest()
}

// MARK: - Function
extension NLottoModel {
    func getRecommendationNumbers() -> Array<Int> {
        // NOTE: This is a FAKE logic for open source, NOT Pranbi's logic.
        // You can create your own recommendation logic.

        var numbers = Array<Int>()
        for _ in 0..<6 {
            var number = 0
            repeat {
                number = Int(arc4random_uniform(45)) + 1
            } while true == numbers.contains(number)
            numbers.append(number)
        }
        numbers.sort()
        return numbers
    }
    
    func getWinResult(drwNo: Int, success: ((NLottoWinResult?) -> Void)?, failure: ((String?) -> Void)?) {
        if let winResult = self.fetchNLottoWinResult(drwNo: drwNo) {
            success?(winResult)
        } else {
            self.request.getNLottoNumber(drwNo: drwNo, success: { (winResult) in
                success?(winResult)
            }) { (errMsg) in
                failure?(errMsg)
            }
        }
    }
    
    func getLatestWinResult(success: ((NLottoWinResult?) -> Void)?, failure: ((String?) -> Void)?) {
        let latestDrwNumber = Util.latestDrwNumber(startDateString: NLOTTO_START_DATE, dateFormat: "yyyy-MM-dd")
        if let winResult = self.fetchNLottoWinResult(drwNo: latestDrwNumber) {
            success?(winResult)
        } else {
            self.request.getNLottoNumber(drwNo: 0, success: { (winResult) in
                success?(winResult)
            }) { (errMsg) in
                if let winResult = self.fetchLatestNLottoWinResult() {
                    success?(winResult)
                } else {
                    failure?(errMsg)
                }
            }
        }
    }
}

// MARK: - Core Data
extension NLottoModel {
    func fetchNLottoWinResult() -> Array<NLottoWinResult>? {
        var winResultArr: Array<NLottoWinResult>? = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NLottoWinResult>(entityName: "NLottoWinResult")
        do {
            winResultArr = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            prLog(error.localizedDescription)
        }
        return winResultArr
    }
    
    func fetchNLottoWinResult(drwNo: Int) -> NLottoWinResult? {
        var winResult: NLottoWinResult? = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NLottoWinResult>(entityName: "NLottoWinResult")
        fetchRequest.predicate = NSPredicate(format: "drwNo == %i", argumentArray: [drwNo])
        fetchRequest.fetchLimit = 1
        do {
            let winResultArr = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            if 0 < winResultArr.count {
                winResult = winResultArr[0]
            }
        } catch let error {
            prLog(error.localizedDescription)
        }
        return winResult
    }
    
    func fetchLatestNLottoWinResult() -> NLottoWinResult? {
        var winResult: NLottoWinResult? = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest = NSFetchRequest<NLottoWinResult>(entityName: "NLottoWinResult")
        fetchRequest.fetchLimit = 1
        do {
            let winResultArr = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            if 0 < winResultArr.count {
                winResult = winResultArr[0]
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

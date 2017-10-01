//
//  NLottoModel.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

// MARK: - NLottoInfo
@objc(NLottoWinResult)
class NLottoWinResult: NSManagedObject, Mappable {
    @NSManaged var drwNo: Int
    @NSManaged var drwNoDate: String?
    @NSManaged var totSellamnt: Int64
    @NSManaged var firstWinamnt: Int64
    @NSManaged var firstPrzwnerCo: Int32
    @NSManaged var drwtNo1: Int16
    @NSManaged var drwtNo2: Int16
    @NSManaged var drwtNo3: Int16
    @NSManaged var drwtNo4: Int16
    @NSManaged var drwtNo5: Int16
    @NSManaged var drwtNo6: Int16
    @NSManaged var bnusNo: Int16
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NLottoWinResult", in: context)
        super.init(entity: entity!, insertInto: context)
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.drwNo           <- map["drwNo"]
        self.drwNoDate       <- map["drwNoDate"]
        self.totSellamnt     <- map["totSellamnt"]
        self.firstWinamnt    <- map["firstWinamnt"]
        self.firstPrzwnerCo  <- map["firstPrzwnerCo"]
        self.drwtNo1         <- map["drwtNo1"]
        self.drwtNo2         <- map["drwtNo2"]
        self.drwtNo3         <- map["drwtNo3"]
        self.drwtNo4         <- map["drwtNo4"]
        self.drwtNo5         <- map["drwtNo5"]
        self.drwtNo6         <- map["drwtNo6"]
        self.bnusNo          <- map["bnusNo"]
    }
}

// 02 03 08 18 23 32 + 45
@objc(MyNLotto)
class MyNLotto: NSManagedObject, Mappable {
    @NSManaged var drwNo: Int
    @NSManaged var drwtNo1: Int16
    @NSManaged var drwtNo2: Int16
    @NSManaged var drwtNo3: Int16
    @NSManaged var drwtNo4: Int16
    @NSManaged var drwtNo5: Int16
    @NSManaged var drwtNo6: Int16
    @NSManaged var bnusNo: Int16
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyPLotto", in: context)
        super.init(entity: entity!, insertInto: context)
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.drwNo      <- map["drwNo"]
        self.drwtNo1    <- map["drwtNo1"]
        self.drwtNo2    <- map["drwtNo2"]
        self.drwtNo3    <- map["drwtNo3"]
        self.drwtNo4    <- map["drwtNo4"]
        self.drwtNo5    <- map["drwtNo5"]
        self.drwtNo6    <- map["drwtNo6"]
        self.bnusNo     <- map["bnusNo"]
    }
}

// MARK: - NLottoModel
protocol INLottoModel {
    func getWinResult(drwNo: Int, completion: ((NLottoWinResult?, Error?) -> Void)?)
    func getLatestWinResult(completion: ((NLottoWinResult?, Error?) -> Void)?)
    func save()
}

class NLottoModel: INLottoModel {
    func getWinResult(drwNo: Int, completion: ((NLottoWinResult?, Error?) -> Void)?) {
        if let winResult = self.fetchNLottoWinResult(drwNo: drwNo) {
            completion?(winResult, nil)
        } else {
            PrHttpRequest().getNLottoNumber(drwNo: drwNo, completion: { (winResult, error) in
                completion?(winResult, error)
            })
        }
    }
    
    func getLatestWinResult(completion: ((NLottoWinResult?, Error?) -> Void)?) {
        let latestDrwNumber = Util.latestDrwNumber(startDateString: NLOTTO_START_DATE, dateFormat: "yyyy-MM-dd")
        if let winResult = self.fetchNLottoWinResult(drwNo: latestDrwNumber) {
            completion?(winResult, nil)
        } else {
            PrHttpRequest().getNLottoNumber(drwNo: 0, completion: { (winResult, error) in
                completion?(winResult, error)
            })
        }
    }
    
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

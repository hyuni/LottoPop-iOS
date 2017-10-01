//
//  PLottoModel.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import Foundation
import CoreData
import ObjectMapper

// MARK - PLottoInfo
@objc(PLottoWinResult)
class PLottoWinResult: NSManagedObject, Mappable {
    @NSManaged var pensionDrawDate: String?
    @NSManaged var rankClass: String?
    @NSManaged var rank: String?
    @NSManaged var rankNo: String?
    @NSManaged var rankAmt: String?
    @NSManaged var round: String?
    @NSManaged var drawDate: String?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "PLottoWinResult", in: context!)
        super.init(entity: entity!, insertInto: context)
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.pensionDrawDate    <- map["pensionDrawDate"]
        self.rankClass          <- map["rankClass"]
        self.rank               <- map["rank"]
        self.rankNo             <- map["rankNo"]
        self.rankAmt            <- map["rankAmt"]
        self.round              <- map["round"]
        self.drawDate           <- map["drawDate"]
    }
}

@objc(MyPLotto)
class MyPLotto: NSManagedObject, Mappable {
    @NSManaged var rankClass: String?
    @NSManaged var rankNo: String?
    @NSManaged var round: String?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init?(map: Map) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyPLotto", in: context!)
        super.init(entity: entity!, insertInto: context)
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        self.rankClass  <- map["rankClass"]
        self.rankNo     <- map["rankNo"]
        self.round      <- map["round"]
    }
}

// MARK: - PLottoModel
protocol IPLottoModel {
    func getWinResult(round: Int, completion: ((Array<PLottoWinResult>?, Error?) -> Void)?)
    func getLatestWinResult(completion: ((Array<PLottoWinResult>?, Error?) -> Void)?)
    func save()
}

class PLottoModel: IPLottoModel {
    func getWinResult(round: Int, completion: ((Array<PLottoWinResult>?, Error?) -> Void)?) {
        if let winResult = self.fetchPLottoWinResult(round: round) {
            completion?(winResult, nil)
        } else {
            PrHttpRequest().getPLottoNumber(round: round, completion: { (winResult, error) in
                completion?(winResult, error)
            })
        }
    }
    
    func getLatestWinResult(completion: ((Array<PLottoWinResult>?, Error?) -> Void)?) {
        let latestRound = Util.latestDrwNumber(startDateString: PLOTTO_START_DATE, dateFormat: "yyyy-MM-dd")
        if let winResult = self.fetchPLottoWinResult(round: latestRound) {
            completion?(winResult, nil)
        } else {
            PrHttpRequest().getPLottoNumber(round: 0, completion: { (winResult, error) in
                completion?(winResult, error)
            })
        }
    }
    
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

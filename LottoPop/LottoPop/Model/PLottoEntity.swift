//
//  PLottoEntity.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 9. 30..
//  Copyright © 2017년 Prangbi. All rights reserved.
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

// MARK: - MyPLotto
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

//
//  PrHttpRequest.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class PrHttpRequest {
    // MARK: Constant
    static let API_URL = SERVER_URL + "/common.do"
    
    // MARK: GET
    func getNLottoNumber(drwNo: Int, success: ((NLottoWinResult?) -> Void)?, failure: ((String?) -> Void)?) {
        let urlStr = PrHttpRequest.API_URL + "?method=getLottoNumber&drwNo=" + (0 < drwNo ? String(drwNo) : "")
        if let url = try? urlStr.asURL() {
            Alamofire.request(url).responseJSON { (alamoResponse) in
                let result = alamoResponse.result
                if true == result.isSuccess {
                    let responseData = Mapper<NLottoWinResult>().map(JSONObject: result.value)
                    success?(responseData)
                } else {
                    let errMsg = result.error?.localizedDescription
                    failure?(errMsg)
                }
            }
        }
    }
    
    func getPLottoNumber(round: Int, success: ((Array<PLottoWinResult>?) -> Void)?, failure: ((String?) -> Void)?) {
        let urlStr = PrHttpRequest.API_URL + "?method=get520Number&drwNo=" + (0 < round ? String(round) : "")
        if let url = try? urlStr.asURL() {
            Alamofire.request(url).responseJSON { (alamoResponse) in
                let result = alamoResponse.result
                if true == result.isSuccess {
                    let rows = (result.value as? Dictionary<String, Any>)?["rows"]
                    let responseData = Mapper<PLottoWinResult>().mapArray(JSONObject: rows)
                    success?(responseData)
                } else {
                    let errMsg = result.error?.localizedDescription
                    failure?(errMsg)
                }
            }
        }
    }
}

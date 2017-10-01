//
//  PrHttpRequest.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class PrHttpRequest {
    // MARK: Constant
    enum API {
        case getNLottoNumber
        case getPLottoNumber
    }
    static let API_URL = SERVER_URL + "/common.do"
    
    // MARK: GET
    func getNLottoNumber(drwNo: Int, completion: ((NLottoWinResult?, Error?) -> Void)?) {
        let urlStr = PrHttpRequest.API_URL + "?method=getLottoNumber&drwNo=" + (0 < drwNo ? String(drwNo) : "")
        if let url = try? urlStr.asURL() {
            Alamofire.request(url).responseJSON { (alamoResponse) in
                let result = alamoResponse.result
                var winResult: NLottoWinResult? = nil
                var error: Error? = nil
                if true == result.isSuccess {
                    winResult = Mapper<NLottoWinResult>().map(JSONObject: result.value)
                } else {
                    error = result.error
                }
                completion?(winResult, error)
            }
        }
    }
    
    func getPLottoNumber(round: Int, completion: ((Array<PLottoWinResult>?, Error?) -> Void)?) {
        let urlStr = PrHttpRequest.API_URL + "?method=get520Number&drwNo=" + (0 < round ? String(round) : "")
        if let url = try? urlStr.asURL() {
            Alamofire.request(url).responseJSON { (alamoResponse) in
                let result = alamoResponse.result
                var winResultArray: Array<PLottoWinResult>? = nil
                var error: Error? = nil
                if true == result.isSuccess {
                    let value = (result.value as? Dictionary<String, Any>)?["rows"]
                    winResultArray = Mapper<PLottoWinResult>().mapArray(JSONObject: value)
                } else {
                    error = result.error
                }
                completion?(winResultArray, error)
            }
        }
    }
}

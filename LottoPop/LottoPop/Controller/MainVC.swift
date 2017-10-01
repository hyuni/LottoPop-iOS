//
//  MainVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 Prangbi. All rights reserved.
//

import UIKit

// MARK: - MainVC
class MainVC: UITabBarController {
    // MARK: Variable
    internal var barcodeValue: String? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRightMenu()
    }
    
    internal func initRightMenu() {
        let scanQrBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25.0, height: 25.0))
        scanQrBtn.setImage(UIImage(named: "prangbi_qr_code"), for: .normal)
        scanQrBtn.addTarget(self, action: #selector(MainVC.scanQrCode), for: .touchUpInside)
        let scanQrItem = UIBarButtonItem(customView: scanQrBtn)
        self.navigationItem.rightBarButtonItems = [scanQrItem]
    }
}

// MARK: - Event
extension MainVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is BarcodeReaderVC:
            let barcodeReaderVC = segue.destination as! BarcodeReaderVC
            barcodeReaderVC.delegate = self
            break
            
        case is WebVC:
            let webVC = segue.destination as! WebVC
            webVC.title = "당첨결과"
            webVC.urlStr = self.barcodeValue
            break
            
        default:
            break
        }
    }
}

// MARK: - Function
extension MainVC {
    @objc func scanQrCode() {
        self.performSegue(withIdentifier: "MainVC to BarcodeReaderVC", sender: nil)
    }
}

// MARK: - BarcodeReaderVcDelegate
extension MainVC: BarcodeReaderVcDelegate {
    func barcodeReaderVC(sender: BarcodeReaderVC, didRead value: String?) {
        self.barcodeValue = value
        self.navigationController?.popViewController(animated: true)
        if nil != value {
            self.performSegue(withIdentifier: "MainVC to WebVC", sender: nil)
        } else {
            MessageUtil.showToast(text: "바코드를 읽지 못했습니다.", parentView: self.view)
        }
    }
}

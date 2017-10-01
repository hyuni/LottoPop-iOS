//
//  UiUtil.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 9. 2..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class UiUtil {
    class func topViewController() -> UIViewController? {
        let vc = UIApplication.shared.keyWindow?.rootViewController
        if true == vc?.isKind(of: UINavigationController.self) {
            let naviController = vc as! UINavigationController
            return naviController.topViewController
        } else if true == vc?.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return tabBarController.selectedViewController
        } else if true == vc?.isKind(of: UISplitViewController.self) {
            let splitVC = vc as! UISplitViewController
            return splitVC.viewControllers.last
        } else {
            return vc?.presentedViewController
        }
    }
    
    class func makeActivityIndicator(parentView: UIView? = nil) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = .gray
        if nil != parentView {
            indicator.center = parentView!.center
            parentView!.addSubview(indicator)
        }
        return indicator
    }
    
    class func getNLottoNumberColor(number: Int16) -> UIColor? {
        var color: UIColor? = nil
        switch number {
        case 1...10:
            color = UIColor(red: 249.0/255.0, green: 183.0/255.0, blue: 4.0/255.0, alpha: 1.0)
            break
            
        case 11...20:
            color = UIColor(red: 8.0/255.0, green: 186.0/255.0, blue: 245.0/255.0, alpha: 1.0)
            break
            
        case 21...30:
            color = UIColor(red: 240.0/255.0, green: 85.0/255.0, blue: 92.0/255.0, alpha: 1.0)
            break
            
        case 31...40:
            color = UIColor(red: 160.0/255.0, green: 159.0/255.0, blue: 160.0/255.0, alpha: 1.0)
            break
            
        case 41...45:
            color = UIColor(red: 156.0/255.0, green: 210.0/255.0, blue: 52.0/255.0, alpha: 1.0)
            break
            
        default:
            break
        }
        return color
    }
    
    class func getPLottoGroupColor(number: Int) -> UIColor? {
        var color: UIColor? = nil
        switch number {
        case 1:
            color = UIColor(red: 228.0/255.0, green: 11.0/255.0, blue: 33.0/255.0, alpha: 1.0)
            break
            
        case 2:
            color = UIColor(red: 239.0/255.0, green: 129.0/255.0, blue: 35.0/255.0, alpha: 1.0)
            break
            
        case 3:
            color = UIColor(red: 249.0/255.0, green: 188.0/255.0, blue: 44.0/255.0, alpha: 1.0)
            break
            
        case 4:
            color = UIColor(red: 22.0/255.0, green: 158.0/255.0, blue: 69.0/255.0, alpha: 1.0)
            break
            
        case 5:
            color = UIColor(red: 26.0/255.0, green: 161.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            break
            
        case 6:
            color = UIColor(red: 10.0/255.0, green: 87.0/255.0, blue: 164.0/255.0, alpha: 1.0)
            break
            
        case 7:
            color = UIColor(red: 153.0/255.0, green: 19.0/255.0, blue: 130.0/255.0, alpha: 1.0)
            break
            
        default:
            break
        }
        return color
    }
}

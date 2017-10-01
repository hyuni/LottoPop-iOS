//
//  MessageUtil.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 9. 2..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit

class MessageUtil {
    internal static var toastView: ToastView? = nil
    internal static var toastDispatchItem: DispatchWorkItem? = nil
    
    class func showToast(text: String?, parentView: UIView? = nil, duration: Double = 3.0) {
        // 이미 추가된 parentview에서 제거.
        self.toastDispatchItem?.cancel()
        self.toastView?.removeFromSuperview()
        
        // 생성되어 있지 않다면 생성.
        if nil == self.toastView {
            let nib = UINib(nibName: "ToastView", bundle: Bundle.main)
            self.toastView = nib.instantiate(withOwner: nil, options: nil)[0] as? ToastView
        }
        
        // 라벨 설정.
        self.toastView?.setData(text: text)
        
        // ParentView 지정.
        if let toast = self.toastView, let parent = parentView ?? UiUtil.topViewController()?.view {
            let toastSize = toast.getSize()
            let toastX = parent.center.x - (toastSize.width / 2.0)
            let toastY = parent.frame.height - toastSize.height - 8.0
            toast.frame = CGRect(x: toastX, y: toastY, width: toastSize.width, height: toastSize.height)
            parent.addSubview(toast)
        }
        
        // 타이머 생성 및 실행.
        self.toastDispatchItem = DispatchWorkItem {
            self.toastView?.removeFromSuperview()
        }
        if nil != self.toastDispatchItem {
            let delayTime = DispatchTime.now() + duration
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: self.toastDispatchItem!)
        }
    }
    
    class func showSimpleAlert(viewController: UIViewController?, title: String?, message: String?) {
        self.alert(viewController: viewController, title: title, message: message, itemNames: ["OK"], completion: nil)
    }
    
    class func alert(viewController: UIViewController?, title: String?, message: String?, itemNames: [String], completion: ((String?)->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for item in itemNames {
            let action = UIAlertAction(title: item, style: .default, handler: { (action) -> Void in
                completion?(action.title)
            })
            alertController.addAction(action)
        }
        
        let vc = viewController ?? UiUtil.topViewController()
        vc?.present(alertController, animated: true, completion: nil)
    }
}

//
//  UtilityExtension.swift
//  oddy
//
//  Created by Mostafizur Rahman on 8/5/20.
//  Copyright © 2020 Mostafizur Rahman. All rights reserved.
//

import UIKit

class UtilityExtension: NSObject {

}
extension UIViewController {

    func topViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.navigationController {
            if let topViewController = navigation.viewControllers.last {
                return topViewController
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topViewController()
            }
            return tab.topViewController()
        }
        return self.presentedViewController?.topViewController()
    }
}

extension UIApplication {
    
    func topViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topViewController()
    }
}
extension Int {
    static func random(in range: ClosedRange<Int>, excluding x: Int) -> Int {
        if range.contains(x) {
            let r = Int.random(in: Range(uncheckedBounds: (range.lowerBound, range.upperBound)))
            return r == x ? range.upperBound : r
        } else {
            return Int.random(in: range)
        }
    }
}

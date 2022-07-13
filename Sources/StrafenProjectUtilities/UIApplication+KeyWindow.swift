//
//  UIApplication+KeyWindow.swift
//  
//
//  Created by Steven on 12.07.22.
//

import Foundation

#if os(iOS)
import UIKit

extension UIApplication {

    /// Key window of the application.
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)
    }
}

extension UIWindow {

    /// Presented controller of the window.
    var presentedController: UIViewController? {
        var viewController = self.rootViewController

        // If root `UIViewController` is a `UITabBarController`
        if let controller = viewController as? UITabBarController {
            viewController = controller.selectedViewController
        }

        // Go deeper to find the last presented `UIViewController`
        while let controller = viewController?.presentedViewController {
            if let controller = controller as? UITabBarController {
                viewController = controller.selectedViewController
            } else {
                viewController = controller
            }
        }

        return viewController
    }
}
#endif

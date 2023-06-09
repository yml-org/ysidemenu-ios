//
//  SideMenuController+Appearance.swift
//  YSideMenu
//
//  Created by Caio Coan on 26/04/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import UIKit
import YCoreUI

extension SideMenuController {
    /// Determines the appearance of the side menu..
    public struct Appearance {
        /// Appearance for the dimmer background color. Default is `UIColor.black` with `0.5` opacity.
        public var dimmerColor: UIColor
        /// Maximum width for side menu. Default is `414` (iPad size).
        public var maximumWidth: CGFloat
        /// Ideal width percentage for side menu, related to screen width. Default is `0.8`.
        public var idealWidthPercentage: CGFloat
        /// Animation for presenting the side menu. Default = `.defaultPresent`.
        public var presentAnimation: Animation
        /// Animation for dismissing the side menu. Default = `.defaultDismiss`.
        public var dismissAnimation: Animation
        /// Whether the menu can be dismissed by swiping left or tapping on the dimmer. Default is `true`.
        public var isDismissAllowed: Bool
        
        /// Default appearance
        public static let `default` = Appearance()

        /// Initializes an `Appearance`.
        /// - Parameters:
        ///   - dimmerColor: Color for the dimmer view on side menu.
        ///   - maximumWidth: Maximum width allowed for the side menu.
        ///   - idealWidthPercentage: Ideal width for the side menu based on screen width.
        ///   - presentAnimation: Animation for presenting the side menu.
        ///   - dismissAnimation: Animation for dismissing the side menu.
        ///   - isDismissAllowed: Whether the menu  can be dismissed by swiping left or tapping on the dimmer.
        public init(
            dimmerColor: UIColor = UIColor.black.withAlphaComponent(0.5),
            maximumWidth: CGFloat = 414,
            idealWidthPercentage: CGFloat = 0.8,
            presentAnimation: Animation = .defaultPresent,
            dismissAnimation: Animation = .defaultDismiss,
            isDismissAllowed: Bool = true
        ) {
            self.dimmerColor = dimmerColor
            self.maximumWidth = maximumWidth
            self.idealWidthPercentage = idealWidthPercentage
            self.presentAnimation = presentAnimation
            self.dismissAnimation = dismissAnimation
            self.isDismissAllowed = isDismissAllowed
        }
    }
}

//
//  YSideMenuController+Strings.swift
//  YSideMenu
//
//  Created by Caio Coan on 05/03/23.
//  Copyright © 2023 Y Media Labs. All rights reserved.
//

import Foundation
import YCoreUI

extension SideMenuController {
    enum Strings: String, Localizable, CaseIterable {
        case dimmerAccessibilityLabel = "Menu_Dimmer_Close"

        static var bundle: Bundle { .module }
    }
}

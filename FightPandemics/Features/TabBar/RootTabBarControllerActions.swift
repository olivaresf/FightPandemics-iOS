//
//  RootTabBarControllerActions.swift
//  FightPandemics
//
//  Created by Fernando Olivares on 2/21/21.

import UIKit

class RootTabBarControllerActions { }

extension RootTabBarControllerActions : RootTabBarControllerDelegate {
    
    func didSelect(tab: RootTabBarController.Tab,
                   rootController: RootTabBarController) {
        switch tab {
        case .feed, .search, .profile, .inbox:
            rootController.selectedIndex = tab.rawValue
            addDotToTab(tab: tab)
            tabBar.bringSubviewToFront(postButton)
        case .post:
            selectPostTab()
        }
    }
}

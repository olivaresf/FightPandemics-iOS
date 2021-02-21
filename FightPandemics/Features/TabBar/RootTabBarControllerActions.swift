//
//  RootTabBarControllerActions.swift
//  FightPandemics
//
//  Created by Fernando Olivares on 2/21/21.

import UIKit

class RootTabBarControllerActions : NSObject { }

extension RootTabBarControllerActions : UITabBarControllerDelegate {
    
    func tabBarController(_: UITabBarController,
                          didSelect viewController: UIViewController) {
        
        guard let viewController = (viewController as? RootNavigationController)?.viewControllers.first else {
            return
        }

        let tab: Tab
        switch viewController {
        case is FeedViewController:
            tab = .feed
        case is SearchViewController:
            tab = .search
        case is InboxViewController:
            tab = .inbox
        case is ProfileViewController:
            tab = .profile
        default:
            return
        }

        selectTab(tab)
    }
}

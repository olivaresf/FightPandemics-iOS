//
//  RootTabBarControllerActions.swift
//  FightPandemics
//
//  Created by Fernando Olivares on 2/21/21.

import UIKit

class RootTabBarControllerActions {
    
    private func addDotToTab(tabBar: UITabBar,
                             item: UITabBarItem,
                             dotView: UIView) {
        
        let dotViewIdentifier = 100
        if tabBar.viewWithTag(dotViewIdentifier) != nil {
            tabBar.viewWithTag(dotViewIdentifier)?.removeFromSuperview()
        }
        dotView.tag = dotViewIdentifier
        tabBar.addSubview(dotView)
        tabBar.layoutIfNeeded()
        tabBar.layoutSubviews()
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear],
                                    for: .selected)
    }
    
    private func tabDotView(tab: RootTabBarController.Tab,
                            item: UITabBarItem,
                            itemView: UIView,
                            dotView: UIView) -> UIView? {
        
        var addend = CGFloat()
        switch tab {
        case .feed:
            addend = -19
        case .search:
            addend = -35
        case .inbox:
            addend = 27
        case .profile:
            addend = 12
        case .post:
            break
        }

        let dotView = UIView()
        dotView.backgroundColor = UIColor.fightPandemicsNeonBlue()
        dotView.frame.size = CGSize(width: 6, height: 6)
        dotView.layer.cornerRadius = 3
        dotView.layer.masksToBounds = true
        dotView.frame.origin.x = itemView.frame.origin.x + (itemView.frame.size.width / 2) + addend
        dotView.frame.origin.y = 40
        return dotView
    }
}

extension RootTabBarControllerActions : RootTabBarControllerDelegate {
    
    func didSelect(tab: RootTabBarController.Tab,
                   rootController: RootTabBarController) {
        switch tab {
        case .feed, .search, .profile, .inbox:
            rootController.selectedIndex = tab.rawValue
            
            let itemView = item.value(forKey: "view") as? UIView
            
            addDotToTab(tab: tab)
            tabBar.bringSubviewToFront(postButton)
        case .post:
            selectPostTab()
        }
    }
}

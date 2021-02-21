//
//  RootTabBarController.swift
//  FightPandemics
//
//  Created by Harlan Kellaway on 5/10/20.
//
//  Copyright (c) 2020 FightPandemics
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

protocol RootTabBarControllerDelegate {
    func didSelect(tab: RootTabBarController.Tab,
                   rootController: RootTabBarController)
}

final class RootTabBarController: UITabBarController {
    // MARK: - Types

    enum Tab: Int, CaseIterable {
        case feed = 0
        case search = 1
        case post = -1 // Post tab not indexed through `viewControllers` array
        case inbox = 2
        case profile = 3
    }

    // MARK: - Properties

    weak var actionDelegate: RootTabBarControllerDelegate!
    var autoLoginFakeLaunchScreen: AutoLoginFakeLaunchScreen!
    var navigator: Navigator!
    var sessionManager: SessionManager!

    var postButton: UIButton!

    // MARK: - Overrides

    // MARK: View life-cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeTabBar()
        selectTab(.feed)
        delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        attemptAutoLogIn()
    }

    // MARK: - Instance methods

    func navController(_ tab: Tab) -> RootNavigationController? {
        assert(tab.rawValue >= 0 && tab.rawValue <= Tab.allCases.count - 1, "Invalid Tab index")
        return viewControllers?[tab.rawValue] as? RootNavigationController
    }

    // MARK: Private instance methods

    private func customizeTabBar() {
        tabBar.tintColor = .black
        tabBar.barTintColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        tabBar.clipsToBounds = true
        tabBar.layer.cornerRadius = 10
        tabBar.layer.masksToBounds = true
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowRadius = 8
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.borderWidth = 0
        tabBar.shadowImage = UIImage()

        customizeTabBarItem(tab: .feed)
        customizeTabBarItem(tab: .search)
        customizeTabBarItem(tab: .inbox)
        customizeTabBarItem(tab: .profile)

        let postButton = UIButton()
        self.postButton = postButton
        postButton.frame.size = CGSize(width: 44, height: 44)
        postButton.setImage(Asset.post.image, for: .normal)
        postButton.center = CGPoint(x: tabBar.frame.width / 2, y: 24)
        tabBar.addSubview(postButton)
        postButton.addTarget(self, action: #selector(selectPostTab), for: .touchUpInside)
        tabBar.bringSubviewToFront(postButton)
    }

    private func customizeTabBarItem(tab: Tab) {
        let item = tabBarItem(tab)
        var titleKey: String = "TabBarFeedBtn"
        var iconImage: UIImage = Asset.feed.image
        var horizontalOffset: CGFloat = -15
        switch tab {
        case .search:
            titleKey = "TabBarSearchBtn"
            iconImage = Asset.search.image
            horizontalOffset = -30
        case .inbox:
            titleKey = "TabBarInboxBtn"
            iconImage = Asset.inbox.image
            horizontalOffset = 30
        case .profile:
            titleKey = "TabBarProfileBtn"
            iconImage = Asset.profile.image
            horizontalOffset = 15
        case .post, .feed:
            break
        }
        item?.setTitleTextAttributes([NSAttributedString.Key.font: Fonts.poppinsRegular.customFont(size: 12)], for: .normal)
        item?.image = iconImage
        item?.title = titleKey.localized
        item?.titlePositionAdjustment = UIOffset(horizontal: horizontalOffset, vertical: 0)
    }

    @objc func selectPostTab() {
        navigator.navigateToCreatePostEntitySelectionModal()
    }

    private func attemptAutoLogIn() {
        autoLoginFakeLaunchScreen.show()
        sessionManager.autoLogIn { [weak self] result in
            self?.autoLoginFakeLaunchScreen.dismiss()
            if !(result == .success) {
                self?.navigator.navigateToLogIn()
            }
        }
    }
}

extension RootTabBarController: UITabBarControllerDelegate {
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

        actionDelegate.didSelect(tab: tab,
                                 rootController: self)
    }
}

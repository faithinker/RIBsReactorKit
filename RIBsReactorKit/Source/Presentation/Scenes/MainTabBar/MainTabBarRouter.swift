//
//  MainTabBarRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - MainTabBarInteractable

/// @mockable
protocol MainTabBarInteractable:
  Interactable,
  UserListListener,
  UserCollectionListener
{
  var router: MainTabBarRouting? { get set }
  var listener: MainTabBarListener? { get set }
}

// MARK: - MainTabBarViewControllable

/// @mockable
protocol MainTabBarViewControllable: ViewControllable {
  func setViewControllers(_ viewControllers: [ViewControllable], animated: Bool)
}

// MARK: - MainTabBarRouter

final class MainTabBarRouter:
  ViewableRouter<MainTabBarInteractable, MainTabBarViewControllable>,
  MainTabBarRouting
{

  // MARK: - Properties

  private let userListBuilder: UserListBuildable
  private var userListRouter: UserListRouting?

  private let userCollectionBuilder: UserCollectionBuildable
  private var userCollectionRouter: UserCollectionRouting?

  // MARK: - Initialization & Deinitialization

  init(
    userListBuilder: UserListBuildable,
    userCollectionBuilder: UserCollectionBuildable,
    interactor: MainTabBarInteractable,
    viewController: MainTabBarViewControllable
  ) {
    self.userListBuilder = userListBuilder
    self.userCollectionBuilder = userCollectionBuilder

    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}

// MARK: - MainTabBarRouting

extension MainTabBarRouter {

  func attachTabs() {
    let tabs: [ViewControllable] = [
      UINavigationController(root: attachUserListRIB()),
      UINavigationController(root: attachUserCollectionRIB())
    ]

    viewController.setViewControllers(tabs, animated: false)
  }

  private func attachUserListRIB() -> ViewControllable {
    let router = self.userListBuilder.build(
      with: UserListBuildDependency(
        listener: interactor
      )
    )
    self.userListRouter = router
    attachChild(router)
    return router.viewControllable
  }

  private func attachUserCollectionRIB() -> ViewControllable {
    let router = self.userCollectionBuilder.build(
      with: UserCollectionBuildDependency(
        listener: interactor
      )
    )
    self.userCollectionRouter = router
    attachChild(router)
    return router.viewControllable
  }
}

//
//  UserInformationRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - UserInformationInteractable

protocol UserInformationInteractable: Interactable, UserLocationListener {
  var router: UserInformationRouting? { get set }
  var listener: UserInformationListener? { get set }
}

// MARK: - UserInformationViewControllable

protocol UserInformationViewControllable: ViewControllable {}

// MARK: - UserInformationRouter

final class UserInformationRouter:
  ViewableRouter<UserInformationInteractable, UserInformationViewControllable>,
  UserInformationRouting
{

  private let userLocationBuilder: UserLocationBuildable
  private var userLocationRouter: UserLocationRouting?

  init(
    userLocationBuilder: UserLocationBuildable,
    interactor: UserInformationInteractable,
    viewController: UserInformationViewControllable
  ) {
    self.userLocationBuilder = userLocationBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}

extension UserInformationRouter {
  func attachUserLocationRIB(annotationMetadata: MapPointAnnotationMetadata) {
    guard self.userLocationRouter == nil else { return }

    let router = self.userLocationBuilder.build(
      with: UserLocationBuildDependency(
        listener: interactor
      ),
      UserLocationComponentDependency(
        annotationMetadata: annotationMetadata
      )
    )
    self.userLocationRouter = router
    attachChild(router)
    viewController.show(router.viewControllable)
  }

  func detachUserLocationRIB() {
    guard let router = userLocationRouter else { return }
    self.userLocationRouter = nil
    detachChild(router)
    viewController.remove(router.viewControllable)
  }
}

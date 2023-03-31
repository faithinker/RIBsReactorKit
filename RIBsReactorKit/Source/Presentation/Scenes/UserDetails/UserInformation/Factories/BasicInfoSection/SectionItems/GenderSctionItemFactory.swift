//
//  GenderSctionItemFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct GenderSctionItemFactory: UserInfoSectionItemFactory {

  private var icon: UIImage? { UIImage(systemName: "person.fill") }

  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel = UserDetailInfoItemViewModel(
      userModel: userModel,
      icon: icon,
      title: userModel.gender,
      subtitle: Strings.UserInfoTitle.gender,
      showSeparatorLine: !isLastItem
    )

    return .detail(viewModel)
  }
}

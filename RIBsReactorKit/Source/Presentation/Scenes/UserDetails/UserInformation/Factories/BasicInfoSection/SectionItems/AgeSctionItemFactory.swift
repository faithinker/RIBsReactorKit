//
//  AgeSctionItemFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct AgeSctionItemFactory: UserInfoSectionItemFactory {

  private var icon: UIImage? { UIImage(systemName: "clock") }

  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel = UserDetailInfoItemViewModel(
      userModel: userModel,
      icon: icon,
      title: Strings.Unit.age(userModel.dob.age),
      subtitle: Strings.UserInfoTitle.age,
      showSeparatorLine: false
    )

    return .detail(viewModel)
  }
}

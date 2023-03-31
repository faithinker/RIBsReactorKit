//
//  UserDetailInfoCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/09/13.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

// MARK: - UserDetailInfoCell

final class UserDetailInfoCell:
  BaseCollectionViewCell,
  HasConfigure,
  SkeletonViewsAnimatable
{

  // MARK: - Constants

  private enum UI {
    // - iconImageView
    static let iconImageViewSize = CGSize(width: 35, height: 35)
    static let iconTopMargin: CGFloat = 15
    static let iconBottomMargin: CGFloat = 15
    static let iconLeadingMargin: CGFloat = 16

    // - textLabelStackView
    static let textLabelStackViewTopMargin: CGFloat = 3
    static let textLabelStackViewBottomMargin: CGFloat = 3
    static let textLabelStackViewLeadingMargin: CGFloat = 16
    static let textLabelStackViewTrailingMargin: CGFloat = 16
    static let textLabelStackViewSpacing: CGFloat = 2

    // - separatorLineView
    static let separatorLineViewHeight: CGFloat = 0.5

    enum Font {
      static let title = UIFont.systemFont(ofSize: 18)
      static let subtitle = UIFont.systemFont(ofSize: 15)
    }

    enum Color {
      static let iconImageViewBackground = Asset.Colors.backgroundColor.color
      static let titleText = UIColor.darkText
      static let subtitleText = UIColor.darkGray
      static let separatorLine = UIColor.lightGray
    }
  }

  // MARK: - Properties

  private(set) var viewModel: UserDetailInfoItemViewModel?

  // for skeleton view animation
  private let dummyTitleString = String(repeating: " ", count: 60)
  private let dummySubtitleString = String(repeating: " ", count: 30)

  // MARK: - UI Components

  private let iconImageView = BaseImageView().builder
    .tintColor(.gray)
    .contentMode(.scaleAspectFill)
    .set(\.layer.cornerRadius, to: UI.iconImageViewSize.height / 2)
    .backgroundColor(UI.Color.iconImageViewBackground)
    .isSkeletonable(true)
    .build()

  private lazy var titleLabel = BaseLabel().builder
    .font(UI.Font.title)
    .numberOfLines(0)
    .text(dummyTitleString)
    .isSkeletonable(true)
    .build()

  private lazy var subtitleLabel = BaseLabel().builder
    .font(UI.Font.subtitle)
    .numberOfLines(0)
    .text(dummySubtitleString)
    .isSkeletonable(true)
    .build()

  private let textLabelStackView = UIStackView().builder
    .translatesAutoresizingMaskIntoConstraints(false)
    .axis(.vertical)
    .alignment(.fill)
    .distribution(.fill)
    .spacing(UI.textLabelStackViewSpacing)
    .build()

  private let separatorLineView = UIView().builder
    .backgroundColor(UI.Color.separatorLine)
    .build()

  var skeletonViews: [UIView] {
    [iconImageView, titleLabel, subtitleLabel]
  }

  // MARK: - Inheritance

  override func initialize() {
    super.initialize()
    setupUI()
  }

  override func setupConstraints() {
    super.setupConstraints()
    layout()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.initUI()
  }

  // MARK: - Internal methods

  func configure(by viewModel: UserDetailInfoItemViewModel) {
    self.iconImageView.image = viewModel.icon
    self.titleLabel.text = viewModel.title
    self.separatorLineView.isHidden = !viewModel.showSeparatorLine

    guard viewModel.hasSubtitle else { return }
    self.subtitleLabel.text = viewModel.subtitle
    self.textLabelStackView.addArrangedSubview(self.subtitleLabel)
  }

  // MARK: - Private methods

  private func initUI() {
    self.iconImageView.image = nil
    self.titleLabel.text = self.dummyTitleString
    self.separatorLineView.isHidden = false
  }
}

// MARK: - Layout

extension UserDetailInfoCell {
  private func setupUI() {
    isSkeletonable = true
    contentView.addSubview(self.iconImageView)
    contentView.addSubview(self.textLabelStackView)
    contentView.addSubview(self.separatorLineView)
    self.textLabelStackView.addArrangedSubview(self.titleLabel)

    self.initUI()
  }

  private func layout() {
    self.iconImageView.snp.makeConstraints {
      $0.size.equalTo(UI.iconImageViewSize)
      $0.centerY.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview().offset(UI.iconTopMargin)
      $0.bottom.lessThanOrEqualToSuperview().offset(-UI.iconBottomMargin)
      $0.leading.equalToSuperview().offset(UI.iconLeadingMargin)
    }

    self.textLabelStackView.snp.makeConstraints {
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
      $0.leading.equalTo(iconImageView.snp.trailing).offset(UI.textLabelStackViewLeadingMargin)
      $0.trailing.equalToSuperview().offset(-UI.textLabelStackViewTrailingMargin)
      $0.centerY.equalToSuperview()
    }

    self.separatorLineView.snp.makeConstraints {
      $0.height.equalTo(UI.separatorLineViewHeight)
      $0.leading.equalTo(textLabelStackView.snp.leading)
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  extension UserDetailInfoCell {
    fileprivate func dummyUserModel() -> UserModel? {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
      guard let randomUser = try? decoder.decode(RandomUser.self, from: RandomUserFixture.data) else { return nil }
      let userModelTranslator = UserModelTranslatorImpl()

      let userModels = userModelTranslator.translateToUserModel(by: randomUser.results)
      return userModels.first
    }
  }

  import SwiftUI

  struct UserDetailInformationCellCellPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      UIViewPreview {
        UserDetailInfoCell().builder
          .with {
            guard let userModel = $0.dummyUserModel() else { return }
            let viewModel = UserDetailInfoItemViewModel(
              userModel: userModel,
              icon: .checkmark,
              title: "서울",
              subtitle: "거주지",
              showSeparatorLine: true
            )
            $0.configure(by: viewModel)
          }
      }
      .previewLayout(.fixed(width: 400, height: 100))
      .padding(10)
    }
  }
#endif

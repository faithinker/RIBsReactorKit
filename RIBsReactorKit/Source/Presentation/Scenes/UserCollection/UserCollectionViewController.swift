//
//  UserCollectionViewController.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxCocoa
import RxDataSources
import RxSwift

// MARK: - UserCollectionViewControllableListener

protocol UserCollectionViewControllableListener: AnyObject, HasLoadingStream, HasRefreshStream {
  typealias Action = UserListPresentableAction
  typealias ViewModel = UserCollectionViewModel

  func sendAction(_ action: Action)
  var viewModel: Observable<ViewModel> { get }
}

// MARK: - UserCollectionViewController

final class UserCollectionViewController:
  BaseViewController,
  UserCollectionViewControllable,
  HasCollectionView,
  PullToRefreshable,
  SkeletonControllable,
  LoadingStreamBindable,
  RefreshStreamBindable
{

  // MARK: - Constants

  private enum UI {
    static let cellMargin: CGFloat = 5
    static let profileCellHeight: CGFloat = 250
  }

  typealias UserCollectionDataSource = RxCollectionViewSectionedReloadDataSource<UserCollectionSectionModel>

  // MARK: - Properties

  weak var listener: UserCollectionViewControllableListener?

  let refreshEvent = PublishRelay<Void>()

  private let actionRelay = PublishRelay<UserCollectionViewControllableListener.Action>()

  private let dataSource: UserCollectionDataSource

  // MARK: - UI Components

  let refreshControl = UIRefreshControl()

  private let flowLayout = UICollectionViewFlowLayout().builder
    .scrollDirection(.vertical)
    .build()

  private(set) lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).builder
    .backgroundColor(Asset.Colors.backgroundColor.color)
    .with {
      $0.register(UserProfileCell.self)
      $0.register(DummyUserProfileCell.self)
    }
    .build()

  // MARK: - Initialization & Deinitialization

  override init() {
    self.dataSource = Self.dataSource()
    super.init()
    setTabBarItem()
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindUI()
    bind(listener: self.listener)
  }
}

// MARK: - Private methods

extension UserCollectionViewController {
  private func setTabBarItem() {
    tabBarItem = UITabBarItem(
      title: Strings.TabBarTitle.collection,
      image: Asset.Images.TabBarIcons.collectionTab.image,
      selectedImage: nil
    )
  }

  fileprivate static func dataSource() -> UserCollectionDataSource {
    return UserCollectionDataSource(
      configureCell: { _, collectionView, indexPath, section in
        switch section {
        case let .user(viewModel):
          let cell = collectionView.dequeue(UserProfileCell.self, indexPath: indexPath)
          cell.configure(by: viewModel)
          return cell

        case .dummy:
          let cell = collectionView.dequeue(DummyUserProfileCell.self, indexPath: indexPath)
          return cell
        }
      }
    )
  }
}

// MARK: - Bind UI

extension UserCollectionViewController {
  private func bindUI() {
    bindRefreshControlEvent()
    self.bindCollectionViewSetDelegate()
  }

  private func bindCollectionViewSetDelegate() {
    self.collectionView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
}

// MARK: - Bind listener

extension UserCollectionViewController {
  private func bind(listener: UserCollectionViewControllableListener?) {
    guard let listener = listener else { return }
    self.bindActionRelay()
    bindActions()
    bindState(from: listener)
  }

  private func bindActionRelay() {
    //    self.actionRelay.asObservable()
    //      .bind(with: self) { this, action in
    //        this.listener?.sendAction(action)
    //      }
    //      .disposed(by: disposeBag)

        self.actionRelay.asObservable()
          .subscribe(onNext: { [weak self] (action: UserListPresentableListener.Action) in
            guard let self = self else { return }
            self.listener?.sendAction(action)
          })
          .disposed(by: disposeBag)
  }
}

// MARK: - Binding Action

extension UserCollectionViewController {
  private func bindActions() {
    self.bindViewWillAppearAction()
    self.bindRefreshControlAction()
    self.bindLoadMoreAction()
    self.bindPrefetchItemsAction()
    self.bindItemSelectedAction()
  }

  private func bindViewWillAppearAction() {
    rx.viewWillAppear
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .map { _ in .loadData }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindRefreshControlAction() {
    self.refreshEvent
      .map { .refresh }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindLoadMoreAction() {
    self.collectionView.rx.willDisplayCell
      .map { .loadMore($0.at) }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindPrefetchItemsAction() {
    self.collectionView.rx.prefetchItems
      .map { .prefetchItems($0) }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }

  private func bindItemSelectedAction() {
    self.collectionView.rx.itemSelected
      .map { .itemSelected($0) }
      .bind(to: self.actionRelay)
      .disposed(by: disposeBag)
  }
}

// MARK: - Binding State

extension UserCollectionViewController {
  private func bindState(from listener: UserCollectionViewControllableListener) {
    bindLoadingStream(from: listener)
    bindRefreshStream(from: listener)
    self.bindUserListSectionsState(from: listener)
  }

  private func bindUserListSectionsState(from listener: UserCollectionViewControllableListener) {
    listener.viewModel.map(\.userCollectionSections)
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
}

// MARK: - Layout

extension UserCollectionViewController {
  private func setupUI() {
    navigationItem.title = Strings.UserCollection.title
    view.addSubview(self.collectionView)

    setRefreshControl()
    self.layout()
  }

  private func layout() {
    self.collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let margin = UI.cellMargin * 2
    var width = (collectionView.frame.width - margin) / 2
    if traitCollection.horizontalSizeClass == .regular {
      width = (collectionView.readableContentGuide.layoutFrame.width - margin) / 2
    }

    width = floor(width)
    return CGSize(width: width, height: UI.profileCellHeight)
  }
}

#if canImport(SwiftUI) && DEBUG
  import SwiftUI

  private let deviceNames: [String] = [
    "iPhone SE",
    "iPhone 11 Pro Max"
  ]

  struct UserCollectionControllerPreview: PreviewProvider {
    static var previews: some View {
      ForEach(deviceNames, id: \.self) { deviceName in
        UIViewControllerPreview {
          let viewController = UserCollectionViewController()
          return UINavigationController(rootViewController: viewController)
        }
        .previewDevice(PreviewDevice(rawValue: deviceName))
        .previewDisplayName(deviceName)
      }
    }
  }
#endif

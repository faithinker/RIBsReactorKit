//
//  UserLocationCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/04/19.
//  Copyright © 2021 Elon. All rights reserved.
//

import MapKit
import UIKit

// MARK: - UserLocationCell

final class UserLocationCell:
  BaseCollectionViewCell,
  HasConfigure,
  MapRegionSettable,
  MapAnnotationAddable,
  SkeletonViewsAnimatable
{

  // MARK: - UI Components

  private let mapView = MKMapView().builder
    .isUserInteractionEnabled(false)
    .build()

  var skeletonViews: [UIView] {
    [mapView]
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

  // MARK: - Internal methods

  func configure(by viewModel: UserLocationViewModel) {
    guard let coordinate2D = viewModel.location.coordinates.locationCoordinate2D else { return }
    let coordinate = CLLocationCoordinate2D(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
    setRegion(to: self.mapView, center: coordinate)
    self.addAnnotation(by: viewModel.location, with: coordinate)
  }

  // MARK: - Private methods

  private func addAnnotation(by location: Location, with coordinate: CLLocationCoordinate2D) {
    addMapAnnotation(to: self.mapView, coordinate: coordinate, title: location.city, subtitle: location.street.name)
  }
}

// MARK: - Layout

extension UserLocationCell {
  private func setupUI() {
    isSkeletonable = true
    self.skeletonViews.forEach { contentView.addSubview($0) }
  }

  private func layout() {
    self.mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

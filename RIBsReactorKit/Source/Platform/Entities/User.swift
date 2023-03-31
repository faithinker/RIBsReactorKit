//
//  User.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - User

struct User:
  Codable,
  Equatable
{
  let gender: String
  let name: Name
  let location: Location
  let email: String
  let login: Login
  let dob: Dob
  let registered: Dob
  let phone: String
  let cell: String
  let id: ID
  let picture: Picture
  let nat: String
}

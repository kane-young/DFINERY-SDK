//
//  NetworkRequestRouter.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import Foundation

enum NetworkRequestRouter {
  case createEvent

  private var baseURLString: String {
    return "http://adbrix-sdk-assignment-backend-115895936.ap-northeast-1.elb.amazonaws.com"
  }

  private var httpMethod: HTTPMethod {
    switch self {
    case .createEvent:
      return .post
    }
  }

  private var path: String {
    switch self {
    case .createEvent:
      return "/api/AddEvent"
    }
  }

  func asURLRequest(with httpBody: Data?) -> URLRequest? {
    guard let url = URL(string: (self.baseURLString + self.path)) else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = self.httpMethod.rawValue
    request.httpBody = httpBody
    return request
  }
}

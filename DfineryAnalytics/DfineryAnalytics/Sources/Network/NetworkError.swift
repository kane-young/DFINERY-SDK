//
//  NetworkError.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import Foundation

public enum NetworkError: Error {
  case invalidRequest
  case connectionProblem
  case invalidResponseStatusCode(_ statusCode: Int)
  case invalidData
  case decodingError

  var message: String {
    switch self {
    case .invalidRequest:
      return "유효하지 않은 요청"
    case .connectionProblem:
      return "네트워킹 문제"
    case .invalidResponseStatusCode(let statusCode):
      return "상태 코드 \(statusCode)"
    case .invalidData:
      return "반환 데이터 미존재"
    case .decodingError:
      return "디코딩 에러"
    }
  }
}

extension NetworkError: Equatable { }

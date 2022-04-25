//
//  HTTPClientTests.swift
//  DFINERY-SDKTests
//
//  Created by 이영우 on 2022/04/25.
//

import XCTest
@testable import DFINERY_SDK

final class HTTPClientTests: XCTestCase {

  private var httpClient: HTTPClient!
  private var expectation: XCTestExpectation!
  private let dummyURL = URL(string: "www.dfinery.com")!
  private lazy var dummyRequest = URLRequest(url: self.dummyURL)

  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockURLProtocol.self]
    let mockURLSession = URLSession(configuration: configuration)
    self.httpClient = .init(urlSession: mockURLSession)
    self.expectation = .init()
  }

  override func tearDownWithError() throws {
    self.httpClient = nil
    self.expectation = nil
  }

  func test_when_response에_Error포함시_then_connectionProblem에러발생() {
    //given
    let expectedError = NetworkError.connectionProblem
    MockURLProtocol.requestHandler = { _ in
      let response = HTTPURLResponse(
        url: self.dummyURL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, Data(), expectedError)
    }

    //when
    self.httpClient.retrieve(
      with: self.dummyRequest,
      as: EventAdditionResponse.self
    ) { result in
      switch result {
      case .success(_):
        XCTFail()
      case .failure(let error):
        //then
        XCTAssertEqual(error, expectedError)
        self.expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 2.0)
  }

  func test_when_statusCode가200번대가아닐경우_then_invalidResponseStatusCode에러발생() {
    //given
    let expectedError = NetworkError.invalidResponseStatusCode(404)
    MockURLProtocol.requestHandler = { _ in
      let response = HTTPURLResponse(
        url: self.dummyURL,
        statusCode: 404,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, nil, nil)
    }

    //when
    self.httpClient.retrieve(
      with: self.dummyRequest,
      as: EventAdditionResponse.self
    ) { result in
      switch result {
      case .success(_):
        XCTFail()
      case .failure(let error):
        //then
        XCTAssertEqual(error, expectedError)
        self.expectation.fulfill()
      }
    }

    wait(for: [expectation], timeout: 2.0)
  }

  func test_when_itemList로드시_then_data반환성공() {
    //given
    let data = """
    {
        "result" : true,
        "message" : "ok"
    }
    """.data(using: .utf8)
    MockURLProtocol.requestHandler = { _ in
      let response = HTTPURLResponse(
        url: self.dummyURL,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
      )
      return (response, data, nil)
    }

    //when
    self.httpClient.retrieve(
      with: self.dummyRequest,
      as: EventAdditionResponse.self
    ) { result in
      switch result {
      case .success(let data):
        //then
        XCTAssertNotNil(data)
        self.expectation.fulfill()
      case .failure(let error):
        XCTFail(error.message)
      }
    }

    wait(for: [expectation], timeout: 2.0)
  }
}

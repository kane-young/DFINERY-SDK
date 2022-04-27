//
//  RequestBuilderTests.swift
//  DFINERY-SDKTests
//
//  Created by 이영우 on 2022/04/25.
//

import CoreTelephony
import Network
import XCTest
@testable import DfineryAnalytics

final class RequestBuilderTests: XCTestCase {
  private var sut: RequestBuilder!

  func test_when_addEvent에_대한_HttpRequestBody_then_정상적으로_인코딩_확인() {
    // given
    let monitor = NWPathMonitor(requiredInterfaceType: .cellular)
    let device = FakeDevice(
      systemVersion: "15.3",
      name: "iPhone 13 mini",
      orientation: .portrait
    )
    let screen = FakeScreen(
      width: 750.0,
      height: 1334.0
    )
    let carrier = FakeCarrier(
      carrierName: "KT"
    )
    let carriers: [String: CTCarrierLogic] = [
      "dummyKey": carrier
    ]
    let languages = ["ko-kr"]
    self.sut = RequestBuilder(
      monitor: monitor,
      device: device,
      screen: screen,
      carriers: carriers,
      languages: languages
    )
    let userAdvertisement = UserAdvertisement(
      enableGettingIDFA: true,
      appleAdvertisingIdentifier: "12531864-3040-0237-1290-541026403320"
    )
    let location = Location(
      latitude: 23.0,
      longitude: 322.1
    )

    let expectedPackageName = """
       "package_name" : "com.apple.dt.xctest.tool",
    """
    let expectedEvent = """
      "event" : "Touch Login Button"
    """
    let expectedAppKey = """
      "appkey" : "appKey lyw2100@naver.com"
    """

    // when
    let data = self.sut.httpRequestBody(
      with: "lyw2100@naver.com",
      eventName: "Touch Login Button",
      eventProperties: ["menu_name": "login"],
      userProperties: ["gender": "male"],
      userAdvertisement: userAdvertisement,
      location: location
    )
    let textToCompare = String(data: data!, encoding: .utf8)!

    XCTAssertTrue(textToCompare.contains(expectedPackageName))
    XCTAssertTrue(textToCompare.contains(expectedEvent))
    XCTAssertTrue(textToCompare.contains(expectedAppKey))
  }
}

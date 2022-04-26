//
//  IGASDK.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import Foundation

final class IGASDK {

  // MARK: Properties

  public static let getInstance = IGASDK()

  private let eventLogger: EventLoggerLogic
  private var appKey: String = ""
  private var userProperties: [String: Any]?
  private var userAdvertisement: UserAdvertisement
  private var location: Location?


  // MARK: Initializers

  public init(eventLogger: EventLoggerLogic = EventLogger()) {
    self.eventLogger = eventLogger
    self.userAdvertisement = UserAdvertisement()
  }

  public func initIGASDK(appKey: String) {
    self.appKey = appKey
  }

  public func setUserProperties(with keyValues: [String: Any]) {
    self.userProperties = keyValues
  }

  public func addEvent(appKey: String, eventName: String, eventProperties: [String: Any]? = nil) {
    self.eventLogger.logEvent(
      appKey: appKey,
      eventName: eventName,
      eventProperties: eventProperties,
      userProperties: self.userProperties,
      userAdvertisement: self.userAdvertisement,
      location: self.location
    )
  }


  // MARK: Set IDFA

  public func startGettingIDFA() {
    self.userAdvertisement.enableGettingIDFA = true
  }

  public func stopGettingIDFA() {
    self.userAdvertisement.enableGettingIDFA = false
  }

  public func setAppleAdvertisingIdentifier(_ appleAdvertisingIdentifier: String) {
    self.userAdvertisement.appleAdvertisingIdentifier = appleAdvertisingIdentifier
  }


  // MARK: Set Location

  public func setLocation(latitude: Double, longitude: Double) {
    self.location = Location(latitude: latitude, longitude: longitude)
  }
}

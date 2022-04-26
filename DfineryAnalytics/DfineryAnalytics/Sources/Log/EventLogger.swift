//
//  EventLogger.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/26.
//

import Foundation

public protocol EventLoggerLogic {
  func logEvent(appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?)
}

public final class EventLogger: EventLoggerLogic {

  // MARK: Properties

  private let httpClient: HTTPClientLogic


  // MARK: Initializers

  public init(httpClient: HTTPClientLogic = HTTPClient()) {
    self.httpClient = httpClient
  }

  public func logEvent(appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?) {
    self.httpClient.createEvent(
      appKey: appKey,
      eventName: eventName,
      eventProperties: eventProperties,
      userProperties: userProperties,
      userAdvertisement: userAdvertisement,
      location: location) { result in
        switch result {
        case .success(let response):
          if response.result == true {
            Log.custom(category: "Event", "Add \"\(eventName)\" event")
          } else {
            Log.error("Failure Log Event - Invalid Log Format")
          }
        case .failure(let error):
          Log.error("Failure Log Event - \(error.message)")
        }
      }
  }
}


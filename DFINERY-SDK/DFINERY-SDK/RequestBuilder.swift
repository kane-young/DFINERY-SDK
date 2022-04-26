//
//  RequestBuilder.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import CoreTelephony
import Network
import UIKit

protocol RequestBuilderLogic {
  func httpRequestBody(with appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?) -> Data?
}

public final class RequestBuilder: RequestBuilderLogic {

  // MARK: Properties

  private let monitor: NWPathMonitor
  private let device: UIDevice
  private let screen: UIScreen
  private let carriers: [String: CTCarrier]?
  private let languages: [String]


  // MARK: Initializers

  public init(monitor: NWPathMonitor = NWPathMonitor(),
       device: UIDevice = UIDevice.current,
       screen: UIScreen = UIScreen.main,
       carriers: [String: CTCarrier]? = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders,
       languages: [String] = NSLocale.preferredLanguages) {
    self.monitor = monitor
    self.device = device
    self.screen = screen
    self.carriers = carriers
    self.languages = languages
    self.monitor.start(queue: DispatchQueue.global())
  }

  deinit {
    self.monitor.cancel()
  }


  // MARK: HTTP Request Body (Data?)

  func httpRequestBody(with appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?) -> Data? {
    let keyValues: [String: Any] = self.keyValues(
      with: appKey,
      eventName: eventName,
      eventProperties: eventProperties,
      userProperties: userProperties,
      userAdvertisement: userAdvertisement,
      location: location
    )
    let data = self.encode(keyValues)
    return data
  }

  private func keyValues(with appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?) -> [String: Any] {
    return [
      "evt": self.eventKeyValues(
        with: eventName,
        eventProperties: eventProperties,
        userProperties: userProperties,
        location: location
      ),
      "common": self.commonInfoKeyValues(
        with: appKey,
        userAdvertisement: userAdvertisement
      )
    ]
  }

  private func encode(_ keyValues: [String: Any]) -> Data? {
    guard let jsonData = try? JSONSerialization.data(
      withJSONObject: keyValues,
      options: .prettyPrinted
    ) else {
      return nil
    }
    return jsonData
  }

  private func eventKeyValues(with eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, location: Location?) -> [String: Any] {
    var keyValues: [String: Any] = [
      "created_at": self.createdDateText(),
      "event": eventName
    ]
    if let location = self.locationKeyValues(with: location) {
      keyValues["location"] = location
    }
    if let eventParameters = eventProperties {
      keyValues["param"] = eventParameters
    }
    if let userProperties = userProperties {
      keyValues["user_properties"] = userProperties
    }
    return keyValues
  }

  private func createdDateText() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmss"
    let dateText = dateFormatter.string(from: date)
    return dateText
  }

  private func locationKeyValues(with location: Location?) -> [String: Double]? {
    guard let location = location else { return nil }
    return ["lat": location.latitude, "lng": location.longitude]
  }

  private func commonInfoKeyValues(with appKey: String, userAdvertisement: UserAdvertisement) -> [String: Any] {
    var keyValues: [String: Any] = [
      "identity": self.identityKeyValues(with: userAdvertisement),
      "device_info": self.deviceKeyValues(),
      "appkey": self.appKey(with: appKey)
    ]
    if let packageName = self.packageName() {
      keyValues["package_name"] = packageName
    }
    return keyValues
  }

  private func identityKeyValues(with userAdvertisement: UserAdvertisement) -> [String: Any] {
    let enabled = userAdvertisement.enableGettingIDFA
    let advertisingIdentifier = enabled == true ? userAdvertisement.appleAdvertisingIdentifier : UserAdvertisement.defaultIdentifier
    return ["adid": advertisingIdentifier, "adid_opt_out": enabled]
  }

  private func deviceKeyValues() -> [String: Any] {
    var keyValues: [String: Any] = [
      "os": self.osVersion(),
      "model": self.deviceModel(),
      "resolution": self.resolution(),
      "is_portrait": self.isPortrait(),
      "platform": self.platForm(),
      "network": self.networkStatus()
    ]
    if let carrierName = self.carrierName() {
      keyValues["carrier"] = carrierName
    }
    if let pair = self.languageRegionPair() {
      keyValues["language"] = pair.language
      keyValues["country"] = pair.region
    }
    return keyValues
  }

  private func osVersion() -> String {
    return self.device.systemVersion
  }

  private func deviceModel() -> String {
    return self.device.name
  }

  private func resolution() -> String {
    let nativeBounds = self.screen.nativeBounds
    let width = Int(nativeBounds.width)
    let height = Int(nativeBounds.height)
    return "\(width)x\(height)"
  }

  private func isPortrait() -> Bool {
    return self.device.orientation == .portrait
  }

  private func platForm() -> String {
    return "iOS"
  }

  private func networkStatus() -> String {
    if self.monitor.currentPath.usesInterfaceType(.wifi) {
      return "wifi"
    } else if self.monitor.currentPath.usesInterfaceType(.cellular) {
      return "cellular"
    } else {
      return "disconnect"
    }
  }

  private func carrierName() -> String? {
    guard let carriers = self.carriers?.values else { return nil }
    let carrierName = carriers
      .filter { $0.carrierName != nil }
      .map { $0.carrierName! }
      .joined(separator: "+")
    return carrierName
  }

  private func languageRegionPair() -> (language: String, region: String)? {
    guard let section = self.languages.first?.split(separator: "-") else { return nil }
    return (String(section[0]), String(section[1]))
  }

  private func packageName() -> String? {
    guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
    return "\(bundleIdentifier)"
  }

  private func appKey(with key: String) -> String {
    return "appKey \(key)"
  }
}

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

  private var appKey: String = ""
  private var userProperties: [String: Any]?


  public func initIGASDK(appKey: String) {
    self.appKey = appKey
  }

  public func setUserProperties(with keyValues: [String: Any]) {
    self.userProperties = keyValues
  }

  public func addEvent(appKey: String, eventName: String, eventProperties: [String: Any]? = nil) {
    
  }


  // MARK: Set IDFA

  public func startGettingIDFA() {
   
  }

  public func stopGettingIDFA() {
    
  }

  public func setAppleAdvertisingIdentifier(_ appleAdvertisingIdentifier: String) {
    
  }


  // MARK: Set Location

  public func setLocation(latitude: Double, longitude: Double) {
    
  }
}


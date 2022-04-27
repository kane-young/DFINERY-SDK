//
//  ViewController.swift
//  DfineryAnalyticsDemo
//
//  Created by 이영우 on 2022/04/27.
//

import AdSupport
import AppTrackingTransparency
import UIKit

import DfineryAnalytics

final class ViewController: UIViewController {

  private let igaSDK = IGASDK.getInstance

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.requestPermission()
  }

  func requestPermission() {
    ATTrackingManager.requestTrackingAuthorization { status in
      switch status {
      case .authorized:
        self.igaSDK.startGettingIDFA()
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        self.igaSDK.setAppleAdvertisingIdentifier(idfa)
      case .denied:
        self.igaSDK.stopGettingIDFA()
      case .notDetermined:
        self.igaSDK.stopGettingIDFA()
      case .restricted:
        self.igaSDK.stopGettingIDFA()
      @unknown default:
        self.igaSDK.stopGettingIDFA()
      }
    }
  }
}

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

final class MainViewController: UIViewController {

  // MARK: Properties

  private let igaSDK = IGASDK.getInstance


  // MARK: Override Function

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


  // MARK: Action Method

  @IBAction func touchBlueButton(_ sender: UIButton) {
    self.igaSDK.addEvent(eventName: "Touch Button", eventProperties: [
      "Color": "Blue"
    ])
  }

  @IBAction func touchRedButton(_ sender: UIButton) {
    self.igaSDK.addEvent(eventName: "Touch Button", eventProperties: [
      "Color": "Red"
    ])
  }

  @IBAction func touchGreenButton(_ sender: UIButton) {
    self.igaSDK.addEvent(eventName: "Touch Button", eventProperties: [
      "Color": "Green"
    ])
  }

  @IBAction func touchYellowButton(_ sender: UIButton) {
    self.igaSDK.addEvent(eventName: "Touch Button", eventProperties: [
      "Color": "Yellow"
    ])
  }
}

//
//  AppDelegate.swift
//  DfineryAnalyticsDemo
//
//  Created by 이영우 on 2022/04/27.
//

import CoreLocation
import UIKit

import DfineryAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  private let locationManager = CLLocationManager()
  private let igaSDK = IGASDK.getInstance

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    self.igaSDK.initIGASDK(appKey: "ss@naver.com")
    self.igaSDK.setUserProperties(with: [
      "gender": "male",
      "age": 28,
      "name": "youngwoo Lee"
    ])

    self.locationManager.delegate = self
    self.requestLocationUsagePermission()

    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("location error is = \(error.localizedDescription)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.setLocation()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      self.setLocation()
      print("Location 설정")
    case .restricted, .notDetermined:
      print("GPS 권한 설정되지 않음")
    case .denied:
      print("GPS 권한 요청 거부됨")
    default:
      print("GPS: Default")
    }
  }

  func requestLocationUsagePermission() {
    self.locationManager.requestWhenInUseAuthorization()
  }

  func setLocation() {
    if let coordinate = self.locationManager.location?.coordinate {
      self.igaSDK.setLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
  }
}

//
//  AppDelegate.swift
//  SanntidsappenFagdagDemo
//
//  Created by Tri Nguyen on 25/10/2023.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let locationHandler = LocationManager.shared

        if locationHandler.updatesStarted {
            locationHandler.startLocationUpdates()
        }

        if locationHandler.backgroundActivity {
            locationHandler.backgroundActivity = true
        }

        return true
    }
}

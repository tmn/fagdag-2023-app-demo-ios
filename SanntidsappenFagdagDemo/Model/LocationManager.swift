//
//  LocationManager.swift
//  SanntidsappenFagdagDemo
//
//  Created by Tri Nguyen on 25/10/2023.
//

import Foundation
import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()

    private var manager: CLLocationManager
    private var background: CLBackgroundActivitySession? = nil

    @Published var lastLocation = CLLocation()
    @Published var isStationary = false
    @Published var count = 0

    @Published
    var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveUpdateStarted") {
        didSet { UserDefaults.standard.set(updatesStarted, forKey: "liveUpdateStarted")}
    }

    @Published
    var backgroundActivity: Bool = UserDefaults.standard.bool(forKey: "BGActivitySessionStarted") {
        didSet {
            backgroundActivity ? self.background = CLBackgroundActivitySession() : self.background?.invalidate()
            UserDefaults.standard.set(backgroundActivity, forKey: "BGActivitySessionStarted")
        }
    }

    override init() {
        self.manager = CLLocationManager()

        super.init()
        self.manager.delegate = self
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.startLocationUpdates()
    }

    func startLocationUpdates() {
        if self.manager.authorizationStatus == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }

        Task() {
            do {
                DispatchQueue.main.async {
                    self.updatesStarted = true
                }

                let updates = CLLocationUpdate.liveUpdates()

                for try await update in updates {
                    if !self.updatesStarted { break }
                    if let loc = update.location {
                        DispatchQueue.main.async {
                            self.lastLocation = loc
                            self.isStationary = update.isStationary
                        }
                    }
                }
            } catch {
                print("Could not start location updates")
            }

            return
        }
    }

    func stopLocationUpdates() {
        print("Stopping location updates")
        self.updatesStarted = false
    }
}

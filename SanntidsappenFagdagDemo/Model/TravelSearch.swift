//
//  TravelSearch.swift
//  SanntidsappenFagdagDemo
//
//  Created by Tri Nguyen on 20/10/2023.
//

import Foundation

class TravelSearch: ObservableObject {
    @Published var from: String = ""
    @Published var to: String = ""
    @Published var stops: [Stop] = []

    private var fetchTask: Task<Void, Never>?
    private var workingItem: DispatchWorkItem?


    deinit {
        fetchTask?.cancel()
        workingItem?.cancel()
    }

    func fetchStops(query: String) async {
        guard query.count > 2 else {
            if query.count == 0 {
                self.stops = []
            }
            return
        }
        
        fetchTask?.cancel()
        workingItem?.cancel()

        workingItem = DispatchWorkItem {
            self.fetchTask = Task { @MainActor [weak self] in
                guard let self else { return }

                guard let stops = try? await EnTurAPI.geocoder.getAutocompleteBusStop(searchQuery: query) else {
                    return
                }

                let location = LocationManager.shared.lastLocation
                self.stops = stops.stops.sorted(by: { $0.distanceToCurrentLocation(to: location) < $1.distanceToCurrentLocation(to: location) })
            }
        }

        if let item = workingItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.120, execute: item)
        }
    }

}

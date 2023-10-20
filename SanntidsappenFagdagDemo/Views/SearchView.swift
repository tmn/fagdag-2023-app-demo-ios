//
//  SearchView.swift
//  SanntidsappenFagdagDemo
//
//  Created by Tri Nguyen on 25/10/2023.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var travelSearch: TravelSearch
    @Binding var direction: String
    @Binding var presentToSheet: Bool

    var title: String = "Reise til"

    var body: some View {
        NavigationStack {
            VStack {
                SearchField(searchText: $direction, label: title)
                    .padding([.horizontal, .bottom], 16)

                List(travelSearch.stops) { stop in
                    StopListItem(stop: stop)
                        .onTapGesture {
                            direction = stop.name
                            closeSheet()
                        }
                }
                .listStyle(.inset)

                Spacer()
            }
            .onChange(of: direction) {
                Task {
                    await travelSearch.fetchStops(query: direction)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Lukk") {
                        closeSheet()
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func closeSheet() {
        travelSearch.stops = []
        presentToSheet = false
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var travelSearch = TravelSearch()
        @State var presentSheet: Bool = false

        var body: some View {
            SearchView(travelSearch: travelSearch, direction: $travelSearch.from, presentToSheet: $presentSheet)
        }
    }

    return PreviewWrapper()
}




// MARK: - Search Field

struct SearchField: View {
    @State var active: Bool = false

    @Binding var searchText: String

    public var label: String = "Reise til"

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .opacity(0.3)
                TextField(label, text: $searchText, onEditingChanged: { editing in
                    active = editing
                })

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .opacity(0.3)
                    }
                    .tint(.black)
                }
            }
            .padding(7)
            .background(Color(.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
        }
    }
}

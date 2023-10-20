import SwiftUI

struct ContentView: View {
    @State private var presentFromSheet: Bool = false
    @State private var presentToSheet: Bool = false

    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var travelSearch = TravelSearch()

    var body: some View {
        VStack {
            HeaderView()

            VStack(spacing: 0) {
                Title()

                VStack (spacing: 0) {
                    LabeledContent {
                        Button {
                            presentFromSheet.toggle()
                        } label: {
                            TextField("Reise fra", text: $travelSearch.from)
                                .padding(6)
                                .multilineTextAlignment(.leading)
                        }
                    } label: {
                        LabelText("Fra")
                    }
                    .padding(6)

                    Divider()
                        .padding(.horizontal, 16)
                        .background(.white)

                    LabeledContent {
                        Button {
                            presentToSheet.toggle()
                        } label: {
                            TextField("Reise til", text: $travelSearch.to)
                                .padding(6)
                                .multilineTextAlignment(.leading)

                        }
                    } label: {
                        LabelText("Til")
                    }
                    .padding(6)
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
            .offset(y: -115)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

            Spacer()
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $presentFromSheet) {
            SearchView(travelSearch: travelSearch, direction: $travelSearch.from, presentToSheet: $presentFromSheet, title: "Reise fra")
        }
        .sheet(isPresented: $presentToSheet) {
            SearchView(travelSearch: travelSearch, direction: $travelSearch.to, presentToSheet: $presentToSheet, title: "Reise til")
        }
        .onAppear() {
            LocationManager.shared.startLocationUpdates()
        }
    }
}

#Preview {
    ContentView()
}





// MARK: - Helpers


// Tittel på søkefeltet
struct Title: View {
    var body: some View {
        HStack {
            Text("Hvor vil du reise?")
                .font(.system(size: 23))
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding([.bottom], 16)
    }
}

// Header med blå bakgrunn
struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("B")
                Text("e")
                    .offset(y: 15)
                Text("kk")
                    .offset(y: 30)
                Text("Tur")
                    .offset(y: 20)
            }
            .font(.title)
            .padding(.top, 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 250)
        .padding(.leading, 16)
        .background(
            Color("BekkTur")
        )
        .foregroundColor(.white)
    }
}

// Label til søkefelt
struct LabelText: View {
    var text: String = ""

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .frame(width: 35, alignment: .leading)
            .padding(.leading, 16)
    }
}

//
//  StopListItem.swift
//  SanntidsappenFagdagDemo
//
//  Created by Tri Nguyen on 21/10/2023.
//

import SwiftUI

struct StopListItem: View {
    let stop: Stop

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stop.name)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("BekkTur"))

                Text("\(stop.locality), \(stop.county)")
                    .foregroundStyle(Color.gray)
                    .font(.system(size: 14))
            }

            Spacer()
        }
    }
}

#Preview {
    StopListItem(stop: Stop(id: "", name: "Oslo S", locality: "Oslo", county: "Oslo", coordinates: [0, 0]))
}

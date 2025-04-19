//
//  ProgramaticCarousel.swift
//  ProgrammaticCarousel
//
//  Created by Philippe Muniz Gomes on 18/04/25.
//

import SwiftUI

fileprivate enum CarouselDirection {
    case previous
    case next
    case goTo(index: Int)
}

struct ProgramaticCarousel: View {
    @State private var selectedPage: Int = 0
    @State private var items: Int = 1
    @State private var customIndex: Int = 0

    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(0..<items, id: \.self) { item in
                    TabContent(data: item.description)
                        .tag(item)
                }
            }
            .tabViewStyle(.page)

            Text("Total: \(items)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .padding()

            HStack(alignment: .center) {
                Button {
                    removePage()
                } label: {
                    Label("", systemImage: "minus.circle.fill")
                        .font(.system(size: 30))
                        .tint(.red)
                }

                Button {
                    addPage()
                } label: {
                    Label("", systemImage: "plus.circle.fill")
                        .font(.system(size: 30))
                }
            }


            Spacer()

            TextField("Page Index", value: $customIndex, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

            Button {
                navigate(direction: .goTo(index: customIndex))
            } label: {
                Text("Go to page")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            HStack(alignment: .center) {
                Button("Prev") { navigate(direction: .previous) }
                .buttonStyle(.borderedProminent)

                Spacer()

                Button("Next") { navigate(direction: .next) }
                .buttonStyle(.borderedProminent)
            }.padding(.top, 40)
        }
        .padding()
    }

    private func addPage() {
        items += 1
    }

    private func removePage() {
        if items - 1 >= 0 {
            items -= 1
        }
    }

    private func navigate(direction: CarouselDirection) {
        switch direction {
            case .previous:
                if selectedPage - 1 >= 0 {
                    selectedPage -= 1
                }
            case .next:
                if selectedPage + 1 < items {
                    selectedPage += 1
                }
            case .goTo(let index):
                if index >= 0 && index < items {
                    selectedPage = index
                }
        }
    }
}

fileprivate struct TabContent: View {
    var data: String

    var body: some View {
        Text("Data: \(data)")
            .frame(width: 200, height: 200)
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}

public extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0..<255),
            green: .random(in: 0..<255),
            blue: .random(in: 0..<255)
        )
    }
}

#Preview {
    ProgramaticCarousel()
}

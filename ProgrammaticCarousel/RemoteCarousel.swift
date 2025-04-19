//
//  RemoteCarousel.swift
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

/// 1 - Criar uma preferenceKey
/// 2 - Criar uma funcao que utilize o onPreferenceChange
///

struct PaginationInfo: Equatable {
    let currentPage: Int
    let totalPages: Int
}

private struct PaginationPreferenceKey: PreferenceKey {
    static var defaultValue: PaginationInfo = .init(currentPage: 0, totalPages: 0)

    static func reduce(value: inout PaginationInfo, nextValue: () -> PaginationInfo) {
        value = nextValue()
    }
}

extension View {
    func onPaginating(perform action: @escaping (_ currentPage: Int, _ totalPages: Int) -> Void) -> some View {
        self.onPreferenceChange(PaginationPreferenceKey.self) { info in
            action(info.currentPage, info.totalPages)
        }
    }
}

struct RemoteCarousel: View {
    @Binding var externalIndex: Int

    @State private var internalIndex: Int = 0
    @State private var items: Int = 10
    @State private var customIndex: Int = 0

    var body: some View {
        VStack {
            TabView(selection: $internalIndex) {
                ForEach(0..<items, id: \.self) { item in
                    TabContent(data: item.description)
                        .tag(item)
                }
            }
            .tabViewStyle(.page)
            .preference(
                key: PaginationPreferenceKey.self,
                value: PaginationInfo(currentPage: internalIndex, totalPages: items)
            )
            .onChange(of: internalIndex) {
                externalIndex = internalIndex
            }
            .onChange(of: externalIndex) {
                if internalIndex != externalIndex {
                    internalIndex = externalIndex
                }
            }
        }
        .padding()
    }
}

struct Plugin: View {
    @State private var selectedPage: Int = 0
    @State private var items: Int = 10

    @State private var carouselCallbackCurrentPage: Int = 0
    @State private var carouselCallbackTotal: Int = 0

    var body: some View {
        VStack {
            RemoteCarousel(externalIndex: $selectedPage)
                .onPaginating { current, total in
                    print("📘 Página atual: \(current) de \(total)")
                    carouselCallbackCurrentPage = current
                    carouselCallbackTotal = total
                }

            HStack(alignment: .center) {
                Button("Prev") { navigate(direction: .previous) }
                .buttonStyle(.borderedProminent)

                Spacer()

                Button("Next") { navigate(direction: .next) }
                .buttonStyle(.borderedProminent)
            }.padding(.top, 40)

            Text("📘 Page \(carouselCallbackCurrentPage) of \(carouselCallbackTotal)")
        }
        .padding()
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

#Preview {
    Plugin()
}

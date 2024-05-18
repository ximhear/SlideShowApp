//
//  SlideShow.swift
//  SlideShowApp
//
//  Created by gzonelee on 5/18/24.
//

import SwiftUI

struct SlideShow: View {
    @State var views: [AnyView]
    @State var currentIndex: Int = 0
    @State var offsetX: CGFloat = 0
    @State var draggingOffsetX: CGFloat = 0
    @State private var startTime: Date?
    @State var size: CGSize = .zero

    let colors: [Color] = [.red, .green, .blue, .orange, .purple]
    
    let  contentSpacing: CGFloat = 4
    
    var body: some View {
        VStack {
            Text("page : \(currentIndex)")
            Text("offsetX : \(offsetX + draggingOffsetX)")
            Text("sizeX : \(size.width / 2)")
            Text("centerX : \(centerX)")
            GeometryReader(content: { geometry in
                HStack(spacing: 0) {
                    if views.isEmpty {
                        Text("Empty")
                    }
                    else {
                        HStack(spacing: contentSpacing) {
                            ForEach(0..<views.count) { index in
                                views[index]
                                    .frame(width: geometry.size.width * 2 / 3)
                                    .frame(height: geometry.size.height)
                                    .background(colors[index % 5])
                                    .contentShape(Rectangle())
                                    .scaleEffect(scaleOf(index: index))
                                    .opacity(opacityOf(index: index))
                                    .padding(.leading,
                                             index == 0 ? geometry.size.width / 3 / 2 : 0)
                            }
                        }
                        .offset(.init(width: offsetX + draggingOffsetX, height: 0))
                        .clipped()
                    }
                }
                .gesture(DragGesture()
                    .onChanged { value in
                    GZLogFunc(value.translation.width)
                        draggingOffsetX = value.translation.width
                        if startTime == nil {
                            startTime = Date()
                        }
                    }
                    .onEnded { value in
                        GZLogFunc(value.translation.width)
                        GZLogFunc(value.predictedEndTranslation.width)
                        
                        let endTime = Date()
                        guard let startTime = startTime else { return }
                        let duration = endTime.timeIntervalSince(startTime)
                        
                        let dragDistance = value.translation
                        let speed = sqrt(dragDistance.width * dragDistance.width + dragDistance.height * dragDistance.height) / CGFloat(duration)
                        
                        let minimumDistance: CGFloat = 50  // 최소 드래그 거리
                        let minimumSpeed: CGFloat = 500     // 최소 스와이프 속도 (points per second)
                        
                        self.startTime = nil
                        
                        var swiped = false
                        
                        var newIndex = currentIndex
                        
                        if abs(dragDistance.width) > abs(dragDistance.height) {
                            // 가로 스와이프
                            if abs(dragDistance.width) > minimumDistance && speed > minimumSpeed {
                                if dragDistance.width < 0 {
                                    // Left swipe
                                    if newIndex < views.count-1 {
                                        newIndex += 1
                                    }
                                    swiped = true
                                } else {
                                    // Right swipe
                                    GZLogFunc("Swiped Right")
                                    if newIndex > 0 {
                                        newIndex -= 1
                                    }
                                    swiped = true
                                }
                            }
                        }

                        if swiped == false {
                            if abs(value.predictedEndTranslation.width) > geometry.size.width / 2 {
                                if value.predictedEndTranslation.width > 0 {
                                    if newIndex > 0 {
                                        newIndex -= 1
                                    }
                                }
                                else {
                                    if newIndex < views.count-1 {
                                        newIndex += 1
                                    }
                                }
                            }
                        }
                        withAnimation {
                            currentIndex = newIndex
                            draggingOffsetX = 0
                            offsetX = -(CGFloat(newIndex) * geometry.size.width * 2 / 3 + contentSpacing * CGFloat(newIndex))
                        }
                    }
                )
                .onChange(of: offsetX, { oldValue, newValue in
                    GZLogFunc(offsetX)
                    GZLogFunc(geometry.size.width)
                })
                .background(Color.yellow.opacity(0.3))
                .frame(maxWidth: .infinity)
            })
            .readSize($size)
        }
    }
    
    var centerX: CGFloat {
        if currentIndex > 0 {
            size.width / 3 / 2 + size.width * 2 / 3 / 2 + size.width * 2 / 3  * CGFloat(currentIndex) + contentSpacing * CGFloat(currentIndex)
        }
        else {
            size.width / 3 / 2 + size.width * 2 / 3 / 2
        }
    }
    
    func centerXOf(index: Int) -> CGFloat {
        if index > 0 {
            size.width / 3 / 2 + size.width * 2 / 3 / 2 + size.width * 2 / 3  * CGFloat(index) + contentSpacing * CGFloat(index) + draggingOffsetX
        }
        else {
            size.width / 3 / 2 + size.width * 2 / 3 / 2 + draggingOffsetX
        }
    }
    
    func scaleOf(index: Int) -> CGFloat {
        
        let dist = abs(centerX - centerXOf(index: index))
        if index == 1 {
//            let a = min(dist / size.width * 0.7, 1)
//            GZLogFunc(centerX)
//            GZLogFunc(centerXOf(index: index))
            GZLogFunc(1 - min(dist / size.width * 0.2, 1))
        }
        return 1 - min(dist / size.width * 0.2, 1)
    }
    func opacityOf(index: Int) -> CGFloat {
        
        let dist = abs(centerX - centerXOf(index: index))
        if index == 1 {
//            let a = min(dist / size.width * 0.7, 1)
//            GZLogFunc(centerX)
//            GZLogFunc(centerXOf(index: index))
//            GZLogFunc(1 - min(dist / size.width * 0.3, 1))
        }
        return 1 - min(dist / size.width * 0.3, 1)
    }
}

#Preview {
    VStack(spacing: 0) {
        Divider()
        VStack {
            SlideShow(views: [
                VStack {
                    Text("Hello0")
                }.av(),
                VStack {
                    Text("Hello1")
                }.av(),
                VStack {
                    Text("Hello2")
                }.av(),
                VStack {
                    Text("Hello3")
                }.av(),
                VStack {
                    Text("Hello4")
                }.av(),
            ])
            .clipped()
            .padding(32)
        }
        .frame(height: 500)
        .background(.red.opacity(0.3))
        EmptyView()
    }
}

extension View {
    func av() -> AnyView {
        AnyView(self)
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = [CGSize]

    static var defaultValue: [CGSize] = []

    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}

struct SizeModifier: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: [geometry.size])
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { sizes in
                if let first = sizes.first {
                    DispatchQueue.main.async {
                        self.size = first
                    }
                }
            }
    }
}

extension View {
    func readSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeModifier(size: size))
    }
}

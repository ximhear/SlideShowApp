//
//  ContentView.swift
//  SlideShowApp
//
//  Created by gzonelee on 5/18/24.
//

import SwiftUI

struct ContentView: View {
    @State var size: CGSize = .zero
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
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
                } label: {
                    Text("slide")
                }

                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                Text("\(size.width)")
                VStack {
                    //                SlideShow(views: [
                    VStack {
                        Text("Hello0")
                    }.av()
                    VStack {
                        Text("Hello1")
                    }.av()
                    VStack {
                        Text("Hello2")
                    }.av()
                    VStack {
                        Text("Hello3")
                    }.av()
                    VStack {
                        Text("Hello4")
                    }.av()
                    //                ])
                    //                .clipped()
                    //                .padding(32)
                }
                .frame(height: 300)
                .readSize($size)
                
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

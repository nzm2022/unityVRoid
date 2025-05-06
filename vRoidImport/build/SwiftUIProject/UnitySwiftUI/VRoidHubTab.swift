//
//  VRoidHubTab.swift
//  UnitySwiftUI
//
//  Created by Nozomu Yasui on 2025/04/10.
//


import SwiftUI

struct VRoidHubTab: View {
    @StateObject private var auth = VRoidAuthManager()
    @StateObject private var viewModel = VRoidViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if let token = auth.accessToken {
                    List(viewModel.characters) { character in
                        HStack {
                            AsyncImage(url: character.thumbnailUrl) { phase in
                                if let image = phase.image {
                                    image.resizable().frame(width: 64, height: 64)
                                } else {
                                    ProgressView()
                                }
                            }
                            Text(character.name)
                            Spacer()
                            Button("Download") {
                                if let modelUrl = character.modelUrl {
                                    viewModel.downloadModel(from: modelUrl) { savedURL in
                                        print("Model saved to: \(String(describing: savedURL))")
                                        // You can now pass this path to Unity
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        viewModel.fetchCharacters(accessToken: token)
                    }
                } else {
                    Button("Login to VRoid Hub") {
                        auth.startLogin()
                    }
                }
            }
            .navigationTitle("VRoid Characters")
        }
    }
}
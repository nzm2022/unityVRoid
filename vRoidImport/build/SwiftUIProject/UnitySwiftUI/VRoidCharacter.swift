//
//  VRoidCharacter.swift
//  UnitySwiftUI
//
//  Created by Nozomu Yasui on 2025/04/10.
//


import Foundation
import SwiftUI

struct VRoidCharacter: Identifiable, Decodable {
    let id: String
    let name: String
    let thumbnailUrl: URL?
    let modelUrl: URL?

    enum CodingKeys: String, CodingKey {
        case id, name
        case thumbnail = "thumbnail"
        case model = "model"
    }

    enum ThumbnailKeys: String, CodingKey {
        case url
    }

    enum ModelKeys: String, CodingKey {
        case vrm
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        if let thumb = try? container.nestedContainer(keyedBy: ThumbnailKeys.self, forKey: .thumbnail) {
            thumbnailUrl = try? thumb.decode(URL.self, forKey: .url)
        } else {
            thumbnailUrl = nil
        }

        if let model = try? container.nestedContainer(keyedBy: ModelKeys.self, forKey: .model) {
            modelUrl = try? model.decode(URL.self, forKey: .vrm)
        } else {
            modelUrl = nil
        }
    }
}

class VRoidViewModel: ObservableObject {
    @Published var characters: [VRoidCharacter] = []

    func fetchCharacters(accessToken: String) {
        guard let url = URL(string: "https://hub.vroid.com/api/characters") else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode([String: [VRoidCharacter]].self, from: data)
                DispatchQueue.main.async {
                    self.characters = json["characters"] ?? []
                }
            } catch {
                print("Failed to decode:", error)
            }
        }.resume()
    }

    func downloadModel(from url: URL, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { location, _, _ in
            guard let location = location else { completion(nil); return }

            let destURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("downloaded_model.vrm")

            try? FileManager.default.removeItem(at: destURL)
            try? FileManager.default.moveItem(at: location, to: destURL)
            completion(destURL)
        }
        task.resume()
    }
}
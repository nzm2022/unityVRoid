//
//  VRoidAuthManager.swift
//  UnitySwiftUI
//
//  Created by Nozomu Yasui on 2025/04/10.
//


import Foundation
import AuthenticationServices

class VRoidAuthManager: NSObject, ObservableObject {
    @Published var accessToken: String?
    private var authSession: ASWebAuthenticationSession?

    let clientId = "YOUR_CLIENT_ID"
    let redirectUri = "YOUR_REDIRECT_URI"

    func startLogin() {
        let authURL = URL(string:
            "https://hub.vroid.com/oauth2/authorize?client_id=\(clientId)&response_type=token&redirect_uri=\(redirectUri)&scope=read"
        )!

        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: redirectUri) { [weak self] callbackURL, error in
            guard let callbackURL = callbackURL, error == nil else { return }
            if let fragment = callbackURL.fragment {
                let params = fragment.components(separatedBy: "&")
                for param in params {
                    let parts = param.components(separatedBy: "=")
                    if parts.first == "access_token" {
                        self?.accessToken = parts.last
                        break
                    }
                }
            }
        }
        authSession?.presentationContextProvider = self
        authSession?.start()
    }
}

extension VRoidAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
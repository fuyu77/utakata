import Foundation

enum AppConfiguration {
    static var rootURL: URL {
        if let value = ProcessInfo.processInfo.environment["UTAKATA_ROOT_URL"],
           let url = URL(string: value) {
            return url
        }

#if DEBUG
        return URL(string: "http://localhost:3000")!
#else
        return URL(string: "https://utakatanka.jp")!
#endif
    }

    static var remotePathConfigurationURL: URL {
        rootURL.appending(path: "configurations/ios_v1.json")
    }
}

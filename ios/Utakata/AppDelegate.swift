import HotwireNative
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureHotwire()
        return true
    }

    private func configureHotwire() {
        Hotwire.config.applicationUserAgentPrefix = "Utakata"
        Hotwire.config.showDoneButtonOnModals = true

#if DEBUG
        Hotwire.config.debugLoggingEnabled = true
#endif

        guard let localConfigurationURL = Bundle.main.url(
            forResource: "path-configuration",
            withExtension: "json"
        ) else {
            assertionFailure("path-configuration.json is missing from the app bundle")
            return
        }

        Hotwire.loadPathConfiguration(from: [
            .file(localConfigurationURL),
            .server(AppConfiguration.remotePathConfigurationURL)
        ])
    }
}

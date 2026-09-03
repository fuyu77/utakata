import HotwireNative
import UIKit

final class AppCoordinator: NSObject {
    private enum State {
        case authentication
        case main
    }

    private weak var window: UIWindow?
    private var state: State?
    private var authenticationNavigator: Navigator?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showAuthentication(animated: false)
    }

    private func showAuthentication(animated: Bool = true) {
        guard state != .authentication else { return }

        state = .authentication
        let navigator = Navigator(
            configuration: .init(
                name: "authentication",
                startLocation: AppConfiguration.authenticationURL
            ),
            delegate: self
        )
        authenticationNavigator = navigator

        setRootViewController(navigator.rootViewController, animated: animated)
        navigator.start()
    }

    private func showMain() {
        guard state != .main else { return }

        state = .main
        let tabBarController = BottomTabBarController(
            navigatorDelegate: self,
            lazyLoadTabs: true
        )
        let items = makeTabItems()

        tabBarController.load(items.map(\.tab))
        tabBarController.configureBottomBar(items: items)
        tabBarController.configureFeedBar(
            items: [
                FeedTabItem(title: "人気", url: AppConfiguration.rootURL),
                FeedTabItem(title: "新着", url: AppConfiguration.url(path: "tanka")),
                FeedTabItem(title: "フォロー中", url: AppConfiguration.url(path: "timeline"))
            ],
            in: items[0].tab
        )

        setRootViewController(tabBarController, animated: true)
        authenticationNavigator = nil
    }

    private func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window else { return }

        if animated {
            UIView.transition(
                with: window,
                duration: 0.25,
                options: .transitionCrossDissolve
            ) {
                window.rootViewController = viewController
            }
        } else {
            window.rootViewController = viewController
        }
    }

    private func makeTabItems() -> [BottomTabItem] {
        [
            BottomTabItem(
                tab: HotwireTab(
                    id: "tanka",
                    title: "",
                    image: UIImage(systemName: "house"),
                    selectedImage: UIImage(systemName: "house.fill"),
                    url: AppConfiguration.rootURL
                ),
                accessibilityLabel: "短歌"
            ),
            BottomTabItem(
                tab: HotwireTab(
                    id: "search",
                    title: "",
                    image: UIImage(systemName: "magnifyingglass"),
                    url: AppConfiguration.url(path: "tanka/search")
                ),
                accessibilityLabel: "検索"
            ),
            BottomTabItem(
                tab: HotwireTab(
                    id: "notifications",
                    title: "",
                    image: UIImage(systemName: "bell"),
                    selectedImage: UIImage(systemName: "bell.fill"),
                    url: AppConfiguration.url(path: "notifications")
                ),
                accessibilityLabel: "通知"
            ),
            BottomTabItem(
                tab: HotwireTab(
                    id: "mypage",
                    title: "",
                    image: UIImage(systemName: "person"),
                    selectedImage: UIImage(systemName: "person.fill"),
                    url: AppConfiguration.url(path: "native/mypage")
                ),
                accessibilityLabel: "マイページ"
            )
        ]
    }
}

extension AppCoordinator: NavigatorDelegate {
    func handle(proposal: VisitProposal, from navigator: Navigator) -> ProposalResult {
        if state == .main && proposal.url.matches(AppConfiguration.signInURL) {
            DispatchQueue.main.async { [weak self] in
                self?.showAuthentication()
            }
            return .reject
        }

        return .accept
    }

    func requestDidFinish(at url: URL) {
        guard state == .authentication,
              url.matches(AppConfiguration.authenticationURL),
              let finalURL = authenticationNavigator?.session.webView.url,
              finalURL.matches(AppConfiguration.authenticationURL) else { return }

        showMain()
    }
}

private extension URL {
    func matches(_ other: URL) -> Bool {
        scheme == other.scheme &&
            host == other.host &&
            port == other.port &&
            normalizedPath == other.normalizedPath
    }

    var normalizedPath: String {
        if path.isEmpty {
            return "/"
        } else if path.count > 1 && path.hasSuffix("/") {
            return String(path.dropLast())
        } else {
            return path
        }
    }
}

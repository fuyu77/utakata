import HotwireNative
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var tabBarController = HotwireTabBarController(lazyLoadTabs: true)

    private let tabs = [
        HotwireTab(
            id: "tanka",
            title: "短歌",
            image: UIImage(systemName: "text.quote"),
            url: AppConfiguration.url(path: "tanka")
        ),
        HotwireTab(
            id: "search",
            title: "検索",
            image: UIImage(systemName: "magnifyingglass"),
            url: AppConfiguration.url(path: "tanka/search"),
            isSearchTab: true
        ),
        HotwireTab(
            id: "notifications",
            title: "通知",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill"),
            url: AppConfiguration.url(path: "notifications")
        ),
        HotwireTab(
            id: "mypage",
            title: "マイページ",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill"),
            url: AppConfiguration.url(path: "native/mypage")
        )
    ]

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window

        tabBarController.load(tabs)
    }
}

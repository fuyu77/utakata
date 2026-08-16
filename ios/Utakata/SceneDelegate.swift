import HotwireNative
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var tabBarController = BottomTabBarController(lazyLoadTabs: true)

    private let tabs = [
        HotwireTab(
            id: "tanka",
            title: "",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"),
            url: AppConfiguration.url(path: "tanka")
        ),
        HotwireTab(
            id: "search",
            title: "",
            image: UIImage(systemName: "magnifyingglass"),
            url: AppConfiguration.url(path: "tanka/search")
        ),
        HotwireTab(
            id: "notifications",
            title: "",
            image: UIImage(systemName: "bell"),
            selectedImage: UIImage(systemName: "bell.fill"),
            url: AppConfiguration.url(path: "notifications")
        ),
        HotwireTab(
            id: "mypage",
            title: "",
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

        let accessibilityLabels = ["短歌", "検索", "通知", "マイページ"]
        tabBarController.configureBottomBar(tabs: tabs, accessibilityLabels: accessibilityLabels)
    }
}

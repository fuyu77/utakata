import HotwireNative
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var tabBarController = BottomTabBarController(lazyLoadTabs: true)

    private let tabItems = [
        BottomTabItem(
            tab: HotwireTab(
                id: "tanka",
                title: "",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill"),
                url: AppConfiguration.url(path: "tanka")
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

        tabBarController.load(tabItems.map(\.tab))
        tabBarController.configureBottomBar(items: tabItems)
    }
}

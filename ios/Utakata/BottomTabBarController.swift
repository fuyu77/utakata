import HotwireNative
import UIKit

struct BottomTabItem {
    let tab: HotwireTab
    let accessibilityLabel: String
}

struct FeedTabItem {
    let title: String
    let url: URL
}

final class BottomTabBarController: HotwireTabBarController {
    private let barContentHeight: CGFloat = 50
    private let feedBarHeight: CGFloat = 49
    private let barBackground = UIView()
    private let buttonStack = UIStackView()
    private let feedBarBackground = UIView()
    private let feedButtonStack = UIStackView()
    private let feedSelectionIndicator = UIView()
    private var tabButtons: [UIButton] = []
    private var feedButtons: [FeedTabButton] = []
    private var feedItems: [FeedTabItem] = []
    private var feedTab: HotwireTab?
    private var currentFeedURL: URL?
    private var feedURLObservation: NSKeyValueObservation?
    private var feedSelectionIndicatorCenterXConstraint: NSLayoutConstraint?
    private var selectedFeedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFeedBar()
        setupBottomBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.bringSubviewToFront(feedBarBackground)
        view.bringSubviewToFront(barBackground)
    }

    func configureBottomBar(items: [BottomTabItem]) {
        // iOS 26の浮遊する標準バーは使わず、画面下端につながるバーを表示する。
        tabBar.isHidden = true
        tabButtons.forEach { $0.removeFromSuperview() }

        tabButtons = items.enumerated().map { index, item in
            makeTabButton(
                tab: item.tab,
                accessibilityLabel: item.accessibilityLabel,
                index: index
            )
        }
        tabButtons.forEach(buttonStack.addArrangedSubview)

        updateSelection(selectedIndex: selectedIndex)
        reserveSpaceForBottomBar()
    }

    func configureFeedBar(items: [FeedTabItem], in tab: HotwireTab) {
        feedItems = items
        feedTab = tab
        feedButtons.forEach { $0.removeFromSuperview() }
        feedSelectionIndicatorCenterXConstraint?.isActive = false
        feedSelectionIndicatorCenterXConstraint = nil
        selectedFeedIndex = nil

        feedButtons = items.enumerated().map { index, item in
            let button = FeedTabButton(title: item.title)
            button.tag = index
            button.addTarget(self, action: #selector(selectFeed(_:)), for: .touchUpInside)
            return button
        }
        feedButtons.forEach(feedButtonStack.addArrangedSubview)

        guard let navigator = navigator(for: tab) else { return }

        currentFeedURL = navigator.session.webView.url ?? tab.url
        feedURLObservation = navigator.session.webView.observe(\.url, options: [.new]) {
            [weak self] webView, _ in
            self?.updateFeedBar(for: webView.url)
        }
        updateFeedBar(for: currentFeedURL)
    }

    private func setupFeedBar() {
        feedBarBackground.translatesAutoresizingMaskIntoConstraints = false
        feedBarBackground.backgroundColor = .systemBackground
        feedBarBackground.isHidden = true
        view.addSubview(feedBarBackground)

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        feedBarBackground.addSubview(separator)

        feedButtonStack.translatesAutoresizingMaskIntoConstraints = false
        feedButtonStack.axis = .horizontal
        feedButtonStack.distribution = .fillEqually
        feedBarBackground.addSubview(feedButtonStack)

        feedSelectionIndicator.translatesAutoresizingMaskIntoConstraints = false
        feedSelectionIndicator.backgroundColor = .systemBlue
        feedSelectionIndicator.layer.cornerRadius = 1.5
        feedSelectionIndicator.isHidden = true
        feedBarBackground.addSubview(feedSelectionIndicator)

        NSLayoutConstraint.activate([
            feedBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedBarBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedBarBackground.heightAnchor.constraint(equalToConstant: feedBarHeight),

            feedButtonStack.leadingAnchor.constraint(equalTo: feedBarBackground.leadingAnchor),
            feedButtonStack.trailingAnchor.constraint(equalTo: feedBarBackground.trailingAnchor),
            feedButtonStack.topAnchor.constraint(equalTo: feedBarBackground.topAnchor),
            feedButtonStack.bottomAnchor.constraint(equalTo: feedBarBackground.bottomAnchor),

            separator.leadingAnchor.constraint(equalTo: feedBarBackground.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: feedBarBackground.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: feedBarBackground.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            feedSelectionIndicator.bottomAnchor.constraint(equalTo: feedBarBackground.bottomAnchor),
            feedSelectionIndicator.widthAnchor.constraint(equalToConstant: 72),
            feedSelectionIndicator.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    private func setupBottomBar() {
        barBackground.translatesAutoresizingMaskIntoConstraints = false
        barBackground.backgroundColor = .systemBackground
        view.addSubview(barBackground)

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .separator
        barBackground.addSubview(separator)

        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        barBackground.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            barBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            barBackground.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -barContentHeight
            ),
            barBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            separator.leadingAnchor.constraint(equalTo: barBackground.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: barBackground.trailingAnchor),
            separator.topAnchor.constraint(equalTo: barBackground.topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),

            buttonStack.leadingAnchor.constraint(equalTo: barBackground.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: barBackground.trailingAnchor),
            buttonStack.topAnchor.constraint(equalTo: barBackground.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func makeTabButton(
        tab: HotwireTab,
        accessibilityLabel: String,
        index: Int
    ) -> UIButton {
        let button = UIButton(type: .custom)
        let normalConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let selectedConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)

        button.tag = index
        button.tintColor = .label
        button.setImage(tab.image?.applyingSymbolConfiguration(normalConfiguration), for: .normal)
        button.setImage(
            (tab.selectedImage ?? tab.image)?.applyingSymbolConfiguration(selectedConfiguration),
            for: .selected
        )
        button.accessibilityLabel = accessibilityLabel
        button.addTarget(self, action: #selector(selectTab(_:)), for: .touchUpInside)

        return button
    }

    @objc private func selectTab(_ sender: UIButton) {
        let index = sender.tag

        if #available(iOS 18.0, *) {
            guard tabs.indices.contains(index) else { return }
            selectedTab = tabs[index]
        } else {
            guard viewControllers?.indices.contains(index) == true else { return }
            selectedIndex = index
        }

        activeNavigator.start()
        updateSelection(selectedIndex: index)
        updateFeedBar(for: currentFeedURL)
    }

    @objc private func selectFeed(_ sender: UIButton) {
        let index = sender.tag

        guard feedItems.indices.contains(index),
              let feedTab,
              let navigator = navigator(for: feedTab) else { return }

        if feedIndex(for: currentFeedURL) == index { return }

        let item = feedItems[index]
        currentFeedURL = item.url
        updateFeedSelection(selectedIndex: index, animated: true)
        navigator.route(item.url, options: VisitOptions(action: .replace))
    }

    private func updateSelection(selectedIndex: Int) {
        for (index, button) in tabButtons.enumerated() {
            button.isSelected = index == selectedIndex

            if button.isSelected {
                button.accessibilityTraits.insert(.selected)
            } else {
                button.accessibilityTraits.remove(.selected)
            }
        }
    }

    private func updateFeedBar(for url: URL?) {
        currentFeedURL = url

        let nextSelectedIndex = feedIndex(for: url)
        let shouldShow = nextSelectedIndex != nil && isFeedTabSelected
        let shouldAnimateSelection = !feedBarBackground.isHidden && shouldShow
        feedBarBackground.isHidden = !shouldShow

        if let feedTab, let navigator = navigator(for: feedTab) {
            navigator.rootViewController.additionalSafeAreaInsets.top = shouldShow ? feedBarHeight : 0
            navigator.rootViewController.setNavigationBarHidden(shouldShow, animated: false)
        }

        if let nextSelectedIndex {
            updateFeedSelection(
                selectedIndex: nextSelectedIndex,
                animated: shouldAnimateSelection
            )
        }
    }

    private var isFeedTabSelected: Bool {
        guard let feedTab, let navigator = navigator(for: feedTab) else { return false }

        return activeNavigator === navigator
    }

    private func feedIndex(for url: URL?) -> Int? {
        guard let url else { return nil }

        return feedItems.firstIndex { item in
            item.url.scheme == url.scheme &&
                item.url.host == url.host &&
                item.url.port == url.port &&
                normalizedPath(of: item.url) == normalizedPath(of: url)
        }
    }

    private func normalizedPath(of url: URL) -> String {
        let path = url.path

        if path.isEmpty {
            return "/"
        } else if path.count > 1 && path.hasSuffix("/") {
            return String(path.dropLast())
        } else {
            return path
        }
    }

    private func updateFeedSelection(selectedIndex: Int, animated: Bool = false) {
        guard feedButtons.indices.contains(selectedIndex) else { return }

        for (index, button) in feedButtons.enumerated() {
            button.isSelected = index == selectedIndex
        }

        guard self.selectedFeedIndex != selectedIndex else { return }

        feedBarBackground.layoutIfNeeded()
        feedSelectionIndicatorCenterXConstraint?.isActive = false

        let centerXConstraint = feedSelectionIndicator.centerXAnchor.constraint(
            equalTo: feedButtons[selectedIndex].centerXAnchor
        )
        centerXConstraint.isActive = true
        feedSelectionIndicatorCenterXConstraint = centerXConstraint
        feedSelectionIndicator.isHidden = false
        self.selectedFeedIndex = selectedIndex

        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]
            ) {
                self.feedBarBackground.layoutIfNeeded()
            }
        } else {
            feedBarBackground.layoutIfNeeded()
        }
    }

    private func reserveSpaceForBottomBar() {
        viewControllers?.forEach { viewController in
            viewController.additionalSafeAreaInsets.bottom = barContentHeight
        }
    }
}

private final class FeedTabButton: UIButton {
    override var isSelected: Bool {
        didSet {
            titleLabel?.font = .systemFont(ofSize: 15, weight: isSelected ? .semibold : .regular)

            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
        }
    }

    init(title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setTitleColor(.secondaryLabel, for: .normal)
        setTitleColor(.label, for: .selected)
        accessibilityLabel = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import HotwireNative
import UIKit

final class BottomTabBarController: HotwireTabBarController {
    private let barContentHeight: CGFloat = 50
    private let barBackground = UIView()
    private let buttonStack = UIStackView()
    private var tabButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBottomBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // iOS 26の浮遊する標準バーは使わず、画面下端につながるバーを表示する。
        tabBar.isHidden = true
        view.bringSubviewToFront(barBackground)
    }

    func configureBottomBar(tabs: [HotwireTab], accessibilityLabels: [String]) {
        tabBar.isHidden = true
        tabButtons.forEach { $0.removeFromSuperview() }

        tabButtons = zip(tabs, accessibilityLabels).enumerated().map { index, pair in
            let (tab, accessibilityLabel) = pair
            return makeTabButton(tab: tab, accessibilityLabel: accessibilityLabel, index: index)
        }
        tabButtons.forEach(buttonStack.addArrangedSubview)

        updateSelection(selectedIndex: selectedIndex)
        reserveSpaceForBottomBar()
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
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)

        button.tag = index
        button.tintColor = .label
        button.setImage(tab.image?.applyingSymbolConfiguration(symbolConfiguration), for: .normal)
        button.setImage(
            (tab.selectedImage ?? tab.image)?.applyingSymbolConfiguration(symbolConfiguration),
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

    private func reserveSpaceForBottomBar() {
        viewControllers?.forEach { viewController in
            viewController.additionalSafeAreaInsets.bottom = barContentHeight
        }
    }
}

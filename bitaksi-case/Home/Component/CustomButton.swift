//
//  CustomButton.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 18.04.2026.
//

import UIKit

final class CustomButton: UIButton {

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    convenience init(systemName: String) {
        self.init(frame: .zero)
        configuration?.image = UIImage(systemName: systemName)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
}

// MARK: - Private
private extension CustomButton {

    func commonInit() {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        config.cornerStyle = .fixed
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration = config
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 44),
            heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

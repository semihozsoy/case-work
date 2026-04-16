//
//  AlertShowable.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import UIKit

protocol AlertShowable: UIViewController {
    func showActionSheet(
        title: String,
        options: [String],
        selected: String?,
        allOptionTitle: String,
        cancelTitle: String,
        onSelect: @escaping (String?) -> Void
    )
}

extension AlertShowable {
    func showActionSheet(
        title: String,
        options: [String],
        selected: String?,
        allOptionTitle: String = "Tümü",
        cancelTitle: String = "İptal",
        onSelect: @escaping (String?) -> Void
    ) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

        let allTitle = selected == nil ? "✓ \(allOptionTitle)" : allOptionTitle
        alert.addAction(UIAlertAction(title: allTitle, style: .default) { _ in onSelect(nil) })

        for option in options {
            let optionTitle = option == selected ? "✓ \(option)" : option
            alert.addAction(UIAlertAction(title: optionTitle, style: .default) { _ in onSelect(option) })
        }

        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        present(alert, animated: true)
    }
}

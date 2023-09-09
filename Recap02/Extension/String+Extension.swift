//
//  String+Extension.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation

extension String {
    var attributedHtmlString: NSAttributedString? {
        try? NSAttributedString(
            data: Data(utf8),
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
}

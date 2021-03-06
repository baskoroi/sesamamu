//
//  KeyboardResponder.swift
//  swiftUIPractice
//
//  Created by Baskoro Indrayana on 07/21/20.
//  Copyright © 2020 Baskoro Indrayana. All rights reserved.
//

import SwiftUI

final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0
    
    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter
            .addObserver(self,
                         selector: #selector(keyboardWillShow(notification:)),
                         name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter
            .addObserver(self,
                         selector: #selector(keyboardWillHide(notification:)),
                         name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        currentHeight = 0
    }
    
}

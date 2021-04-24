//
//  startPauseDownloadButton.swift
//  catFetcher
//
//  Created by tixomark on 3/11/21.
//

import Foundation
import UIKit

final class StartPauseDownloadButton: UIButton {
    
    private var colors: [UIColor?] = Array.init(repeating: UIColor(), count: 2)
    private var images: [UIImage?] = Array.init(repeating: UIImage(), count: 2)
    
    enum buttonState: Int {
        case mainState
        case additionalState
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func set(image: UIImage? = UIImage(), color: UIColor? = UIColor.clear, for state: buttonState) {
        self.colors[state.rawValue] = color
        self.images[state.rawValue] = image
    }
    
    func switchState(to state: buttonState, _ switched: ((_ toState: buttonState) -> Void) = {_ in }) {
        self.backgroundColor = self.colors[state.rawValue]
        self.setImage(self.images[state.rawValue], for: .normal)

        switched(state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


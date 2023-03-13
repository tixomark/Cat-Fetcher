//
//  startPauseDownloadButton.swift
//  catFetcher
//
//  Created by tixomark on 3/11/21.
//

import UIKit

final class StartPauseButton: UIButton {
    
    private var colors: [UIColor] = Array.init(repeating: UIColor(), count: 2)
    private var images: [UIImage] = Array.init(repeating: UIImage(), count: 2)
    
    weak var delegate: StartPauseButtonDelegate!
    private(set) var startPauseButtonState: ButtonState!
    
    enum ButtonState: Int {
        case mainState
        case additionalState
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        set(image: UIImage(named: "play")!,
                   color: UIColor(red: 115/255, green: 246/255, blue: 158/255, alpha: 0.5),
                   for: .mainState)
        set(image: UIImage(named: "pause")!,
                   color: UIColor(red: 235/255, green: 69/255, blue: 90/255, alpha: 0.5),
                   for: .additionalState)
        
        switchState(to: .mainState)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    deinit {
        self.removeTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        switch startPauseButtonState {
        case .additionalState:
            switchState(to: .mainState)
        case .mainState:
            switchState(to: .additionalState)
        case .none:
            return
        }
        
        delegate.buttonWasTapped(self)
    }
    
    private func set(image: UIImage = UIImage(), color: UIColor = UIColor.clear, for state: ButtonState) {
        self.colors[state.rawValue] = color
        self.images[state.rawValue] = image
    }
    
    private func switchState(to state: ButtonState) {
        backgroundColor = colors[state.rawValue]
        setImage(images[state.rawValue], for: .normal)
        startPauseButtonState = state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


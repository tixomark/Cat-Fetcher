//
//  SettingsViewController.swift
//  catFetcher
//
//  Created by tixomark on 3/11/21.
//

import UIKit

final class SettingsViewController: UIViewController {

    let numberOfFetchedCatsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 30)
        label.textAlignment = .center
        return label
    }()
    let stopLoadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        return label
    }()
    let stopLoadingSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 1000
        slider.tintColor = .systemPink
        return slider
    }()
    let infiniCatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        label.text = "Inficat"
        return label
    }()
    let infiniCatSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .systemPink
        return sw
    }()
    let infiniCatDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        label.text = "Enables infifnite cat fetching"
        return label
    }()
    let deleteAllCatsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
        button.backgroundColor = .systemPink
        button.setTitle("Delete all cats", for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
//        button.isUserInteractionEnabled = true
        return button
    }()
    
    let settings = Settings.appSettings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLayout()
        setUPUI()
        
        Settings.appSettings.attach(self)
        
        stopLoadingSlider.addTarget(self, action: #selector(stopLoadingSliderObserver(sender:)), for: .valueChanged)
        stopLoadingSlider.addTarget(self, action: #selector(stopLoadingSliderEndInteraction(sender:)), for: .touchUpOutside)
        stopLoadingSlider.addTarget(self, action: #selector(stopLoadingSliderEndInteraction(sender:)), for: .touchUpInside)
        infiniCatSwitch.addTarget(self, action: #selector(infiniCatSwitchChangedState(sender:)), for: .valueChanged)
        deleteAllCatsButton.addTarget(self, action: #selector(deleteAllCatsButtonPressed), for: .touchUpInside)
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Settings.appSettings.detach(self)
        super.viewDidDisappear(animated)
    }
    
    //MARK: #selector methods
    @objc func infiniCatSwitchChangedState(sender: UISwitch) {
        guard sender == infiniCatSwitch else { return }
        infiniCatDescriptionLabel.text = sender.isOn ? "Cats will load continually" : "Enable infifnite cat fetching"
        settings.infiniCatIsOn = infiniCatSwitch.isOn
    }
    
    @objc func stopLoadingSliderObserver(sender: UISlider) {
        guard sender == stopLoadingSlider else { return }
        let value = Int(sender.value)
        stopLoadingLabel.text = "Stop loading after \(value) \(value == 1 ? "cat" : "cats")"
    }
    
    @objc func stopLoadingSliderEndInteraction(sender: UISlider) {
        guard sender == stopLoadingSlider else { return }
        settings.stopLoadingSliderValue = stopLoadingSlider.value
    }
    
    @objc func deleteAllCatsButtonPressed() {
        print("deletepressed")
        NotificationCenter.default.post(Notification(name: .deleteAllCatsButtonTriggered))
    }
    
    //MARK: Setting view appearance
    func setUPUI() {
        numberOfFetchedCatsLabel.text = "\(settings.totalNumberOfFetchedCats) \(settings.totalNumberOfFetchedCats == 1 ? "cat" : "cats") total"
        stopLoadingSlider.setValue(settings.stopLoadingSliderValue, animated: true)
        infiniCatSwitch.isOn = settings.infiniCatIsOn
        
        let sliderValue = Int(stopLoadingSlider.value)
        stopLoadingLabel.text = "Stop loading after \(sliderValue) \(sliderValue == 1 ? "cat" : "cats")"
        
    }
    
    func setUpLayout() {
        let margins = self.view.layoutMarginsGuide
        
        // Set up numberOfFetchedCatsLabel
        numberOfFetchedCatsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numberOfFetchedCatsLabel)
        numberOfFetchedCatsLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20).isActive = true
        numberOfFetchedCatsLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        numberOfFetchedCatsLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        // Set up stopLoadingLabel
        stopLoadingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopLoadingLabel)
        stopLoadingLabel.topAnchor.constraint(equalTo: numberOfFetchedCatsLabel.bottomAnchor, constant: 10).isActive = true
        stopLoadingLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stopLoadingLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        // Set up stopLoadingSlider
        stopLoadingSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopLoadingSlider)
        stopLoadingSlider.topAnchor.constraint(equalTo: stopLoadingLabel.bottomAnchor, constant: 5).isActive = true
        stopLoadingSlider.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        stopLoadingSlider.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        // Set up infictLabel
        infiniCatLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infiniCatLabel)
        infiniCatLabel.topAnchor.constraint(equalTo: stopLoadingSlider.bottomAnchor, constant: 20).isActive = true
        infiniCatLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        
        // Set up inficatSwitch
        infiniCatSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infiniCatSwitch)
        infiniCatSwitch.centerYAnchor.constraint(equalTo: infiniCatLabel.centerYAnchor).isActive = true
        infiniCatSwitch.leadingAnchor.constraint(equalTo: infiniCatLabel.trailingAnchor).isActive = true
        infiniCatSwitch.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        // Set up inifnicatDescriptionLabel
        infiniCatDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infiniCatDescriptionLabel)
        infiniCatDescriptionLabel.topAnchor.constraint(equalTo: infiniCatSwitch.bottomAnchor).isActive = true
        infiniCatDescriptionLabel.leadingAnchor.constraint(equalTo: infiniCatLabel.leadingAnchor).isActive = true
        infiniCatDescriptionLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        
        // Set up deleteAllCatsButton
        deleteAllCatsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteAllCatsButton)
        deleteAllCatsButton.topAnchor.constraint(greaterThanOrEqualTo: infiniCatDescriptionLabel.bottomAnchor, constant: 20).isActive = true
        deleteAllCatsButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        deleteAllCatsButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        deleteAllCatsButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -15).isActive = true
    }
}

extension SettingsViewController: SettingsObserver {
    var classDescription: String {
        return("SettingsViewController")
    }
    
    func totalNumberOfFetchedCatsUpdated(withValue: Int) {
        DispatchQueue.main.async {
            self.numberOfFetchedCatsLabel.text = "\(withValue) \(withValue == 1 ? "cat" : "cats") total"
        }
    }
    
}

extension Notification.Name {
    static let deleteAllCatsButtonTriggered = Notification.Name(rawValue: "deleteAllCatsNotification")
}

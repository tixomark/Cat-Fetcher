//
//  ViewController.swift
//  catFetcher
//
//  Created by tixomark on 3/4/21.
//

import UIKit
import CoreData

class CatBrowserViewController: UIViewController {
    
    // MARK: Variables    
    var table = UITableView()
    var startPauseButton: StartPauseButton = StartPauseButton()
    
    let mainModel: MainModel = MainModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Settings.appSettings.attach(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startPauseButton.delegate = self
        
        mainModel.downloadDelegate = self
        mainModel.coreDataDelegate = self
        
        // set up UI
        setUPUI()
        
        title = setCatTitleDetail(with: Settings.appSettings.stopLoadingSliderValue)
        
        // managing tableView and it's delegate/datasource
        table.dataSource = self
        table.delegate = self
        // register custom sell for tableView
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellID)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Settings.appSettings.detach(self)
        super.viewDidDisappear(animated)
    }
    
    // MARK: Setting UI
    func setUPUI() {
        // Setting up table
        view.backgroundColor = .systemPurple
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        table.frame = view.frame
        table.separatorStyle = .none
        //        table.allowsMultipleSelection = true
        
        // Setting up startPauseDownlodButton
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startPauseButton)
        startPauseButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        startPauseButton.widthAnchor.constraint(equalTo: startPauseButton.heightAnchor).isActive = true
        startPauseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        startPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        let width = self.view.bounds.width * 0.2 * 0.5
        startPauseButton.layer.cornerRadius = width
    }
    
    func setCatTitleDetail(with value: Float) -> String {
        return "\(Int(value)) \(Int(value) == 1 ? "cat" : "cats") to add"
    }
}

extension CatBrowserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainModel.catImages == nil ? 0 : mainModel.catImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TableViewCell.cellID, for: indexPath) as! TableViewCell
        
        if let data = mainModel.catImages[indexPath.row].image, let image = UIImage(data: data) {
            cell.mainImage.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NeViewController()
        if let data = mainModel.catImages[indexPath.row].image, let image = UIImage(data: data) {
            vc.imageView.image = image
        }
        vc.title = "\(indexPath.row + 1)"
        
        navigationController?.pushViewController(vc, animated: true) ?? present(vc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        Settings.appSettings.detach(self)
        self.title = "All Cats"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width / 1.5
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            table.beginUpdates()
            table.deleteRows(at: [indexPath], with: .automatic)
            let deletedImageModel = mainModel.catImages.remove(at: indexPath.row)
            mainModel.coreDataManager.delete([deletedImageModel])
            table.endUpdates()
            
        default:
            return
        }
    }
    
}

extension CatBrowserViewController: MainModelDownloadDelegate {
    func completedDownloadOfItem(numberOfItemsToFetch: Int, numberOfFetchedItems: Int) {
        
    }
    
    func downloadResumed(numberOfFetchedItems: Int) {
        
    }
    
    func downloadPaused() {
        
    }
    
    func downloadFinished(numberOfFetchedItems: Int) {
        self.table.reloadData()
    }
    
    
}

extension CatBrowserViewController: MainModelCoreDataDelegate {
    func newlyAddedImageMogels(count: Int) {
//        table.insertRows(at: <#T##[IndexPath]#>, with: .automatic)
        
        DispatchQueue.main.async {
            
            self.table.reloadData()
        }
    }
    
    func deletedImageModels(count: Int) {
        
    }
}

extension CatBrowserViewController: StartPauseButtonDelegate {
    func buttonWasTapped(_ sender: StartPauseButton) {
        switch sender.startPauseButtonState {
        case .mainState:
            mainModel.pauseDownload()
        case .additionalState:
            mainModel.resumeDownload()
        default:
            return
        }
    }
}

// MARK: Handling SettingsObserver notifications
extension CatBrowserViewController: SettingsObserver {
    
    var classDescription: String {
        return "CatBrowserController"
    }
    
    func stopLoadingSliderValueUpdated(withValue: Float) {
        print(Thread.current, "stoploadingUpdated")
        if mainModel.timer != nil {
            self.title = "Loading: \(self.mainModel.amountOfFetchedCatsInCurrentSession) / \(Int(Settings.appSettings.stopLoadingSliderValue))"
        } else {
            self.title = setCatTitleDetail(with: withValue)
        }
        print("to load \(withValue) cats")
    }
    
    func totalNumberOfFetchedCatsUpdated(withValue: Int) {
        DispatchQueue.main.async {
            self.title = "Loading: \(self.mainModel.amountOfFetchedCatsInCurrentSession) / \(Int(Settings.appSettings.stopLoadingSliderValue))"
        }
    }
}

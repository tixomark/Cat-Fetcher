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
    var catImages: [ImageModel]!
    
    var table = UITableView()
    var startPauseDownlaodButton: StartPauseDownloadButton = {
        let button = StartPauseDownloadButton()
        button.set(image: UIImage(named: "play")!,
                   color: UIColor(red: 115/255, green: 246/255, blue: 158/255, alpha: 0.5),
                   for: .mainState)
        button.set(image: UIImage(named: "pause")!,
                   color: UIColor(red: 235/255, green: 69/255, blue: 90/255, alpha: 0.5),
                   for: .additionalState)
        return button
    }()
    var numberOfLoadedCatsInCurrentSession: Int = 0
    
    let coreDataManager = CoreDataImageModelManager()
    let imageFetcher = ImageFetcher()
    //    var timer: Timer?
    let startPauseModel = StartPauseDownloadModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Settings.appSettings.attach(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // fetch all saved images from coreData
        coreDataManager.fetch(returnToQueue: .main) { images in
            self.catImages = images
            self.table.reloadData()
        }
        // set up UI
        setUPUI()
        
        // managing tableView and it's delegate/datasource
        table.dataSource = self
        table.delegate = self
        // register custom sell for tableView
        table.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.cellID)
        
        // connecting imageFetcher delegate to manage downloads and downloaded dataFiles
        imageFetcher.delegate = self
        
        // add action to button for start/stop downloading images
        startPauseDownlaodButton.addTarget(self, action: #selector(startPauseButtonAction), for: .touchUpInside)
        startPauseModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAllCats), name: .deleteAllCatsButtonTriggered , object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Settings.appSettings.detach(self)
        super.viewDidDisappear(animated)
    }
    
    // MARK: #selector methods
    
    @objc func deleteAllCats() {
        coreDataManager.delete(catImages)
        catImages = []
        self.table.reloadData()
    }
    
    @objc func startPauseButtonAction() {
        guard startPauseModel.timer != nil else {
            startPauseDownlaodButton.switchState(to: .additionalState)
            startPauseModel.startDownload()
            return
        }
        startPauseDownlaodButton.switchState(to: .mainState)
        startPauseModel.pauseDawnload()
    }
    
    // MARK: Setting UI
    func setUPUI() {
        
        title = setCatTitleDetail(with: Settings.appSettings.stopLoadingSliderValue)
        
        // Setting up table
        view.backgroundColor = .systemPurple
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)
        table.frame = view.frame
        table.separatorStyle = .none
        //        table.allowsMultipleSelection = true
        
        // Setting up startPauseDownlodButton
        startPauseDownlaodButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startPauseDownlaodButton)
        startPauseDownlaodButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        startPauseDownlaodButton.widthAnchor.constraint(equalTo: startPauseDownlaodButton.heightAnchor).isActive = true
        startPauseDownlaodButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        startPauseDownlaodButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        let width = self.view.bounds.width * 0.2 * 0.5
        startPauseDownlaodButton.layer.cornerRadius = width
        startPauseDownlaodButton.switchState(to: .mainState)
    }
    
    func setCatTitleDetail(with value: Float) -> String {
        return "\(Int(value)) \(Int(value) == 1 ? "cat" : "cats") to add"
    }
}


extension CatBrowserViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catImages == nil ? 0 : catImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TableViewCell.cellID, for: indexPath) as! TableViewCell
        
        if let data = catImages[indexPath.row].image, let image = UIImage(data: data) {
            cell.mainImage.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NeViewController()
        if let data = catImages[indexPath.row].image, let image = UIImage(data: data) {
            vc.image.image = image
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
            let deletedImageModel = catImages.remove(at: indexPath.row)
            coreDataManager.delete([deletedImageModel])
            table.endUpdates()
            
        default:
            return
        }
    }
    
}

extension CatBrowserViewController: StartPauseDownloadDelegate {
    var condition: Bool {
        return numberOfLoadedCatsInCurrentSession < Int(Settings.appSettings.stopLoadingSliderValue)
    }
    
    func timerActionIfFalse() {
        numberOfLoadedCatsInCurrentSession = 0
        
        startPauseDownlaodButton.switchState(to: .mainState)
        self.title = setCatTitleDetail(with: Settings.appSettings.stopLoadingSliderValue)
        self.table.reloadData()
    }
    
    func timerActionIfTrue() {
        imageFetcher.startDownload(url: URL(string: "https://thiscatdoesnotexist.com")!) //https://www.thiswaifudoesnotexist.net/example-45746.jpg
        numberOfLoadedCatsInCurrentSession = numberOfLoadedCatsInCurrentSession + 1
    }
}

// MARK: ImageFetchDelegate protocol methods realisation
extension CatBrowserViewController: ImageFetcherDelegate {
    
    func finishedDownload(of downloadTask: URLSessionDownloadTask, in session: URLSession, to url: URL) {
        if let data = try? Data(contentsOf: url) {
            
            self.coreDataManager.saveImages([data], returnToQueue: .global()) {
                self.catImages.append(contentsOf: $0)
            }
            
            Settings.appSettings.incrementTotalNumberOfFetchedCats()
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
        if startPauseModel.timer != nil {
            self.title = "Loading: \(self.numberOfLoadedCatsInCurrentSession) / \(Int(Settings.appSettings.stopLoadingSliderValue))"
        } else {
            self.title = setCatTitleDetail(with: withValue)
        }
        print("to load \(withValue) cats")
    }
    
    func totalNumberOfFetchedCatsUpdated(withValue: Int) {
        DispatchQueue.main.async {
            self.title = "Loading: \(self.numberOfLoadedCatsInCurrentSession) / \(Int(Settings.appSettings.stopLoadingSliderValue))"
        }
    }
}





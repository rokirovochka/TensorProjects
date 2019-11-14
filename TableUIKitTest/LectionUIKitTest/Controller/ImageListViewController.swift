//
//  ImageListViewController.swift
//  LectionUIKitTest
//
//  Created by Никита Максаковский on 12.11.2019.
//  Copyright © 2019 Konstantin Polin. All rights reserved.
//

import Foundation
import UIKit

private struct CellData {
    let text: String
    //let image: UIImage
    let imageSubscription: ImageSubscription
}
private struct SectionData {
    let headerText: String
    let footerText: String
    let cells: [CellData]
}

typealias ImageSetter = ((UIImage, Int) -> Void)

class ImageSubscription {
    private var imageSetter: ImageSetter? = nil
    
    func subscribe (_ closure: @escaping ImageSetter) {
        imageSetter = closure
    }
    
    func set(_ image: UIImage, status: Int) {
        imageSetter?(image, status)
    }
}

class ImageListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var sections = [SectionData]()
    
    private var urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        let semenSubscription = ImageSubscription()
        let stepanSubscription = ImageSubscription()

        let kittySubscription = ImageSubscription()
        let kittyCellData = [
            CellData(text: "kitty", imageSubscription: kittySubscription)
        ]
        let facesCellData = [
        CellData(text: "Semen", imageSubscription: semenSubscription),
        CellData(text: "Stepan", imageSubscription: stepanSubscription)
        ]
        
        sections.append(SectionData(headerText: "Kitties", footerText: "", cells: kittyCellData))
        sections.append(SectionData(headerText: "Faces", footerText: "", cells: facesCellData))
        
        let kittyUrl = URL(string: "https://sun9-55.userapi.com/c852232/v852232181/bc055/GumFgzYECK0.jpg")!
        
        let task = urlSession.dataTask(with: kittyUrl) { (data, response, error) in
            guard let imageData = data, let image = UIImage(data: imageData) else {
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            kittySubscription.set(image, status: httpResponse.statusCode)
        }
        task.resume()
        
        let semenUrl = URL(string: "https://sun9-57.userapi.com/c855636/v855636554/16a4b1/raV-crBZiJs.jpg")!
        
        let taskSemen = urlSession.dataTask(with: semenUrl) { (data, response, error) in
            guard let imageData = data, let image = UIImage(data: imageData) else {
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            semenSubscription.set(image, status: httpResponse.statusCode)
        }
        taskSemen.resume()
        
        let stepanUrl = URL(string: "https://sun9-40.userapi.com/c857524/v857524554/e4645/tbTvvgFoz_o.jpg")!
        
        let taskStepan = urlSession.dataTask(with: stepanUrl) { (data, response, error) in
            guard let imageData = data, let image = UIImage(data: imageData) else {
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            stepanSubscription.set(image, status: httpResponse.statusCode)
        }
        taskStepan.resume()
        
    }
}

extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerText
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: .zero)
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TableCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let data = sections[indexPath.section].cells[indexPath.row]
        if let tableCell = cell as? TableCell {
            tableCell.configure(data: data)
        }
    }
}

private class TableCell: UITableViewCell {
    private let imageNameLabel: UILabel = UILabel(frame: .zero)
    private let preview: UIImageView = UIImageView(image: nil)
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        imageNameLabel.translatesAutoresizingMaskIntoConstraints = false
        preview.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageNameLabel)
        contentView.addSubview(preview)
        configureConstraints()
    }
    
    func configure(data: CellData) {
        imageNameLabel.text = data.text
        
        data.imageSubscription.subscribe {[weak self] (image, status)  in
            self?.preview.image = image
        }
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            preview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            preview.heightAnchor.constraint(equalToConstant: 70),
            preview.widthAnchor.constraint(equalToConstant: 70),
            preview.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            imageNameLabel.leftAnchor.constraint(equalTo: preview.rightAnchor, constant: 10),
            imageNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 80.0),
        ])
        preview.layer.cornerRadius = 35
        preview.clipsToBounds = true
    }
}

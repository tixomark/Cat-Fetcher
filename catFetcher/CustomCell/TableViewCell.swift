//
//  TableViewCell.swift
//  catFetcher
//
//  Created by tixomark on 3/4/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var mainImage = UIImageView()
    
    static let cellID = "cellID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpCellUI()
        self.selectionStyle = .none
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapAction))
        self.addGestureRecognizer(longTapGesture)
    }
    
    @objc func longTapAction() {
//        self.isSelected = true
        
    }
    
    private func setUpCellUI() {
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainImage)
        
        mainImage.layer.cornerRadius = 30.0
        mainImage.layer.borderWidth = 3
        mainImage.layer.borderColor = CGColor(red: 235/255, green: 69/255, blue: 90/255, alpha: 1)
        mainImage.clipsToBounds = true
        
        mainImage.heightAnchor.constraint(equalTo: mainImage.widthAnchor).isActive = true
        mainImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        mainImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mainImage.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 10).isActive = true
        mainImage.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mainImage.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.mainImage.layer.borderColor = isSelected ? CGColor(red: 104/255, green: 205/255, blue: 103/255, alpha: 1) : CGColor(red: 235/255, green: 69/255, blue: 90/255, alpha: 1)
        self.mainImage.layer.cornerRadius = isSelected ? 40.0 : 30

        // Configure the view for the selected state
    }

}

//
//  ImageModel+CoreDataProperties.swift
//  catFetcher
//
//  Created by tixomark on 3/31/21.
//
//

import Foundation
import CoreData


extension ImageModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageModel> {
        return NSFetchRequest<ImageModel>(entityName: "ImageModel")
    }

    @NSManaged public var image: Data?
    @NSManaged public var timeStamp: Double

}

extension ImageModel : Identifiable {

}

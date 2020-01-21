//
//  WebSiteDescription.swift
//  Networking
//
//  Created by Александр on 15.01.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import Foundation

struct WebSiteDiscription: Decodable {
    let courses: [Course]
    let websiteName: String?
    let websiteDescription: String?
}

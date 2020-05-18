//
//  ViewModelDelegate.swift
//  task9
//
//  Created by Oksana Kotilevska on 2/3/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import Foundation

protocol ViewModelDelegate: class {
    var isFiltering: Bool { get }
    func viewModelDidUpdateFiltering(_ viewModel: ViewModel)
}

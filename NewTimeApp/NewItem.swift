//
//  NewItem.swift
//  NewTimeApp
//
//  Created by Gilbert Solano on 7/23/21.
//

import Foundation
import SwiftUI
import Combine

struct Task : Identifiable {
    var id = String()
    var toDoItem = String()
    //var duration = Int()
}

class TaskStore : ObservableObject {
    @Published var tasks = [Task]()
}

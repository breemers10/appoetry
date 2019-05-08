//
//  DeleteAccViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class DeleteAccViewModel {
    
    var onSuccessfulDeletion: (() -> Void)?
    var onCancelTap: (() -> Void)?
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func deleteUser() {
        databaseService?.deleteAccount()
    }
}

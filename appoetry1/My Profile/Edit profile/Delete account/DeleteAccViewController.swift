//
//  DeleteAccViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class DeleteAccViewController: UIViewController {
    var viewModel: DeleteAccViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    @IBAction private func deleteButtonPressed(_ sender: Any) {
        viewModel?.deleteUser()
        viewModel?.onSuccessfulDeletion?()
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        viewModel?.onCancelTap?()
    }
}

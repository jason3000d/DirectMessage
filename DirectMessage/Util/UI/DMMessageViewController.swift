//
//  DMMessageViewController.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/14.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMMessageViewController: UITableViewController {

    var peerUser: DMUser
    var messages = [DMMessageText]()
    var inputBoxView: DMInputBoxView?
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        guard self.navigationController?.topViewController == self,
            self.inputBoxView == nil else {
            return self.inputBoxView
        }
        let view = DMInputBoxView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: DMInputBoxView.Constants.height))
        view.delegate = self
        self.inputBoxView = view
        return view
    }
    
    init(with user: DMUser) {
        self.peerUser = user
        super.init(nibName: nil, bundle: nil)
        self.title = user.handleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 300
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        self.reloadInputViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.inputBoxView = nil
        self.resignFirstResponder()
        self.reloadInputViews()
    }
    
    func setupTableView() {
        let peerNib = UINib(nibName: DMPeerChannelMessageTableViewCell.Constants.cellIdentifier, bundle: nil)
        tableView.register(peerNib, forCellReuseIdentifier: DMPeerChannelMessageTableViewCell.Constants.cellIdentifier)
        let myNib = UINib(nibName: DMMyChannelMessageTableViewCell.Constants.cellIdentifier, bundle: nil)
        tableView.register(myNib, forCellReuseIdentifier: DMMyChannelMessageTableViewCell.Constants.cellIdentifier)
    }

    func sendMockMessage(with text: String) {
        let message = DMMessageText(with: text)
        let mockPeerMessage = DMMessageText(with: text + text, senderId: self.peerUser.username)

        let updateHandler: (_ message: DMMessageText) -> Void = { [weak self] (message) in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(message)
            let indexPath = IndexPath(row: strongSelf.messages.count - 1, section: 0)
            strongSelf.tableView.beginUpdates()
            strongSelf.tableView.insertRows(at: [indexPath], with: .bottom)
            strongSelf.tableView.endUpdates()
            strongSelf.tableView.scrollToRow(at: IndexPath(row: strongSelf.messages.count - 1, section: 0), at: .bottom, animated: true)
        }

        updateHandler(message)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            updateHandler(mockPeerMessage)
        }
    }
    
}

extension DMMessageViewController {
    
    func cellIdentifier(for message: DMMessageText) -> String {
        if message.isMine {
            return DMMyChannelMessageTableViewCell.Constants.cellIdentifier
        } else {
            return DMPeerChannelMessageTableViewCell.Constants.cellIdentifier
        }
    }
}

// MARK: - Table view data source
extension DMMessageViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        let rawCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier(for: message), for: indexPath)
        guard let cell = rawCell as? DMMessageViewProtocol else {
            return rawCell
        }
        cell.populate(with: message)
        return rawCell
    }

}

// MARK: - Table view delegate
extension DMMessageViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false
        )
    }
}

extension DMMessageViewController: DMInputViewDelegate {
    
    func inputBoxView(_: DMInputBoxView, didTapSendButtonWith text: String) {
        // NOTE: Currently only send local message and mocking the response from the peer user after 1s.
        self.sendMockMessage(with: text)
    }

}

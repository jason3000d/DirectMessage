//
//  DMInputView.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

protocol DMInputViewDelegate: class {
    func inputBoxView(_: DMInputBoxView, didTapSendButtonWith text: String)
}

class DMInputBoxView: UIView {
    
    enum Constants {
        static let height: CGFloat = 64
    }

    @IBOutlet weak var inputBoxView: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate: DMInputViewDelegate?
    
    override var canBecomeFirstResponder: Bool {
        true
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
        
    func setupView() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: self.classForCoder), owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        guard let text = self.inputBoxView.text,
            !text.isEmpty else { return }
        self.delegate?.inputBoxView(self, didTapSendButtonWith: text)
        self.inputBoxView.text = nil
    }

}

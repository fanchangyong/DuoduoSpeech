//
//  HomeViewController.swift
//  DuoduoSpeech
//
//  Created by fancy on 4/13/21.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "多多智能朗读"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textView: UITextView = {
        let text = UITextView()
        text.isEditable = true
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.cornerRadius = 5
        text.heightAnchor.constraint(equalToConstant: 120).isActive = true
        return text
    }()

    private lazy var textViewLabel: UILabel = {
        let label = UILabel()
        label.text = "请输入内容："
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var btnSpeech: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(onTouch), for: .touchUpInside)
        btn.setTitle("朗读", for: .normal)
        btn.backgroundColor = .green
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(stackView)
        self.configureStackView()
    }
    
    func configureStackView() {
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        addHorizontalConstraint(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textViewLabel)
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(btnSpeech)

        stackView.setCustomSpacing(30, after: titleLabel)
    }
    
    func addHorizontalConstraint(_ view: UIView) {
        view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }

    @objc func onTouch() {
        if let text = textView.text {
            print("onTouch, text: \(text)")
            let utterance = AVSpeechUtterance(string: text)
            AVSpeechSynthesizer().speak(utterance)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

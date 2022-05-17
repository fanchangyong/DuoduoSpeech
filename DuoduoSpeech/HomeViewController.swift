//
//  HomeViewController.swift
//  DuoduoSpeech
//
//  Created by fancy on 4/13/21.
//

import UIKit
import AVFoundation

let placeholder = "请输入或粘贴内容"

class HomeViewController: UIViewController {
    let synthezier = AVSpeechSynthesizer()
    var playing = false

    private lazy var topBar: UIView = {
        let topBar = UIView()
        self.view.addSubview(topBar)
        topBar.backgroundColor = .systemBlue
        topBar.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            topBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topBar.topAnchor.constraint(equalTo: self.view.topAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 100),
        ]
        
        for (index, item) in constraints.enumerated() {
            item.identifier = "top-bar-constraint-\(index)"
        }
        
        NSLayoutConstraint.activate(constraints)
        return topBar
    }()
    
    private lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        self.view.addSubview(topLabel)
        topLabel.text = "多多英语朗读"
        topLabel.font = .preferredFont(forTextStyle: .headline)
        topLabel.textColor = .white
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: topBar.centerXAnchor),
            topLabel.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -20)
        ])
        return topLabel
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textView: UITextView = {
        let text = UITextView()
        self.view.addSubview(text)
        text.isEditable = true
        text.textContainerInset = UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        text.font = UIFont.systemFont(ofSize: 16)
        text.layer.cornerRadius = 5
        text.backgroundColor = .white
        text.text = placeholder
        text.textColor = .lightGray
        text.delegate = self
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(tapClear))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDone))
        
        text.addToolbar(flexible, clearButton, doneButton)

        let constraints = [
            text.topAnchor.constraint(equalTo: topBar.bottomAnchor, constant: 50),
            text.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            text.bottomAnchor.constraint(equalTo: self.btnSpeech.topAnchor, constant: -50),
        ]
        
        for (index, item) in constraints.enumerated() {
            item.identifier = "text-view-constraint-\(index)"
        }
        
        text.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(constraints)
        return text
    }()

    private lazy var btnSpeech: UIButton = {
        let btn = UIButton()
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(onTouch), for: .touchUpInside)
        btn.setTitle("朗读", for: .normal)
        
        let icon = UIImage(systemName: "play.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        btn.setImage(icon, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.semanticContentAttribute = .forceRightToLeft
        
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            btn.heightAnchor.constraint(equalToConstant: 60),
        ])
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        self.synthezier.delegate = self
        self.view.addSubview(self.topBar)
        self.view.addSubview(self.topLabel)
        self.view.addSubview(self.textView)
        self.view.addSubview(self.btnSpeech)
        
        // Do any additional setup after loading the view.
    }
    
    func toggleButton() {
        playing = !playing
        if (playing) {
            self.btnSpeech.setTitle("暂停", for: .normal)
            let icon = UIImage(systemName: "pause.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            self.btnSpeech.setImage(icon, for: .normal)
        } else {
            self.btnSpeech.setTitle("朗读", for: .normal)
            let icon = UIImage(systemName: "play.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            self.btnSpeech.setImage(icon, for: .normal)
        }
    }

    @objc func onTouch() {
        if let text = textView.text, text != placeholder, !playing {
            let utterance = AVSpeechUtterance(string: text)
            if (self.synthezier.isPaused) {
                self.synthezier.continueSpeaking()
            } else {
                synthezier.speak(utterance)
            }
            toggleButton()
        } else if playing {
            synthezier.pauseSpeaking(at: .immediate)
            toggleButton()
        }
    }
    
    @objc func tapDone() {
        self.textView.endEditing(true)
    }
    
    @objc func tapClear() {
        self.textView.text = ""
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

extension HomeViewController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (playing) {
            self.toggleButton()
        }
    }
}

extension HomeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension UITextView {
    func addToolbar(_ barItems: UIBarButtonItem...) {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
        toolBar.setItems(barItems, animated: false)
        self.inputAccessoryView = toolBar
    }
}

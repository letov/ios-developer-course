//
//  RadioViewController.swift
//  Course2Week4Task1
//
//  Copyright © 2018 e-Legion. All rights reserved.
//

import UIKit

class RadioViewController: UIViewController {
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
   
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
        label.tintColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var labelSubview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setValue(0.5, animated: true)
        return slider
    }()
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.setProgress(0.5, animated: true)
        return progress
    }()
    
    private var defaultConstraints: [NSLayoutConstraint] = []
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var albumConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        self.addSubviews()
        self.loadAlbum()
        self.setupConstraints()
        self.traitCollectionDidChange(traitCollection)
        NSLayoutConstraint.activate(self.defaultConstraints)
    }
    
    func setupConstraints() {
        self.defaultConstraints.append(contentsOf: [
            // slider
            self.slider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.slider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            self.slider.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -24.0),
        ])
        
        self.portraitConstraints.append(contentsOf: [
            // image
            self.image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.image.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            self.image.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8.0 + UIApplication.shared.statusBarFrame.size.height),
            self.image.heightAnchor.constraint(equalTo: self.image.widthAnchor),
            // progress
            self.progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.progress.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            self.progress.topAnchor.constraint(equalTo: self.image.bottomAnchor, constant: 30.0),
            //label
            self.labelSubview.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.labelSubview.topAnchor.constraint(equalTo: self.progress.bottomAnchor),
            self.labelSubview.bottomAnchor.constraint(equalTo: self.slider.topAnchor),
            self.labelSubview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            self.labelSubview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0),
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.labelSubview.centerYAnchor),
        ])

        self.albumConstraints.append(contentsOf: [
            // progress
            self.progress.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.progress.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            self.progress.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16.0),
            // image
            self.image.bottomAnchor.constraint(equalTo: self.slider.topAnchor, constant: -16.0),
            self.image.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
            self.image.topAnchor.constraint(equalTo: self.progress.topAnchor, constant: 16),
            self.image.heightAnchor.constraint(equalTo: self.image.widthAnchor),
            //label
            self.labelSubview.topAnchor.constraint(equalTo: self.image.topAnchor),
            self.labelSubview.heightAnchor.constraint(equalTo: self.image.heightAnchor),
            self.labelSubview.leftAnchor.constraint(equalTo: self.image.rightAnchor, constant: 16.0),
            self.labelSubview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0),
            self.label.centerXAnchor.constraint(equalTo: self.labelSubview.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.labelSubview.centerYAnchor),
        ])
    }
    
    func loadAlbum() {
        self.label.text = "Nirvana – Nevermind"
        self.image.image = UIImage(named: "Nevermind")
    }
    
    func addSubviews() {
        self.labelSubview.addSubview(self.label)
        self.view.addSubview(self.labelSubview)
        self.view.addSubview(self.image)
        self.view.addSubview(self.slider)
        self.view.addSubview(self.progress)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
        case (.regular, .regular):
            configureRegularRegular()
        case (.compact, .compact):
            configureCompactCompact()
        case (.regular, .compact):
            configureRegularCompact()
        case (.compact, .regular):
            configureCompactRegular()
        default: break
        }
    }
    
    func configureRegularRegular() {
        //
    }
    
    func configureCompactCompact() {
        self.configureRegularCompact()
    }
    
    func configureRegularCompact() {
        NSLayoutConstraint.deactivate(self.portraitConstraints)
        NSLayoutConstraint.activate(self.albumConstraints)
    }
    
    func configureCompactRegular() {
        NSLayoutConstraint.activate(self.portraitConstraints)
        NSLayoutConstraint.deactivate(self.albumConstraints)
    }
}

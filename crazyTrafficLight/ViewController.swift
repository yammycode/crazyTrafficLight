//
//  ViewController.swift
//  crazyTrafficLight
//
//  Created by Anton Saltykov on 29.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var redLightView: UIView!
    @IBOutlet var yellowLightView: UIView!
    @IBOutlet var greenLightView: UIView!
    @IBOutlet var lightButton: UIButton!
    
    
    var opacity = 0.3
    var lights: [UIView] = []
    var activeLightIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightButton.backgroundColor = .systemBlue
        lightButton.setTitle("START", for: .normal)
        lightButton.layer.cornerRadius = 20
        lightButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        lightButton.tintColor = .white
        
        lights = [redLightView, yellowLightView, greenLightView]
        
        for light in lights {
            light.layer.cornerRadius = light.frame.size.width / 2
            light.alpha = opacity
        }
        
    }
    
    @IBAction func changeLight() {
        
        guard !lights.isEmpty else { return }
        
        lightButton.setTitle("NEXT", for: .normal)
        
        if var index = activeLightIndex {
            lights[index].alpha = opacity
            index = index == lights.count - 1 ? 0 : index + 1
            lights[index].alpha = 1
            activeLightIndex = index
        } else {
            lights[0].alpha = 1
            activeLightIndex = 0
        }
    }

}


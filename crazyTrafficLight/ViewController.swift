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
    
    // Да-да, мой светофор реально crazy))
    // По-хорошему светофор должен работать так: красный -> желтый -> зеленый -> желтый -> красный
    var isReverse = false
    var isFlash = false // См flashCurrentLight

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
        
        if let oldLight = activeLightIndex {
            lights[oldLight].alpha = opacity
            activeLightIndex = getNextLight(after: activeLightIndex!)
            lights[activeLightIndex!].alpha = 1

            // Еще чуток прокачаем наш светофор))
            // Желтый - предупреждающий обычно мигает
            isFlash = activeLightIndex == 1
            flashCurrentLight(for: activeLightIndex!)
            
        } else {
            // Начало работы светофора
            lights[0].alpha = 1
            activeLightIndex = 0
        }
    }
    
    // Функция определяет следующий сигнал свтофора
    // Если мы движемся от красного к зеленому, то берем следующий сигнал
    // Если от зеленого к красному - берем предыдущий
    // Если достигаем крайних сигналов (зеленый для движения вниз и красный при движении вверх) - меняем направление
    private func getNextLight(after oldLight: Int) -> Int {
        let newLight: Int
        
        if isReverse {
            if oldLight == 0 {
                isReverse = false
                newLight = oldLight + 1
            } else {
                newLight = oldLight - 1
            }
        } else {
            if oldLight == lights.count - 1 {
                isReverse = true
                newLight = oldLight - 1
            } else {
                newLight = oldLight + 1
            }
        }
        
        return newLight
    }
    
    // Только для моего crazyTraffcLight))
    private func flashCurrentLight(for flashingIndex: Int, isRepeat: Bool = false) {
        if let activeLightIndex = activeLightIndex, isFlash, flashingIndex == activeLightIndex {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: { [self] in
                // Почему-то без [self] не работает, хоть мы его тут явно и не указываем....
                lights[activeLightIndex].alpha = lights[activeLightIndex].alpha == 1 ? opacity : 1
                flashCurrentLight(for: flashingIndex, isRepeat: true)
             })
        } else if isRepeat {
            // Это когда произошло переключение сигнала (переданный index не равен текущему activeLightIndex),
            // но при этом предыдущий флэш еще не отработал
            // Поэтому мы его принудительно гасим, чтобы он не сработал при другом сигнале
            lights[flashingIndex].alpha = opacity
        }
    }
}


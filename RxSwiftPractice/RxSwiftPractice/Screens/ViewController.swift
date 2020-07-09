//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by TaeHyeong Kim on 2020/07/09.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createSubject()

        
    }
    
    func createSubject(){
        let subject = PublishSubject<String>()
        subject.onNext("Is anyone listening?")
        
        let subscriptionOne = subject
            .subscribe(onNext: { string in
                print(string)
            })
        //위 코드까지만 쓰면 print되지 않는다.
        //왜냐하면 subscribe 된 후에 추가된 값부터 볼 수 있기 때문
        subject.on(.next("1")) //1
        //subscribe 후에 추가된 값 1은 print된다.
        subject.onNext("2") //1 2
        subscriptionOne.dispose()
        
        let subscriptionTwo = subject
            .subscribe { event in
                print("2)", event.element ?? event)
        }
        subject.onNext("3")
        subject.onNext("4")
        
        subject.onCompleted()
        subject.onNext("5") //this will not be emitted since subject is terminated
        subscriptionTwo.dispose() //dispose done subscriptions
        let disposeBag = DisposeBag()
        
        subject.subscribe {
            print("3)",$0.element ?? $0)
        }.disposed(by: disposeBag)
        subject.onNext("?")
//        1
//        2
//        2) 3
//        2) 4
//        2) completed
//        3) completed
    }
    
    func chapter1(){
        //        let chapter2 = Chapter2Observables()
        //        chapter2.createObservable()
        //        chapter2.practiceObservable()
        //        chapter2.disposePractice()
        //        chapter2.observableFactories()
        //        chapter2.singleTrait()
        //        chapter2.challenge1()
        //        chapter2.challenge2()
    }
    
    
    
}






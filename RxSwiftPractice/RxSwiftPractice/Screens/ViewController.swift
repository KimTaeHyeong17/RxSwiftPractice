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
//        createObservable()
//        practiceObservable()
//        disposePractice()
//        observableFactories()
//        singleTrait()
//        challenge1()
        challenge2()
        
    }
    func challenge2(){
        let observable = Observable.of(1,2,3,4)
        let disposeBag = DisposeBag()
        
        observable
            .debug("observable")
            .subscribe(
                onNext: { element in
                    print(element)
            },
                onCompleted: {
                    print("Completed")
            },
                onDisposed: {
                    print("Disposed")
            }
        )
            .disposed(by: disposeBag)
//        2020-07-09 19:05:40.232: observable -> subscribed
//        2020-07-09 19:05:40.234: observable -> Event next(1)
//        1
//        2020-07-09 19:05:40.234: observable -> Event next(2)
//        2
//        2020-07-09 19:05:40.234: observable -> Event next(3)
//        3
//        2020-07-09 19:05:40.234: observable -> Event next(4)
//        4
//        2020-07-09 19:05:40.235: observable -> Event completed
//        Completed
//        Disposed
//        2020-07-09 19:05:40.235: observable -> isDisposed

    }
    
    func challenge1(){
        let observable = Observable.of(1,2,3,4)
        let disposeBag = DisposeBag()
        
        observable
            .do(onSubscribe: {
                print("its subscribed")
            })
          .subscribe(
            onNext: { element in
              print(element)
            },
            onCompleted: {
              print("Completed")
            },
            onDisposed: {
              print("Disposed")
            }
          )
            .disposed(by: disposeBag)
    }
    func singleTrait() {
        let disposeBag = DisposeBag()
        enum FileReadError : Error {
            case fileNotFound, unreadable, encodingFailed
        }
        func loadText(from name: String) -> Single<String> {
            return Single.create{ single in
                let disposable = Disposables.create()
                guard let path  = Bundle.main.path(forResource: name, ofType: "txt") else {
                    single(.error(FileReadError.fileNotFound))
                    return disposable
                }
                guard let data = FileManager.default.contents(atPath: path) else {
                    single(.error(FileReadError.unreadable))
                    return disposable
                }
                guard let contents = String(data: data, encoding: .utf8) else{
                    single(.error(FileReadError.encodingFailed))
                    return disposable
                }
                single(.success(contents))
                return disposable
            }
        }
        
        loadText(from: "Copyright")
            .subscribe {
                switch $0 {
                case .success(let string) :
                    print(string)
                case .error(let err):
                    print(err)
                }
        }
        .disposed(by: disposeBag)
    }
    func observableFactories(){
        //return different observables based on whether flip is true or false
        let disposeBag = DisposeBag()
        var flip = false
        let factory: Observable<Int> = Observable.deferred {
            flip.toggle()
            if flip {
                return Observable.of(1,2,3)
            }else {
                return Observable.of(4,5,6)
            }
        }
        
        for _ in 0...3 {
            factory.subscribe(onNext: {
                print($0,terminator: "")
            })
            .disposed(by: disposeBag)
            print()
        }
    }
    func disposePractice(){
        let disposeBag = DisposeBag()
        
        Observable.of("A","B","C")
            .subscribe {
                print($0)
        }
        .disposed(by: disposeBag)
        
        Observable<String>.create { observer in
            observer.onNext("1")
            observer.onCompleted()
            observer.onNext("?")
            return Disposables.create()
        }.subscribe(
            onNext: {print($0)},
            onError: {print($0)},
            onCompleted: {print("complemted")},
            onDisposed: {print("Disposed")}
        )
//        1
//        complemted
//        Disposed
        
    }
    func practiceObservable(){
        let one = 1
        let two = 2
        let three = 3
        let observable2 = Observable.of(one,two,three)
        
        observable2.subscribe(
            onNext: { element in
                print(element)
        },
            onCompleted: {
                print("Completed")
        })
    }
    func createObservable() {
        let one = 1
        let two = 2
        let three = 3
        
        let observable = Observable<Int>.just(one)
        let observable2 = Observable.of(one,two,three)
        let observable3 = Observable.of([one,two,three])
        let observable4 = Observable.from([one,two,three])
        
        observable.subscribe( {event in
            print("observable: \(event)")
        })
        //observable: next(1)
        //observable: completed
        observable2.subscribe( { event in
            print("observable2: \(event)")
        })
        //observable2: next(1)
        //observable2: next(2)
        //observable2: next(3)
        //observable2: completed
        observable3.subscribe( { event in
            print("observable3: \(event)")
        })
        //observable3: next([1, 2, 3])
        //observable3: completed
        observable4.subscribe( { event in
            print("observable4: \(event)")
        })
        //observable4: next(1)
        //observable4: next(2)
        //observable4: next(3)
        //observable4: completed
        observable2.subscribe { event in
            if let element = event.element {
                print(element)
            }
        }
        //        1
        //        2
        //        3
        observable2.subscribe(onNext : {element in
            print(element)
        })
        //        1
        //        2
        //        3
    }
    
    
}






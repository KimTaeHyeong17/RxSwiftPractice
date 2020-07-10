//
//  Chapter3Subjects.swift
//  RxSwiftPractice
//
//  Created by TaeHyeong Kim on 2020/07/09.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation
import RxSwift

class Chapter3Subjects {
    
    func challenge1(){
        let disposeBag = DisposeBag()
        let dealtHand = PublishSubject<[(String,Int)]>()
        
        func deal(_ cardCount : UInt){
            var deck = cards
            var cardsRemaining = deck.count
            var hand = [(String, Int)]()
            
            for _ in 0..<cardCount {
                let randomIndex = Int.random(in: 0..<cardsRemaining)
                hand.append(deck[randomIndex])
                deck.remove(at: randomIndex)
                cardsRemaining -= 1
            }
            //Add code to update dealtHand here
            let handPoints = points(for: hand)
            if handPoints > 21 {
                dealtHand.onError(HandError.busted(points: handPoints))
            } else{
                dealtHand.onNext(hand)
            }
        }
        //add subscription to dealthand here
        dealtHand
            .subscribe(
                onNext: {
                    print(self.cardString(for: $0), "for", self.points(for:$0),"points")
            },
                onError: {
                    print(String(describing: $0).capitalized)
            })
            .disposed(by: disposeBag)
        
        deal(3)
    }
    func behaviorRelay(){
        let relay = BehaviorRelay(value: "Initial Value")
        let disposeBag = DisposeBag()
        
        relay.accept("New init value")
        relay.subscribe { event in
            print("1) ",event.element ?? event)
        }
        .disposed(by: disposeBag)
        
        relay.accept("1")
        relay
            .subscribe { event in
                print("2) ",event.element ?? event)
        }.disposed(by: disposeBag)
        relay.accept("2")
        print(relay.value)
    }
    func relayPractice(){
        let relay = PublishRelay<String>()
        let disposeBag = DisposeBag()
        relay.accept("is anyone home?")
        
        relay.subscribe(onNext: {
            print($0)
        })
            .disposed(by: disposeBag)
        relay.accept("1")
    }
    func replaySubject(){
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        let disposeBag = DisposeBag()
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        subject
            .subscribe { event in
                print("1) ", event.element ?? event)
        }.disposed(by: disposeBag)
        
        subject.onNext("4")
        
        subject.subscribe { event in
            print("2) " , event.element ?? event)
        }.disposed(by: disposeBag)
        
        
    }
    func createBehaviorSubject(){
        let subject = BehaviorSubject(value: "Inital value")
        let disposeBag = DisposeBag()
        subject.onNext("before subscribe")
        subject
            .subscribe { event in
                print("1)", event.element ?? event)
        }
        .disposed(by: disposeBag)
        subject.onNext("after subscribe")
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
    
    public let cards = [
        ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
        ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
        ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
        ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
    ]
    
    public func cardString(for hand: [(String, Int)]) -> String {
        return hand.map { $0.0 }.joined(separator: "")
    }
    
    public func points(for hand: [(String, Int)]) -> Int {
        return hand.map { $0.1 }.reduce(0, +)
    }
    
    public enum HandError: Error {
        case busted(points: Int)
    }
    
    
}

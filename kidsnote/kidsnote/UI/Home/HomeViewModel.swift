//
//  HomeViewModel.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel {
    
    enum SearchError: Error {
        case underlyingError(Error)
        case notFound
        case unkowned
    }
    
    private let searchSubject = PublishSubject<String>()
    var searchObserver: AnyObserver<String> {
        return searchSubject.asObserver()
    }
    
    // outputs
    private let loadingSubject = PublishSubject<Bool>()
    var isLoading: Driver<Bool> {
        return loadingSubject
            .asDriver(onErrorJustReturn: false)
    }
    
    private let errorSubject = PublishSubject<SearchError?>()
    var error: Driver<SearchError?> {
        return errorSubject
            .asDriver(onErrorJustReturn: SearchError.unkowned)
    }
    
    private let contentSubject = PublishSubject<[VolumeItem]>()
    var content: Driver<[VolumeItem]> {
        return contentSubject
            .asDriver(onErrorJustReturn: [])
    }
    
    private let api = API()
    private let bag = DisposeBag()
    
    init() {
        // 1
        searchSubject
            .asObservable()
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] term -> Observable<VolumeSearchResult> in
                self.loadingSubject.onNext(true)
                return self.search(byTerm: term)
                    .catch({ [unowned self] error -> Observable<VolumeSearchResult> in
                        self.errorSubject.onNext(SearchError.underlyingError(error))
                        return Observable.empty()})
            }
            .subscribe(onNext: { [unowned self] result in
                self.loadingSubject.onNext(false)
                
                if result.items.isEmpty {
                    self.errorSubject.onNext(SearchError.notFound)
                } else {
                    self.contentSubject.onNext(result.items)
                }
            })
            .disposed(by: bag)
    }
    
    private func search(byTerm term: String) -> Observable<VolumeSearchResult> {
        return Observable.create({ (observer) -> Disposable in
            if let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(term)&filter=ebooks") {
                Task {
                    do {
                        observer.onNext(try await self.api.request(type: VolumeSearchResult.self, url: url))
                        observer.onCompleted()
                    }
                    catch {
                        observer.onError(SearchError.notFound)
                    }
                }
            }
            return Disposables.create()
        })
    }
}

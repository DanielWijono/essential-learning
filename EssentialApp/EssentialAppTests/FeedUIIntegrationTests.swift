//
//  FeedUIIntegrationTests.swift.swift
//  EssentialFeediOSTests
//
//  Created by Silverius Daniel Wijono on 20/02/23.
//

import XCTest
import UIKit
import EssentialApp
import EssentialFeed
import EssentialFeediOS
import Combine

final class FeedUIIntegrationTests: XCTestCase {
  
  func test_feedView_hasTitle() {
    let (sut, _) = makeSUT()
    
    sut.loadViewIfNeeded()
    
    XCTAssertEqual(sut.title, localized("FEED_VIEW_TITLE"))
  }
  
  func test_loadFeedActions_requestFeedFromLoader() {
    let (sut, loader) = makeSUT()
    
    XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
    
    sut.loadViewIfNeeded()
    XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
    
    sut.simulateUserInitiatedFeedReload()
    XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")
    
    sut.simulateUserInitiatedFeedReload()
    XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
  }
  
  func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
    
    loader.completeFeedLoading(at: 0)
    XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
    
    sut.simulateUserInitiatedFeedReload()
    XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
    
    loader.completeFeedLoadingWithError(at: 1)
    XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
  }
  
  func test_loadFeedCompletion_renderSuccessfullyLoadedFeed() {
    let image0 = makeImage(description: "a description", location: "a location")
    let image1 = makeImage(description: nil, location: "another location")
    let image2 = makeImage(description: "another description", location: nil)
    let image3 = makeImage(description: nil, location: nil)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    assertThat(sut, isRendering: [])
    
    loader.completeFeedLoading(with: [image0], at: 0)
    assertThat(sut, isRendering: [image0])
    
    sut.simulateUserInitiatedFeedReload()
    loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
    assertThat(sut, isRendering: [image0, image1, image2, image3])
  }
  
  func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
    let image0 = makeImage()
    let image1 = makeImage()
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1], at: 0)
    assertThat(sut, isRendering: [image0, image1])
    
    sut.simulateUserInitiatedFeedReload()
    loader.completeFeedLoading(with: [], at: 1)
    assertThat(sut, isRendering: [])
  }
  
  func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
    let image0 = makeImage()
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0], at: 0)
    assertThat(sut, isRendering: [image0])
    
    sut.simulateUserInitiatedFeedReload()
    loader.completeFeedLoadingWithError(at: 1)
    assertThat(sut, isRendering: [image0])
  }
  
  func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    XCTAssertEqual(sut.errorMessage, nil)
    
    loader.completeFeedLoadingWithError(at: 0)
    XCTAssertEqual(sut.errorMessage, localized("FEED_VIEW_CONNECTION_ERROR"))
    
    sut.simulateUserInitiatedFeedReload()
    XCTAssertEqual(sut.errorMessage, nil)
  }
  
  func test_feedImageView_loadsImageURLWhenVisible() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    
    XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
    
    sut.simulateFeedImageViewVisible(at: 0)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first view becomes visible")
    
    sut.simulateFeedImageViewVisible(at: 1)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once second view also becomes visible")
  }
  
  func test_feedImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")
    
    sut.simulateFeedImageViewNotVisible(at: 0)
    XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected one cancelled image URL request once first image is not visible anymore")
    
    sut.simulateFeedImageViewNotVisible(at: 1)
    XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected two cancelled image URL requests once second image is also not visible anymore")
  }
  
  func test_feedImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage(), makeImage()])
    
    let view0 = sut.simulateFeedImageViewVisible(at: 0)
    let view1 = sut.simulateFeedImageViewVisible(at: 1)
    XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
    XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")
    
    loader.completeImageLoading(at: 0)
    XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
    XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")
    
    loader.completeImageLoadingWithError(at: 1)
    XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
    XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
  }
  
  func test_feedImageView_rendersImageLoadedFromURL() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage(), makeImage()])
    
    let view0 = sut.simulateFeedImageViewVisible(at: 0)
    let view1 = sut.simulateFeedImageViewVisible(at: 1)
    XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
    XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")
    
    let imageData0 = UIImage.make(withColor: .red).pngData()!
    loader.completeImageLoading(with: imageData0, at: 0)
    XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
    XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")
    
    let imageData1 = UIImage.make(withColor: .blue).pngData()!
    loader.completeImageLoading(with: imageData1, at: 1)
    XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
    XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
  }
  
  func test_feedImageViewRetryButton_isVisibleOnImageURLLoadError() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage(), makeImage()])
    
    let view0 = sut.simulateFeedImageViewVisible(at: 0)
    let view1 = sut.simulateFeedImageViewVisible(at: 1)
    XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view while loading first image")
    XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action for second view while loading second image")
    
    let imageData = UIImage.make(withColor: .red).pngData()!
    loader.completeImageLoading(with: imageData, at: 0)
    XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action for first view once first image loading completes successfully")
    XCTAssertEqual(view1?.isShowingRetryAction, false, "Expected no retry action state change for second view once first image loading completes successfully")
    
    loader.completeImageLoadingWithError(at: 1)
    XCTAssertEqual(view0?.isShowingRetryAction, false, "Expected no retry action state change for first view once second image loading completes with error")
    XCTAssertEqual(view1?.isShowingRetryAction, true, "Expected retry action for second view once second image loading completes with error")
  }
  
  func test_feedImageViewRetryButton_isVisibleOnInvalidImageData() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage()])
    
    let view = sut.simulateFeedImageViewVisible(at: 0)
    XCTAssertEqual(view?.isShowingRetryAction, false, "Expected no retry action while loading image")
    
    let invalidImageData = Data("invalid image data".utf8)
    loader.completeImageLoading(with: invalidImageData, at: 0)
    XCTAssertEqual(view?.isShowingRetryAction, true, "Expected retry action once image loading completes with invalid image data")
  }
  
  func test_feedImageViewRetryAction_retriesImageLoad() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    
    let view0 = sut.simulateFeedImageViewVisible(at: 0)
    let view1 = sut.simulateFeedImageViewVisible(at: 1)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected two image URL request for the two visible views")
    
    loader.completeImageLoadingWithError(at: 0)
    loader.completeImageLoadingWithError(at: 1)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected only two image URL requests before retry action")
    
    view0?.simulateRetryAction()
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url, image0.url], "Expected third imageURL request after first view retry action")
    
    view1?.simulateRetryAction()
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url, image0.url, image1.url], "Expected fourth imageURL request after second view retry action")
  }
  
  func test_feedImageView_preloadsImageURLWhenNearVisible() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until image is near visible")
    
    sut.simulateFeedImageViewNearVisible(at: 0)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first image is near visible")
    
    sut.simulateFeedImageViewNearVisible(at: 1)
    XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once second image is near visible")
  }
  
  func test_feedImageView_cancelsImageURLPreloadingWhenNotNearVisibleAnymore() {
    let image0 = makeImage(url: URL(string: "http://url-0.com")!)
    let image1 = makeImage(url: URL(string: "http://url-1.com")!)
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [image0, image1])
    XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not near visible")
    
    sut.simulateFeedImageViewNotNearVisible(at: 0)
    XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected first cancelled image URL request once first image is not near visible anymore")
    
    sut.simulateFeedImageViewNotNearVisible(at: 1)
    XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected second cancelled image URL request once second image is not near visible anymore")
  }
  
  func test_feedImageView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage()])
    
    let view = sut.simulateFeedImageViewNotVisible(at: 0)
    loader.completeImageLoading(with: anyImageData())
    
    XCTAssertNil(view?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
  }
  
  func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
    let (sut, loader) = makeSUT()
    sut.loadViewIfNeeded()
    
    let exp = expectation(description: "Wait for background queue")
    DispatchQueue.global().async {
      loader.completeFeedLoading(at: 0)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
    let (sut, loader) = makeSUT()
    
    sut.loadViewIfNeeded()
    loader.completeFeedLoading(with: [makeImage()])
    _ = sut.simulateFeedImageViewVisible(at: 0)
    
    let exp = expectation(description: "Wait for background queue")
    DispatchQueue.global().async {
      loader.completeImageLoading(with: self.anyImageData(), at: 0)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
  
  
  //MARK: - Helpers
  
  private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
    let loader = LoaderSpy()
    let sut = FeedUIComposer.feedComposedWith(feedLoader: loader.loadPublisher, imageLoader: loader.loadImageDataPublisher)
    trackForMemoryLeaks(loader, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, loader)
  }
  
  private func assertThat(_ sut: FeedViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
    sut.view.enforceLayoutCycle()
    
    guard sut.numberOfRenderedFeedImageViews() == feed.count else {
      return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
    }
    
    feed.enumerated().forEach { index, image in
      assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
    }
  }
  
  private func assertThat(_ sut: FeedViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
    let view = sut.feedImageView(at: index)
    
    guard let cell = view as? FeedImageCell else {
      return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
    }
    
    let shouldLocationBeVisible = (image.location != nil)
    XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index \(index)", file: file, line: line)
    XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(String(describing: image.description)) for image view at index (\(index)", file: file, line: line)
  }
  
  private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
    return FeedImage(id: UUID(), description: description, location: location, url: url)
  }
  
  private func anyImageData() -> Data {
    return UIImage.make(withColor: .red).pngData()!
  }
  
  class LoaderSpy: FeedImageDataLoader {
    
    // MARK: - FeedLoader
    
    private var feedRequests = [PassthroughSubject<[FeedImage], Error>]()
    
    var loadCallCount: Int {
      return feedRequests.count
    }
    
    func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
      let publisher = PassthroughSubject<[FeedImage], Error>()
      feedRequests.append(publisher)
      return publisher.eraseToAnyPublisher()
    }
    
    func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
      feedRequests[index].send(feed)
    }
    
    func completeFeedLoadingWithError(at index: Int = 0) {
      let error = NSError(domain: "an error", code: 0)
      feedRequests[index].send(completion: .failure(error))
    }
    
    // MARK: - FeedImageDataLoader
    
    private struct TaskSpy: FeedImageDataLoaderTask {
      let cancelCallback: () -> Void
      
      func cancel() {
        cancelCallback()
      }
    }
    
    private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
    private(set) var cancelledImageURLs = [URL]()
    
    var loadedImageURLs: [URL] {
      return imageRequests.map { $0.url }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
      imageRequests.append((url, completion))
      return TaskSpy { [weak self] in
        self?.cancelledImageURLs.append(url)
      }
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
      imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int = 0) {
      let error = NSError(domain: "an error", code: 0)
      imageRequests[index].completion(.failure(error))
    }
  }
}

extension FeedViewController {
  func simulateUserInitiatedFeedReload() {
    refreshControl?.simulatePullToRefresh()
  }
  
  @discardableResult
  func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
    return feedImageView(at: index) as? FeedImageCell
  }
  
  @discardableResult
  func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
    let view = simulateFeedImageViewVisible(at: row)
    
    let delegate = tableView.delegate
    let index = IndexPath(row: row, section: feedImagesSection)
    delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
    
    return view
  }
  
  func simulateFeedImageViewNearVisible(at row: Int) {
    let ds = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    ds?.tableView(tableView, prefetchRowsAt: [index])
  }
  
  func simulateFeedImageViewNotNearVisible(at row: Int) {
    simulateFeedImageViewNearVisible(at: row)
    
    let ds = tableView.prefetchDataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
  }
  
  public func renderedFeedImageData(at index: Int) -> Data? {
    return simulateFeedImageViewVisible(at: index)?.renderedImage
  }
  
  var errorMessage: String? {
    return errorView?.message
  }
  
  var isShowingLoadingIndicator: Bool {
    return refreshControl?.isRefreshing == true
  }
  
  func numberOfRenderedFeedImageViews() -> Int {
    return tableView.numberOfRows(inSection: feedImagesSection)
  }
  
  func feedImageView(at row: Int) -> UITableViewCell? {
    guard numberOfRenderedFeedImageViews() > row else {
      return nil
    }
    let ds = tableView.dataSource
    let index = IndexPath(row: row, section: feedImagesSection)
    return ds?.tableView(tableView, cellForRowAt: index)
  }
  
  private var feedImagesSection: Int {
    return 0
  }
}

private extension FeedImageCell {
  func simulateRetryAction() {
    feedImageRetryButton.simulateTap()
  }
  
  var isShowingLocation: Bool {
    return !locationContainer.isHidden
  }
  
  var isShowingImageLoadingIndicator: Bool {
    return feedImageContainer.isShimmering
  }
  
  var isShowingRetryAction: Bool {
    return !feedImageRetryButton.isHidden
  }
  
  var locationText: String? {
    return locationLabel.text
  }
  
  var descriptionText: String? {
    return descriptionLabel.text
  }
  
  var renderedImage: Data? {
    return feedImageView.image?.pngData()
  }
}

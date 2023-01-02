//
//  ImageLoader.swift
//  kidsnote
//
//  Created by Steven Jiang on 2023/01/02.
//

import Foundation
import UIKit

enum ImageLoaderError: Error {
  case fetchFailed, saveToLocalFailed, decodeFailed
}
actor ImageLoader {
  
  private enum LoaderStatus {
    case inProgress(Task<UIImage, Error>)
    case fetched(UIImage)
  }
  
  private var images: [URLRequest: LoaderStatus] = [:]
  
  // MARK: - Public
  public func fetch(_ url: URL) async throws -> UIImage {
    let request = URLRequest(url: url)
    return try await fetch(request)
  }
  
  public func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
    if let status = images[urlRequest] {
      switch status {
      case .fetched(let image):
        return image
      case .inProgress(let task):
        return try await task.value
      }
    }
    
    if let image = try self.imageFromFileSystem(for: urlRequest) {
      images[urlRequest] = .fetched(image)
      return image
    }
    
    let task: Task<UIImage, Error> = Task {
      let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
      if let image = UIImage(data: imageData) {
        try self.persistImage(image, for: urlRequest)
        return image
      }
      print("[Error]: fetchFailed")
      throw ImageLoaderError.fetchFailed
    }
    
    images[urlRequest] = .inProgress(task)
    
    let image = try await task.value
    
    images[urlRequest] = .fetched(image)
    
    return image
  }
  
  // MARK: - File System
  func imageFromFileSystem(for urlRequest: URLRequest) throws -> UIImage? {
    guard let url = fileName(for: urlRequest) else {
      assertionFailure("Unable to generate a local path for \(urlRequest)")
      return nil
    }
    guard FileManager.default.fileExists(atPath: url.path) else {
      print("[Info]: File is not exists - \(url.path)")
      return nil
    }
    
    let data = try Data(contentsOf: url)
    return UIImage(data: data)
  }
  
  private func fileName(for urlRequest: URLRequest) -> URL? {
    guard let fileName = urlRequest.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
          let applicationSupport = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return nil
    }
    
    return applicationSupport.appendingPathComponent(fileName)
  }
  
  private func persistImage(_ image: UIImage, for urlRequest: URLRequest) throws {
    guard let url = fileName(for: urlRequest),
          let data = image.jpegData(compressionQuality: 0.8) else {
      assertionFailure("Unable to generate a local path for \(urlRequest)")
      return
    }
    
    do {
      try data.write(to: url)
    }
    catch {
      throw ImageLoaderError.saveToLocalFailed
    }
  }
}

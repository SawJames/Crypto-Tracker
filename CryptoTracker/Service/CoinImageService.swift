//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 16/09/2021.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = localFileManager.instance
    private let folderName = "coin-images"
    private let imageName : String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
            print("Retrieved image from file manager")
        }else{
            downloadCoinImage()
            print("Downloading image now")
        }
        
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap ({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink (receiveCompletion :
                    NetworkingManager.handleCompletion,
                    receiveValue: { [weak self](returnedImage) in
                        guard let self = self, let downloadImage = returnedImage else {return}
                    self.image = downloadImage
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, folderName: self.folderName)
            })

    }
}

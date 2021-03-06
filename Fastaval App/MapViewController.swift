//
//  MapViewController.swift
//  Fastaval App
//
//  Created by Peter Lind on 03/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var mapImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageViewTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeft: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewRight: NSLayoutConstraint!
    
    private var highlightedPoint : CGPoint?
    
    private var roomId : String?
    
    override func viewDidLoad() {
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIDevice.current.orientation.isLandscape {
            mapImageView.image = getUnrotatedMap()?.imageRotatedByDegrees(deg: -90)
            
        } else {
            mapImageView.image = getUnrotatedMap()
        }
    
    }
    
    func getUnrotatedMap() -> UIImage? {
        var tempImage : UIImage? = nil
        let mapLocation = FileLocationProvider().getMapLocation()
        let map = Directory.sharedInstance.getMap()!
        
        do {
            let data = try Data(contentsOf: mapLocation)
            let mapImage = FvMapImage(data: data)
            var mapHighlightedImage : UIImage? = nil
            
            
            if let roomId = map.getHighlightedRoom() ?? self.roomId {
                self.roomId = roomId
                mapHighlightedImage = mapImage?.highlightRoom(roomId: roomId)
                
                map.setHighlightedRoom(room: nil)
                highlightedPoint = mapImage?.getHighlightCenter(roomId: roomId)

            }
            
            tempImage = mapHighlightedImage ?? mapImage

        } catch {
            
        }

        return tempImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.roomId = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let unrotatedMap = getUnrotatedMap() else {
            return
        }
        
        if mapImageView == nil {
            return
        }
        
        if UIDevice.current.orientation.isLandscape {
            mapImageView.image = unrotatedMap.imageRotatedByDegrees(deg: -90)
            
        } else {
            mapImageView.image = unrotatedMap
        }

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImageView
    }
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        guard let mapSize = mapImageView.image else {
            return
        }
        
        let widthScale = size.width / mapSize.size.width
        let heightScale = size.height / mapSize.size.height
        let minScale = min(widthScale, heightScale)

        if minScale.isInfinite || minScale < 0.01 {
            return
        }

        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 10.0
        
        scrollView.zoomScale = minScale
        
        if highlightedPoint != nil {
            setInitialZoom(highlightedPoint!, size)
            highlightedPoint = nil
        }

    }

    private func setInitialZoom(_ highlightedPoint : CGPoint, _ size : CGSize) {
        let scale = CGFloat(2.5)
        scrollView.zoomScale = scrollView.zoomScale * scale

        let contentHeight = size.height * scale
        let contentWidth = size.width * scale
        let mapHeight = mapImageView.image!.size.height
        let mapWidth = mapImageView.image!.size.width
        
        var translatedX : CGFloat
        var translatedY : CGFloat
        
        if UIDevice.current.orientation.isLandscape {
            translatedX = contentWidth * (highlightedPoint.y / mapWidth) - size.width / 2
            
            translatedY = contentHeight * ((mapHeight - highlightedPoint.x) / mapHeight) - size.height / 2
            
        } else {
            translatedX = contentWidth * (highlightedPoint.x / mapWidth) - size.width / 2

            translatedY = contentHeight * (highlightedPoint.y / mapHeight) - size.height / 2
            
        }
        
        
        scrollView.contentOffset = CGPoint(x: translatedX, y: translatedY)
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        
        let yOffset = max(0, (size.height - mapImageView.frame.height) / 2)
        imageViewTop.constant = yOffset
        imageViewBottom.constant = yOffset
        
        let xOffset = max(0, (size.width - mapImageView.frame.width) / 2)
        imageViewLeft.constant = xOffset
        imageViewRight.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraintsForSize(size: view.bounds.size)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateMinZoomScaleForSize(size: view.bounds.size)
    }
}

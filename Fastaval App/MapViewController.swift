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
    
    private var highlightedRoom : String?
    
    override func viewDidLoad() {
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let map = FileLocationProvider().getMapLocation()
        
        let program = Directory.sharedInstance.getProgram()
        
        do {
            let data = try Data(contentsOf: map)
            let mapImage = FvMapImage(data: data)
            var mapHighlightedImage : UIImage? = nil
            
            if let currentEvent = program?.getCurrentEvent() {
                if let roomId = currentEvent.roomId {
                    mapHighlightedImage = mapImage?.highlightRoom(roomId: roomId)
                    
                    highlightedRoom = roomId
                    
                }

            }
            
            mapImageView.image = mapHighlightedImage ?? mapImage
            
        } catch {
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

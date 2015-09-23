//
//  FullScreenImageViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/10.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
protocol UsePhotoDelegate
{
    func setBackgroundImage(image:UIImage)
}
class FullScreenImageViewController: UIViewController,UIScrollViewDelegate {
    var imageView:UIImageView = UIImageView()
    var image:UIImage?
    var delegate:UsePhotoDelegate?
    var scrollView:UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView = UIScrollView(frame: view.frame)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize = image!.size
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = 1.0
        view.addSubview(scrollView)
        self.view.backgroundColor = UIColor.blackColor()
        imageView.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
        imageView.contentMode = UIViewContentMode.Center
        imageView.image = image
        scrollView.addSubview(imageView)
        setZoomingFactor()
        centerImageView()
        let useButton = UIBarButtonItem(title: "使用", style: UIBarButtonItemStyle.Plain, target: self
        , action: "usePhoto")
        self.navigationItem.rightBarButtonItem = useButton
        useButton.tintColor = UIColor(red: 21/255, green: 160/255, blue: 44/255, alpha: 1.0)
    }
    
    func usePhoto()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("SetImageNoti", object: image)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setZoomingFactor()
    {
        self.scrollView.maximumZoomScale = 1;
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.zoomScale = 1;
        
        // Bail if no image
        if (imageView.image == nil) {
            return
        }
        
        // Reset position
        imageView.frame = CGRectMake(0, 0, imageView.frame.size.width,imageView.frame.size.height);
        
        // Sizes
        let boundsSize = self.scrollView.bounds.size;
        let imageSize = imageView.image?.size
        
        // Calculate Min
        let xScale = boundsSize.width / imageSize!.width
        // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize!.height
        // the scale needed to perfectly fit the image height-wise
        var minScale = min(xScale, yScale)
        // use minimum of these to allow the image to become fully visible
        
        // Calculate Max
        var maxScale:CGFloat = 1.5;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad) {
            // Let them go a bit bigger on a bigger screen!
            maxScale = 4;
        }
        
        // Image is smaller than screen so no zooming!
        if (xScale >= 1 && yScale >= 1) {
            minScale = 1.0;
        }
        
        // Set min/max zoom
        self.scrollView.maximumZoomScale = maxScale
        self.scrollView.minimumZoomScale = minScale
        
        // Initial zoom
        self.scrollView.zoomScale = initializeZoomScaleWithMinScale()
        
        // If we're zooming to fill then centralise
        if (self.scrollView.zoomScale != minScale) {
            // Centralise
            self.scrollView.contentOffset = CGPointMake((imageSize!.width * self.scrollView.zoomScale - boundsSize.width) / 2.0,
                (imageSize!.height * self.scrollView.zoomScale - boundsSize.height) / 2.0);
            // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
            self.scrollView.scrollEnabled = false
        }
        
        // Layout
        view.setNeedsLayout()
    }
    
    func initializeZoomScaleWithMinScale()->CGFloat
    {
        var zoomScale = self.scrollView.minimumZoomScale;
        // Zoom image to fill if the aspect ratios are fairly similar
        let boundsSize = self.scrollView.bounds.size;
        let imageSize = self.imageView.image!.size;
        let boundsAR = boundsSize.width / boundsSize.height
        
        let imageAR = imageSize.width / imageSize.height;
        let xScale = boundsSize.width / imageSize.width;
        // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize.height;
        // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (abs(boundsAR - imageAR) < 0.17) {
            zoomScale = max(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = min(max(self.scrollView.minimumZoomScale, zoomScale), self.scrollView.maximumZoomScale);
        }
        return zoomScale;

    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        scrollView.scrollEnabled = true
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        //view.setNeedsLayout()
        //view.layoutIfNeeded()
        centerImageView()
    }
    
    func centerImageView()
    {
        let boundsSize = self.scrollView.bounds.size
        var frameToCenter = imageView.frame

        // Horizontally
        if (frameToCenter.size.width < boundsSize.width)
        {
            frameToCenter.origin.x = CGFloat(floorf(Float((boundsSize.width - frameToCenter.size.width) / 2.0)))
        } else {
            frameToCenter.origin.x = 0;
        }
        
        // Vertically
        if (frameToCenter.size.height < boundsSize.height) {
            frameToCenter.origin.y = CGFloat(floorf(Float((boundsSize.height - frameToCenter.size.height) / 2.0)))

        } else {
            frameToCenter.origin.y = 0;
        }
        
        // Center
        if (!CGRectEqualToRect(imageView.frame, frameToCenter))
        {
            imageView.frame = frameToCenter
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

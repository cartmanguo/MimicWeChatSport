//
//  MimicActionSheet.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/5.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
protocol MimicActionSheetDelegate
{
    func didClickButtonAtIndex(index:Int,actionSheet:MimicActionSheet)
}
class MimicActionSheet: UIView {

    let buttonHeight:CGFloat = 46.0
    let titleLabelHeight:CGFloat = 56.0
    private var titleLabel:UILabel!
    var buttonCnt:Int?
    var actionSheetDelegate:MimicActionSheetDelegate?
    var buttonsTitles:[String] = []
     var buttons:[UIButton] = []
    var actionSheet:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0))
    
    init(actionSheetDelegate:MimicActionSheetDelegate,title:String?,cancelButtonTitle:String?,otherButtonTitles:String...)
    {
        buttonsTitles = otherButtonTitles
        buttonCnt = otherButtonTitles.count
        super.init(frame: UIScreen.mainScreen().bounds)
        self.alpha = 0.0
        self.actionSheetDelegate = actionSheetDelegate
        self.backgroundColor = UIColor.blackColor()
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        var cancelBtnYPosition:CGFloat
        actionSheet.backgroundColor = UIColor(red: 225/255, green: 229/255, blue: 231/255, alpha: 1.0)
        if title != nil
        {
            actionSheet.frame.size.height = buttonHeight*CGFloat(buttonCnt!) + 8 + buttonHeight + titleLabelHeight
            titleLabel = UILabel(frame: CGRectMake(0, 0, actionSheet.frame.size.width, titleLabelHeight))
            titleLabel.textColor = UIColor.lightGrayColor()
            titleLabel.font = UIFont.systemFontOfSize(13)
            titleLabel.text = title
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.backgroundColor = UIColor .whiteColor()
            actionSheet.addSubview(titleLabel)
            cancelBtnYPosition = buttonHeight*CGFloat(buttonCnt!)+8+titleLabelHeight
        }
        else
        {
            actionSheet.frame.size.height = buttonHeight*CGFloat(buttonCnt!) + 8 + buttonHeight
            cancelBtnYPosition = buttonHeight*CGFloat(buttonCnt!)+8
        }
        actionSheet.frame.origin.y = self.frame.size.height
        UIApplication.sharedApplication().keyWindow?.addSubview(actionSheet)
        let cancelButton = UIButton.buttonWithType(.Custom) as! UIButton
        cancelButton.frame = CGRectMake(0, cancelBtnYPosition, self.frame.size.width, buttonHeight)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.addTarget(self, action: "dismiss", forControlEvents: .TouchUpInside)
        actionSheet.addSubview(cancelButton)
        for title in otherButtonTitles
        {
            let btn = createButtonWithTitle(title)
            if let otherBtn = btn
            {
                actionSheet.addSubview(otherBtn)
            }
        }
    }
    
    private func createButtonWithTitle(title:String?) -> UIButton?
    {
        let index = find(buttonsTitles, title!)
        if let titleIdx = index
        {
            var startYPosition:CGFloat = 0
            if titleLabel != nil
            {
                startYPosition = titleLabelHeight
                let separatorLine = UIView(frame: CGRectMake(0, titleLabelHeight, actionSheet.frame.size.width, 0.5))
                separatorLine.backgroundColor = actionSheet.backgroundColor
                actionSheet.addSubview(separatorLine)
            }
            let albumButton = UIButton.buttonWithType(.Custom) as! UIButton
            albumButton.frame = CGRectMake(0, startYPosition + buttonHeight * CGFloat(titleIdx), actionSheet.frame.size.width, buttonHeight)
            albumButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            albumButton.setTitle(title!, forState: .Normal)
            albumButton.backgroundColor = UIColor.whiteColor()
            albumButton.tag = titleIdx
            albumButton.addTarget(self, action: "clickedBtn:", forControlEvents: .TouchUpInside)
            if titleIdx > 0
            {
                let separatorLine = UIView(frame: CGRectMake(0, 0, actionSheet.frame.size.width, 0.5))
                separatorLine.backgroundColor = actionSheet.backgroundColor
                albumButton.addSubview(separatorLine)
            }
            buttons.append(albumButton)
            return albumButton
            
        }
        return nil
    }
    
    func show()
    {
        UIView.animateWithDuration(0.3, animations: {() in
            self.alpha = 0.3
            self.actionSheet.frame.origin.y = self.frame.size.height - self.actionSheet.frame.size.height
        })
    }
    
    func dismiss()
    {
        UIView.animateWithDuration(0.3, animations: {() in
                self.alpha = 0.0
                self.actionSheet.frame.origin.y = self.frame.size.height
            }, completion: {(finished) in
                self.actionSheet.removeFromSuperview()
                self.removeFromSuperview()
        })
    }
    
    func clickedBtn(sender:AnyObject)
    {
        let clickedButton = sender as! UIButton
        let btnIndex = clickedButton.tag
        actionSheetDelegate?.didClickButtonAtIndex(btnIndex,actionSheet: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

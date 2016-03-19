//
//  ArticleViewController.swift
//  iRead
//
//  Created by Simon on 16/3/18.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import SnapKit
import DTFoundation

class ArticleViewController: UIViewController {

    var feedItem: FeedItemModel?
    var feed: FeedModel?
   
    var scrollView = UIScrollView()
   
//    var containerView = UIView()
    lazy var containerView : DTAttributedTextContentView = {
        let view = DTAttributedTextContentView(frame: CGRectZero)
        view.shouldDrawImages = false
        view.shouldDrawLinks = false
        
        return view
    }()
    
    lazy var articleView : ArticleView = {
        let view = ArticleView()
        view.shouldDrawImages = false
        view.shouldDrawLinks = false
        view.delegate = self
       
        return view
    }()
    
    var index:Int = 0
    
    // MARK: - View Life Cycle ♻️
    
    override func loadView() {
        super.loadView()
        prepareForView()
        
        prepareForSubview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        configureContentConstraint()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        DTCoreTextLayoutFrame.setShouldDrawDebugFrames(true)
        articleView.setNeedsDisplay()
        
//        [DTCoreTextLayoutFrame setShouldDrawDebugFrames:![DTCoreTextLayoutFrame shouldDrawDebugFrames]];
//        [_textView.attributedTextContentView setNeedsDisplay];
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Preparation 📱
    private func prepareForSubview() {
        
//        DTAttributedTextContentView.setLayerClass(DTTiledLayerWithoutFade.self)
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints(closure: {
            make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        })
        
        scrollView.addSubview(containerView)
        containerView.snp_makeConstraints(closure: {
            make in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        })
        
        containerView.addSubview(articleView)
        articleView.snp_makeConstraints(closure: {
            make in
            
            make.top.equalTo(containerView).offset(iReadConstant.ArticleView.contentMargin)
            make.left.equalTo(containerView).offset(iReadConstant.ArticleView.contentMargin)
            make.right.equalTo(containerView).offset(-1 * iReadConstant.ArticleView.contentMargin)
            
        })
    }

    private func prepareForView() {
        self.view.backgroundColor = iReadColor.themeWhiteColor
        
    }

    // MARK: - Congfigure Data
    convenience init(title: String?, feedItem model: FeedItemModel, feedModel: FeedModel) {

        self.init()
        configureContent(title, feedItem: model, feedModel: feedModel)
    }
    
    func configureContent(title: String?, feedItem model: FeedItemModel, feedModel: FeedModel) {
        self.title = title
        feedItem = model
//        print(model)
        
    }
    

    private func configureContentConstraint() {
        
//        let file = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent("default_css.html")
//        
//        let style = try? NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding)
//       
//
//         guard let description = self.feedItem?.description else {
//            
//            print("item description is nil ")
//            return
//        }
//        
//        let content = (style as! String) + description
// 
//        guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
//            fatalError("Feed Data Error")
//        }
//        
//        let attrString = NSAttributedString(HTMLData: contentData, documentAttributes: nil)
        
        let attrString = attributedStringForSnippet()
        
        articleView.attributedString = attrString
        DTAttributedTextContentView.setLayerClass(DTTiledLayerWithoutFade.self)
 
        let textlayout = DTCoreTextLayouter(attributedString: attrString)
        
        let maxRect = CGRectMake(0, 0, iReadConstant.ScreenSize.width, CGFloat(CGFLOAT_HEIGHT_UNKNOWN))
        let range = NSMakeRange(0, attrString.length)
        
        let textlayoutFrame = textlayout.layoutFrameWithRect(maxRect, range: range)
        
        let size = textlayoutFrame.frame.size
        
        articleView.snp_updateConstraints(closure: {
            make in
            
            let height = size.height + CGFloat(iReadConstant.ArticleView.contentMargin)
            make.height.equalTo(height)
        })
        
        scrollView.snp_updateConstraints(closure: {
            make in
            make.bottom.equalTo(self.articleView.snp_bottom)
            
        })
        
    }
    
    func attributedStringForSnippet() ->  NSAttributedString {
        // Load HTML data
        let file = (NSBundle.mainBundle().resourcePath! as NSString).stringByAppendingPathComponent("default_css.html")
        
        var style = try? NSString(contentsOfFile: file, encoding: NSUTF8StringEncoding)
        
        
        guard let description = self.feedItem?.description else {
            
            print("item description is nil ")
//            return
            fatalError("------")
        }
        
//        style = ""
        
        let content = (style as! String) + description
        
        guard let contentData = content.dataUsingEncoding(NSUTF8StringEncoding) else {
            fatalError("Feed Data Error")
        }
        
    // Create attributed string from HTML
    let maxImageSize = CGSizeMake(self.view.bounds.size.width - 30.0, self.view.bounds.size.height - 30.0);
    
//        let callBackBlock = { (element: DTHTMLElement) in
//
//                for oneChildElement in element.childNodes
//                {
//                   let oneChildElement = oneChildElement as! DTHTMLElement
//                // if an element is larger than twice the font size put it in it's own block
//
//                    if (oneChildElement.displayStyle == .Inline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize) {
//                   
//                        oneChildElement.displayStyle =  .Block
//
//                        oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height
//
//                        oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height
//                    }
//                }
//        }
        
        let options = [NSTextSizeMultiplierDocumentOption: NSNumber(float: 1.0), DTMaxImageSize: NSValue(CGSize: maxImageSize), DTDefaultLinkColor : iReadColor.themeBlueColor, DTDefaultLinkHighlightColor: iReadColor.themeLightBlueColor]
        
    
//    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption, [NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
//    @"Times New Roman", DTDefaultFontFamily,  @"purple", DTDefaultLinkColor, @"red", DTDefaultLinkHighlightColor, callBackBlock, DTWillFlushBlockCallBack, nil];
    
//    [options setObject:[NSURL fileURLWithPath:readmePath] forKey:NSBaseURLDocumentOption];
    
        let string = NSAttributedString(HTMLData: contentData, options: options, documentAttributes: nil)
    
    
        return string;
    }
    
    // MARK: - Handle Event
    
    func linkHandle(linkBtn: DTLinkButton) {
        print("go to the link handle 🕸")
        print(linkBtn.URL.absoluteString)
    }
    
    func longpressLinkHandle(recognizer: UILongPressGestureRecognizer) {
        print("handle long press link")
        print((recognizer.view as! DTLinkButton).URL.absoluteString)
        
    }

}

extension ArticleViewController : DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate {
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttributedString string: NSAttributedString!, frame: CGRect) -> UIView! {
        
        let attribute = string.attributesAtIndex(0, effectiveRange: nil)
        let url = attribute[DTLinkAttribute] as! NSURL
        let identifier = attribute[DTGUIDAttribute] as! String
        
        let linkBtn = DTLinkButton(frame: frame)
        linkBtn.minimumHitSize = CGSizeMake(15, 15)
        linkBtn.URL = url
        linkBtn.GUID = identifier
        
        let normalImage = attributedTextContentView.contentImageWithBounds(frame, options: DTCoreTextLayoutFrameDrawingOptions.Default)
        let highlightImage = attributedTextContentView.contentImageWithBounds(frame, options: DTCoreTextLayoutFrameDrawingOptions.DrawLinksHighlighted)
        linkBtn.setImage(normalImage, forState: .Normal)
        linkBtn.setImage(highlightImage, forState: .Highlighted)
        
        linkBtn.addTarget(self, action: "linkHandle:", forControlEvents: .TouchUpInside)
        let longGesture = UILongPressGestureRecognizer(target: self, action: "longpressLinkHandle:")
        linkBtn.addGestureRecognizer(longGesture)
 
        return linkBtn
        
    }
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, viewForAttachment attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
       
        if attachment.isKindOfClass(DTImageTextAttachment.self) && frame.size.width > iReadConstant.ArticleView.contentMargin {
            let imageAttachment = attachment as! DTImageTextAttachment
            
            let imageView = DTLazyImageView(frame: frame)
            imageView.delegate = self
            imageView.image = imageAttachment.image
            imageView.url = imageAttachment.contentURL
            
            if attachment.hyperLinkURL != nil {
                print("handle the image click")
            }
            
            return imageView
        }
        
        return nil
        
    }
    
    func attributedTextContentView(attributedTextContentView: DTAttributedTextContentView!, shouldDrawBackgroundForTextBlock textBlock: DTTextBlock!, frame: CGRect, context: CGContext!, forLayoutFrame layoutFrame: DTCoreTextLayoutFrame!) -> Bool {
        

        let roundedRect = UIBezierPath(roundedRect: CGRectInset(frame, 1, 1), cornerRadius: 10.0)
        
        let color = textBlock.backgroundColor
        
        if color != nil {
            
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            
            CGContextSetFillColor(context,[r, g, b, a])
            
            CGContextAddPath(context, roundedRect.CGPath)
            CGContextFillPath(context)
            
            CGContextAddPath(context, roundedRect.CGPath)
            CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
            CGContextStrokePath(context)
            
            return false
        }

        return true
    }
    
    func lazyImageView(lazyImageView: DTLazyImageView!, didChangeImageSize size: CGSize) {
        

        let url = lazyImageView.url
        let imageSize = size
        let predicate = NSPredicate(format: "contentURL == %@", url)
        
        var didLoad = false
        
        for  oneAttachment in self.articleView.layoutFrame.textAttachmentsWithPredicate(predicate) {

            let attachment = oneAttachment as! DTImageTextAttachment
            
            if imageSize.width > iReadConstant.ArticleView.contentMargin {
                
                let displayWidth = iReadConstant.ScreenSize.width - 2 * iReadConstant.ArticleView.contentMargin
                
                let displayHeight = displayWidth * (imageSize.height / imageSize.width)
                attachment.displaySize = CGSizeMake(displayWidth, displayHeight)
                
                attachment.originalSize = imageSize
            
                didLoad = true
            }
            
        }
        
        if didLoad {

            articleView.relayoutText()
//            let size = self.articleView.layoutFrame.frame.size
//            
//            self.articleView.snp_makeConstraints(closure: {
//                make in
//                make.height.equalTo(size.height + iReadConstant.ArticleView.contentMargin * 2)
//                
//            })
//            
//            containerView.snp_makeConstraints(closure: {
//                make in
//                make.bottom.equalTo(self.articleView.snp_bottom)
//                
//            })
            
        }
        
        
    }
}

/*
- (void)screenshot:(UIBarButtonItem *)sender
{
UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

CGRect rect = [keyWindow bounds];
UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);

CGContextRef context = UIGraphicsGetCurrentContext();
[keyWindow.layer renderInContext:context];

UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();

[[UIPasteboard generalPasteboard] setImage:image];
}

*/

//extension ArticleViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//        return nil
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//        
//        return nil
//    }
//    
//}
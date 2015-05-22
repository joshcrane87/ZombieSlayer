//
//  GameViewController.swift
//  FruitNinja
//
//  Created by Josh Crane on 5/22/15
//

import UIKit
import SpriteKit
import iAd
import GoogleMobileAds

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController,ADBannerViewDelegate,GADBannerViewDelegate {
    
    var sAdmobBannerView:GADBannerView!
    var sIAdBannerView:ADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if(showiAD == true) {
            self.canDisplayBannerAds = true
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "hideAdBanner", name:IAUtilsProductPurchasedNotification as String, object: nil)

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.originalContentView as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            
            skView.presentScene(scene)
        }
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == false) {
            if(showAdMob == true) {
                if sAdmobBannerView == nil {
                    sAdmobBannerView = GADBannerView(adSize: isIpad() ? kGADAdSizeSmartBannerPortrait : kGADAdSizeBanner);
                    self.sAdmobBannerView.rootViewController = self;
                    self.sAdmobBannerView.adUnitID = kGoogleBannerAppUnitID;
                    sAdmobBannerView.delegate = self;
                    self.view.addSubview(sAdmobBannerView)
                    var request = GADRequest();
                    // Requests test ads on devices you specify. Your test device ID is printed to the console when
                    // an ad request is made. GADBannerView automatically returns test ads when running on a
                    // simulator.
                    request.testDevices = ["8b36290ab3c989789b4f8ff10cc3d60a"]  // Eric's iPod Touch];
                    self.sAdmobBannerView.loadRequest(request)
                    sAdmobBannerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, sAdmobBannerView.frame.size.height);
                }
                else if(showiAD == true) {
                    if (sIAdBannerView == nil) {
                        sIAdBannerView = ADBannerView(adType: ADAdType.Banner);
                        sIAdBannerView.frame = CGRectMake(0, self.view.frame.size.height, sIAdBannerView.frame.width, sIAdBannerView.frame.height);
                        sIAdBannerView.delegate = self;
                        self.view.addSubview(sIAdBannerView);
                    }

                }
            }
        }
    }

    func bannerViewDidLoadAd(banner: ADBannerView!) {
        UIView.animateWithDuration(1, animations: { () -> Void in
            banner.frame = CGRectMake(0, self.view.frame.size.height-banner.frame.height, banner.frame.width, banner.frame.height);
        });
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        UIView.animateWithDuration(1, animations: { () -> Void in
            banner.frame = CGRectMake(0, self.view.frame.size.height, banner.frame.width, banner.frame.height);
        })
    }

    func adViewDidReceiveAd(view: GADBannerView!) {
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == false) {
            if(showAdMob == true) {
                UIView.animateWithDuration(1, animations: { () -> Void in
                    view.frame = CGRectMake(0, self.view.frame.size.height-view.frame.size.height, view.frame.size.width, view.frame.size.height);
                });
            }
        }
    }
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == false) {
            if(showAdMob == true) {
                UIView.animateWithDuration(1, animations: { () -> Void in
                    view.frame = CGRectMake(0, self.view.frame.size.height, view.frame.size.width, view.frame.size.height);
                });
            }
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    func hideAdBanner() {
        if(showAdMob == true) {
            if let banner = sAdmobBannerView {
                sAdmobBannerView.delegate = nil;
                sAdmobBannerView.removeFromSuperview();
                sAdmobBannerView = nil;
            }
            else {
                self.canDisplayBannerAds = false;
                if let banner = sIAdBannerView {
                    sIAdBannerView.delegate = nil;
                    sIAdBannerView.removeFromSuperview();
                    sIAdBannerView = nil;
                }

            }
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func isIpad()->Bool{
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
}


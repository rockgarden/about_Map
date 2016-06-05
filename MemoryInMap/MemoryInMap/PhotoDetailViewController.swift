//
//  VeuneDetailViewController.swift
//  MapTable-Swift
//
//  Created by Gazolla on 02/08/14.
//  Copyright (c) 2014 Gazolla. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, NavigationBarColorSource {

    var lblName:UILabel?
    var lblLatitude:UILabel?
    var lblLongitude:UILabel?
    var lblCity: UILabel?
    var lblAddress: UILabel?
    var lblCategoryName: UILabel?
    var lblWeather: UILabel?

    var navHeight:CGFloat?
    var width:CGFloat?
    var halfHeight:CGFloat?
    var height:CGFloat?

    convenience init(){
        self.init(nibName: nil, bundle: nil)

        view.backgroundColor = UIColor.whiteColor()

        navHeight = 0.0
        width = self.view.frame.size.width
        halfHeight = (self.view.frame.size.height - navHeight!)/2
        height = self.view.frame.size.height
        let labelHeight = 40.0 as CGFloat

        self.lblName = UILabel(frame: CGRectMake(0, 90, width!, labelHeight))
        self.lblName!.numberOfLines = 1
        // self.lblName!.font = UIFont (name: "Arial", size:30.0)
        self.lblName!.adjustsFontSizeToFitWidth = true
        self.lblName!.clipsToBounds = true
        self.lblName!.backgroundColor = UIColor.clearColor()
        self.lblName!.textColor = UIColor.blackColor()
        self.lblName!.textAlignment = NSTextAlignment.Center

        self.lblAddress = UILabel(frame: CGRectMake(0, 135, width!, labelHeight))
        self.lblAddress!.numberOfLines = 1
        // self.lblAddress!.font = UIFont (name: "Arial", size:30.0)
        self.lblAddress!.adjustsFontSizeToFitWidth = true
        self.lblAddress!.clipsToBounds = true
        self.lblAddress!.backgroundColor = UIColor.clearColor()
        self.lblAddress!.textColor = UIColor.blackColor()
        self.lblAddress!.textAlignment = NSTextAlignment.Center

        self.lblCity = UILabel(frame: CGRectMake(0, 180, width!, labelHeight))
        self.lblCity!.numberOfLines = 1
        // self.lblCity!.font = UIFont (name: "Arial", size:30.0)
        self.lblCity!.adjustsFontSizeToFitWidth = true
        self.lblCity!.clipsToBounds = true
        self.lblCity!.backgroundColor = UIColor.clearColor()
        self.lblCity!.textColor = UIColor.blackColor()
        self.lblCity!.textAlignment = NSTextAlignment.Center

        self.lblWeather = UILabel(frame: CGRectMake(0, 225, width!, labelHeight*4))
        self.lblWeather!.numberOfLines = 4
        // self.lblWeather!.font = UIFont (name: "Arial", size:30.0)
        self.lblWeather!.adjustsFontSizeToFitWidth = true
        self.lblWeather!.clipsToBounds = true
        self.lblWeather!.backgroundColor = UIColor.clearColor()
        self.lblWeather!.textColor = UIColor.blackColor()
        self.lblWeather!.textAlignment = NSTextAlignment.Center

        self.view.addSubview(self.lblName!)
        self.view.addSubview(self.lblAddress!)
        self.view.addSubview(self.lblCity!)
        self.view.addSubview(self.lblWeather!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        loadWeather()
    }

    func loadWeather() {
        let url = NSURL(string: "http://www.weather.com.cn/data/sk/101210101.html")

        let data = try? NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached)

        //var str = NSString(data: data, encoding: NSUTF8StringEncoding)

        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        let weatherInfo : AnyObject! = json.objectForKey("weatherinfo")
        let city : AnyObject! = weatherInfo.objectForKey("city")
        let temp : AnyObject! = weatherInfo.objectForKey("temp")
        let wind : AnyObject! = weatherInfo.objectForKey("WD")
        let ws : AnyObject! = weatherInfo.objectForKey("WS")
        
        self.lblWeather?.text = "城市：\(city)\n温度：\(temp)\n风：\(wind)\n风级：\(ws)"
    }

    // MARK: - RainbowColorSource
    func navigationBarInColor() -> UIColor {
        return UIColor.grayColor()
    }
}

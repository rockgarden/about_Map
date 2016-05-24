//
//  DetailViewController.swift
//  MemoryInMap
//
//  Created by wangkan on 16/4/14.
//  Copyright © 2016年 wangkan. All rights reserved.
//

import UIKit
import AEXML

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    func aeXML() {
        let xmlDoc = try? AEXMLDocument(xmlData: NSData(contentsOfURL: NSURL(string:"https://www.ibiblio.org/xml/examples/shakespeare/hen_v.xml")!)!)
        if let xmlDoc=xmlDoc {
            let prologue = xmlDoc.root.children[6]["PROLOGUE"]["SPEECH"]
            prologue.children[1].stringValue // Now all the youth of England are on fire,
            prologue.children[2].stringValue // And silken dalliance in the wardrobe lies:
            prologue.children[3].stringValue // Now thrive the armourers, and honour's thought
            prologue.children[4].stringValue // Reigns solely in the breast of every man:
            prologue.children[5].stringValue // They sell the pasture now to buy the horse,
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadWeather(){
        let url = NSURL(string: "http://www.weather.com.cn/data/sk/101210101.html")

        let data = try? NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingUncached)

        //var str = NSString(data: data, encoding: NSUTF8StringEncoding)

        let json : AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
        let weatherInfo : AnyObject! = json.objectForKey("weatherinfo")
        let city : AnyObject! = weatherInfo.objectForKey("city")
        let temp : AnyObject! = weatherInfo.objectForKey("temp")
        let wind : AnyObject! = weatherInfo.objectForKey("WD")
        let ws : AnyObject! = weatherInfo.objectForKey("WS")

        //tv!.text = "城市：\(city)\n温度：\(temp)\n风：\(wind)\n风级：\(ws)"
    }
}


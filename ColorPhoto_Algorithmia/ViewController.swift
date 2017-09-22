//
//  ViewController.swift
//  ColorPhoto_Algorithmia
//
//  Created by Den on 22.09.17.
//  Copyright © 2017 Den. All rights reserved.
//

import UIKit
import algorithmia
import SwiftyJSON



class ViewController: UIViewController {
    
    //Create the Algorithmia client object
    let AlgorithmiaClient = Algorithmia.client(simpleKey: "API_KEY")
    
    
    @IBOutlet weak var ImageUrlText: UITextField!
    @IBOutlet weak var ImgV: UIImageView!
    
    @IBAction func GetColorBt(_ sender: Any) {
        
        
        let url = URL(string: ImageUrlText.text!)
        let photoName = url?.lastPathComponent
        
        print("photoName",photoName!)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.ImgV.image = UIImage(data: data!)
                
                
                //---
                let foo = self.AlgorithmiaClient.algo(algoUri: "deeplearning/ColorfulImageColorization/1.1.5")
                foo.pipe(text: self.ImageUrlText.text!) { resp, error in
                    if (error == nil) {
                        let data = resp.getText()
                        let metadata = resp.getMetadata()
                        
                        print("DEBUG data",data)
                        print("DEBUG metadata",metadata)
                        
                        
                        //data://.algo/deeplearning/ColorfulImageColorization/temp/IMAGE_NAME
                        let algoDir = self.AlgorithmiaClient.dir("data://.algo/deeplearning/ColorfulImageColorization/temp/")
                        // Get the file's contents as a byte array
                        algoDir.file(name: photoName!).getData(completion: { (data, error) in
                            if (error == nil) {
                                DispatchQueue.main.async {
                                    self.ImgV.image = UIImage(data: data!)
                                }
                            } else {
                                print(error)
                            }
                        })
                        
                    } else {
                        print(error)
                    }
                }
                //--
                
                
            }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


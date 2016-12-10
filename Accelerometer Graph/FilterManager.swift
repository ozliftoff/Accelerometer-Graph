//
//  FilterManager.swift
//  Accelerometer Graph
//
//  Created by Alex Gubbay on 09/12/2016.
//  Copyright © 2016 Alex Gubbay. All rights reserved.
//

import Foundation

struct notificationManager{
    static var nc = NotificationCenter.default
    static let newRawDataNotification = Notification.Name("newRawData")
}



class FilterManager{
    
    static let sharedInstance = FilterManager()
    
    var activeFilters = [FilteringProtocol]()
    var filteringAxis = "x"
    
    init(){
        print("adding observer")
        NotificationCenter.default.addObserver(self, selector: #selector(FilterManager.newRawData), name: Notification.Name("newRawData"), object: nil)

    }

    @objc func newRawData(notification: NSNotification){
        
        let data = notification.userInfo as! Dictionary<String,accelPoint>
        let accelData = data["data"]
        let currentData = accelData?.getAxis(axis: "x")

        activeFilters[0].addDataPoint(dataPoint: currentData!)
        
    }
    
    func addNewFilter(filterName: String){
        
        switch filterName {
        case "High Pass":
            
            let highPass = HighPass(alpha: 1)
            highPass.id = activeFilters.count
            
            var update = {(data: [Double])->Void in
                
                self.receiveData(data: data, id: highPass.id)
            }
            
            highPass.addObserver(update: update)
            activeFilters.append(highPass)
        default:
            print("No match in FilterManager")
        }
        
    }
    
    func receiveData(data: [Double], id:Int){
        print(id)
        if(id == activeFilters.count){
            //DATADONE
        }else{
            for dataPoint in data{
                activeFilters[id+1].addDataPoint(dataPoint: dataPoint)
            }
        }
        
    }
}

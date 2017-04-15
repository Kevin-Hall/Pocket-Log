

import UIKit
import PlaygroundSupport

let iconColor = UIColor(red: 0/255, green: 200/255, blue: 255/255, alpha: 0.9)

let backColor = UIColor(red: 17/255, green: 17/255, blue: 24/255, alpha: 1)

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let items = ["H", "g", "H"]
    
    
    
    
    let greetinLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.font =  UIFont(name: "Helvetica Neue", size: 30)!
        label.textAlignment = NSTextAlignment.center
        label.frame = CGRect(x: 100, y: 100, width: 300, height: 100)
        return label
    }()
    
    //function type writer effect
    func punchText(text: String) {
        
        if text.characters.count > 0 {
            greetinLabel.text = "\(greetinLabel.text!)\(text.substring(to: text.index(after: text.startIndex)))"
            
            var time = 0.0
            
            if (text.characters.count < 30){
                time = 0.05
            } else {
                time = 0.05
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                self.punchText(text: text.substring(from: text.index(after: text.startIndex)))
            }
        } else {
            //finished punching text
        }
    }


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(greetinLabel)
        
        
        
        
        //createGradientLayer()
        
        
        var time = 2.0

        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.punchText(text: "Hello Apple.")
        }
        self.view.frame = CGRect(x: 0, y: 0, width: 500, height: 480)
        self.tableView = UITableView(frame:self.view.frame)
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.view.addSubview(self.tableView)
        
    }
    
    // DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "\(self.items[indexPath.row])"
        cell.textLabel?.textColor = iconColor
        cell.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 11)!
        cell.selectedBackgroundView = UIView()
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
    
 
    var gradientLayer: CAGradientLayer!

    
    
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [iconColor.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
    }
    
    
    
    // Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Did Select", message: "Row at index path \(indexPath)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    var indefiniteButton = UIButton()
    var flagButton = UIButton()
    var weekButton = UIButton()
    var todayButton = UIButton()
    var daysFromToday = UILabel()
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame: CGRect = tableView.frame
        
        
        todayButton = UIButton(frame: CGRect(x: frame.size.width/2 - 146,y:  10,width: 70,height: 25))
        todayButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 11)!
        todayButton.setTitle("today", for: .normal)
        todayButton.setTitleColor(backColor.withAlphaComponent(1.0), for: .normal)
        todayButton.backgroundColor = UIColor.white
        todayButton.layer.cornerRadius = 5
        //todayButton.addTarget(self, action: #selector(self.todayButtonTapped), for: .touchUpInside)
        

        
        weekButton = UIButton(frame: CGRect(x: frame.size.width/2 - 73,y:  10,width: 70,height: 25))
        weekButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 11)!
        weekButton.setTitle("soonest", for: .normal)
        weekButton.setTitleColor(backColor.withAlphaComponent(1.0), for: .normal)
        weekButton.backgroundColor = iconColor.withAlphaComponent(1.0)
        weekButton.layer.cornerRadius = 5
        //weekButton.addTarget(self, action: #selector(self.weekButtonTapped), for: .touchUpInside)
        
        flagButton = UIButton(frame: CGRect(x: frame.size.width/2,y:  10,width: 70,height: 25))
        flagButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 11)!
        flagButton.setTitle("flagged", for: .normal)
        flagButton.setTitleColor(backColor.withAlphaComponent(1.0), for: .normal)
        flagButton.backgroundColor = iconColor.withAlphaComponent(1.0)
        flagButton.layer.cornerRadius = 5
        //flagButton.addTarget(self, action: #selector(self.flagButtonTapped), for: .touchUpInside)
        

        
        indefiniteButton = UIButton(frame: CGRect(x: frame.size.width/2 + 73,y:  10,width: 70,height: 25))
        indefiniteButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 11)!
        indefiniteButton.setTitle("no date", for: .normal)
        indefiniteButton.setTitleColor(backColor.withAlphaComponent(1.0), for: .normal)
        indefiniteButton.backgroundColor = iconColor.withAlphaComponent(1.0)
        indefiniteButton.layer.cornerRadius = 5
        //indefiniteButton.addTarget(self, action: #selector(self.indefiniteButtonTapped), for: .touchUpInside)
        

        
        let headerView: UIView = UIView(frame: CGRect(x:0,y: 0,width: frame.size.width,height: frame.size.height))
        headerView.backgroundColor = backColor
        headerView.addSubview(todayButton)
        headerView.addSubview(weekButton)
        headerView.addSubview(indefiniteButton)
        headerView.addSubview(flagButton)
        headerView.addSubview(daysFromToday)
        return headerView

        
    }
}
var ctrl = MyViewController()
PlaygroundPage.current.liveView = ctrl.view

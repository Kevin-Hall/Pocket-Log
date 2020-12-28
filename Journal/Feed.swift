//
//  Feed.swift
//  Journal
//
//  Created by Kevin Hall on 6/7/18.
//  Copyright © 2018 Kevin Hall. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar
import Spruce
import CoreData
import CloudCore
import DropDown
import Toast_Swift
import Photos


//Core data retrieval
public var entries: [NSManagedObject] = [] //core data
public var entriesThisMonth: [NSManagedObject] = [] //core data
public var imagesThisMonth: [UIImage] = [] //core data
public var gridCollectionView: UICollectionView!
public var currentGradient: Int = 0

class MainFeed: UIViewController, CAAnimationDelegate, UISearchBarDelegate  {

    var selectedIndexPath : IndexPath!
    var showingFavorites = false
    
    let gradient = CAGradientLayer()
    public var gradientSet = [[CGColor]]()
    
    let impactFeedbackGenerator: (
        light: UIImpactFeedbackGenerator,
        medium: UIImpactFeedbackGenerator,
        heavy: UIImpactFeedbackGenerator) = (
            UIImpactFeedbackGenerator(style: .light),
            UIImpactFeedbackGenerator(style: .medium),
            UIImpactFeedbackGenerator(style: .heavy)
    )

    
    let context = persistentContainer.viewContext
    
    /* Post page */
    lazy var postScrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        scrollview.backgroundColor = COLOR_BG
        scrollview.alwaysBounceVertical = true
        //scrollview.alwaysBounceHorizontal = true
        //scrollView.isDirectionalLockEnabled = true
        scrollView.tag = 5
        
        return scrollview
    }()
    
    lazy var postImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = COLOR_BG
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
    }()
    
    lazy var postFavoriteImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var postDateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Avenir-Medium", size: 12)!
        view.numberOfLines = 1
        view.textColor = COLOR_TEXT
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var postContentLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Avenir-Book", size: 14)!
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = COLOR_TEXT.withAlphaComponent(0.8)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var pageAction: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let actionImg = UIImage(named: "action")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = COLOR_TEXT
        view.setImage(actionImg, for: .normal)
        view.addTarget(self, action: #selector(actionBtnAction(btn:)), for: .touchUpInside)
        view.contentHorizontalAlignment = .right
        
        return view
    }()
    
    
    
    //side menu buttons
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "preferences")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = COLOR_TEXT
        button.frame = CGRect(x: 15, y: 438, width: 166, height: 42)
        button.alpha = 1
        button.addTarget(self, action: #selector(scrollToSettings), for: .touchUpInside)
        button.setTitle("Preferences", for: .normal)
        button.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
//    let searchButton: UIButton = {
//        let button = UIButton()
//        button.contentHorizontalAlignment = .right
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 5
//        button.setBackgroundImage(UIImage(named: "search")?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.tintColor = COLOR_TEXT
//        button.frame = CGRect(x: 15, y: 438, width: 166, height: 42)
//        button.alpha = 1
//        button.setTitle("Search", for: .normal)
//        button.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
//        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
//        button.addTarget(self, action: #selector(filterSearch), for: .touchUpInside)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
//        return button
//    }()
    
    let viewallButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "all")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = COLOR_TEXT
        button.frame = CGRect(x: 15, y: 376, width: 166, height: 42)
        button.alpha = 1
        button.setTitle("All Logs", for: .normal)
        button.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        button.addTarget(self, action: #selector(filterAll), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let favoritesButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "favorites")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = COLOR_TEXT
        button.frame = CGRect(x: 15, y: 314, width: 166, height: 42)
        button.alpha = 1
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        button.addTarget(self, action: #selector(filterFavorites), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let currentButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .right
        button.clipsToBounds = true
        button.layer.cornerRadius = 5
        button.setBackgroundImage(UIImage(named: "current")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = COLOR_TEXT
        button.frame = CGRect(x: 15, y: 252, width: 166, height: 42)
        button.alpha = 1
        button.setTitle("This month", for: .normal)
        button.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
        button.addTarget(self, action: #selector(backToToday), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    

    
   
    
    // date formatters
    let dateFindingformatter = DateFormatter()
    let cellFormatter = DateFormatter()
    
    //current month and year on feed
    var currentMonth = ""
    var currentYear = ""

    //collection
    var headerView : CollectionHeaderView!
    var footer: CollectionFooterView!
    var gridLayout: GridLayout!
    var gridLayoutIpad: GridLayoutIpad!
    
    
    //the encapsulating scrollview for settings and feed
    @IBOutlet weak var scrollView: UIScrollView!
    
    let modelFactory = ModelFactory()

    
    // for scrolling below the threshold to show extra info view
    var willShowExtraInfo: Bool = false
    var showInfoLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Avenir-Book", size: 12)!
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = COLOR_TEXT.withAlphaComponent(0.5)
        view.backgroundColor = UIColor.clear
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        
        return view
    }()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gridCollectionView.frame = CGRect(x: self.view.frame.width*0.8, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: self.view.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentMonth == "" {
            getData()
            filterEntries(date: Date(), direction: "forward")
            //fetchAndSave()
        }
        
        //currentButton.setTitle("This month " + "(" + entriesThisMonth.count.description + ")", for: .normal)
        
        gridCollectionView.alpha = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let theme = UserDefaults.standard.string(forKey: "COLOR_THEME")
    
        gradientSet.append([g3, g4])
        gradientSet.append([g4, g1])
        gradientSet.append([g1, g2])
        gradientSet.append([g2, g3])
        
        gradient.frame = self.scrollView.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x:0, y:0)
        gradient.endPoint = CGPoint(x:1, y:1)
        gradient.drawsAsynchronously = true
        animateGradient()
        
        self.scrollView.layer.addSublayer(gradient)
        gradient.opacity = 0
    
        
        let onboardSeen = UserDefaults.standard.value(forKey: "ONBOARDING") as! Bool


        DispatchQueue.main.async(){
            if !onboardSeen {
                self.performSegue(withIdentifier: "toOnboarding", sender: self)
            }
        }

        dateFindingformatter.dateFormat = "MMMM yyyy"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NotificationCenter.default.addObserver(self, selector: #selector(scrollFromSettings), name: .scrollFromSettings, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: .themeChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCoreData(notification:)), name: .reloadCoreData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        cellFormatter.dateFormat = "MMMM d, YYYY"
        dateFindingformatter.dateFormat = "MMMM d, YYYY"
        
        // the main collectionview
        if UIDevice.current.userInterfaceIdiom == .pad {
            //do ur  ipad logic
            gridLayoutIpad = GridLayoutIpad()
            gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayoutIpad)
        }else {
            //do ur  iphone logic
            gridLayout = GridLayout()
            gridCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: gridLayout)
        }
        
        
        //layout for the main collection
        let layout = gridCollectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        layout?.sectionFootersPinToVisibleBounds = true
        layout?.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 25, right: 15)
        layout?.minimumInteritemSpacing = 10
        
        if DATE_ON_CARD {
            layout?.minimumLineSpacing = 25
        } else {
            layout?.minimumLineSpacing = 15
        }
        
        
        layout?.headerReferenceSize = CGSize(width: self.view.frame.width, height: 120)
        layout?.footerReferenceSize = CGSize(width: self.view.frame.width, height: 120)
        
        gridCollectionView.backgroundColor = COLOR_BG
        gridCollectionView.isOpaque = true
        gridCollectionView.clipsToBounds = true
        gridCollectionView.showsVerticalScrollIndicator = true
        gridCollectionView.showsHorizontalScrollIndicator = false
        gridCollectionView.indicatorStyle = .black
        //gridCollectionView.isPrefetchingEnabled = true
        gridCollectionView.isPagingEnabled = false
        gridCollectionView.alwaysBounceVertical = true
        gridCollectionView.alwaysBounceHorizontal = false
        gridCollectionView.isDirectionalLockEnabled = true
        gridCollectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
        gridCollectionView.register(CollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "CollectionFooterView")
        gridCollectionView!.register(ImageCell.self, forCellWithReuseIdentifier: "imagecell")
        gridCollectionView!.register(ImageTextCell.self, forCellWithReuseIdentifier: "imagetextcell")
        gridCollectionView!.register(TextCell.self, forCellWithReuseIdentifier: "textcell")
        self.scrollView.addSubview(gridCollectionView)
        
        
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        
        
        postScrollView.delegate = self
        self.view.addSubview(postScrollView)
        
        postScrollView.isUserInteractionEnabled = false
        postScrollView.alpha = 0
        postScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        postScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        postScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        postScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        

        
        
//        // load and initialize the preferences page
//        let preferencesPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Preferences") as! Preferences
//        self.addChildViewController(preferencesPage)
//        preferencesPage.didMove(toParentViewController: self)
//        var preferencesFrame : CGRect = self.view.frame
//        preferencesFrame.origin.y = self.view.frame.height
//        preferencesPage.view.frame = preferencesFrame
//        self.scrollView.addSubview(preferencesPage.view)
//
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width*1.8, height: self.view.frame.height)
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.width*0.8, y: 0)
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = COLOR_BG
        self.scrollView.isOpaque = true
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        
        self.scrollView.addSubview(settingsButton)
        self.scrollView.addSubview(favoritesButton)
        self.scrollView.addSubview(viewallButton)
        //self.scrollView.addSubview(searchButton)
         self.scrollView.addSubview(currentButton)
        
        
        
        
        
        let dismissWithTap = UITapGestureRecognizer(target: self, action: #selector(hideFullImage))
        postScrollView.addGestureRecognizer(dismissWithTap)
        
        // Prepare shortly before playing
        impactFeedbackGenerator.light.prepare()
        impactFeedbackGenerator.medium.prepare()
        impactFeedbackGenerator.heavy.prepare()
        
        self.view.backgroundColor = COLOR_BG
        self.view.isOpaque = true
        
        showInfoLabel.text = "\(entries.count) Entries\n\(entriesThisMonth.count) This Month"
        showInfoLabel.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: 50)
        
        //gridCollectionView.addSubview(showInfoLabel)
        

        

        
    }
    
 
    func filterEntries(date: Date, direction: String) {
        entriesThisMonth.removeAll()
        imagesThisMonth.removeAll()
        
        self.view.makeToastActivity(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2))
        
        let date = date
        dateFindingformatter.dateFormat = "MMMM YYYY"
        
        getData()
        
        for row in 0..<entries.count{
            let entry = entries[row]
            let cellDate = entry.value(forKey: "date") as! Date?
            
            if dateFindingformatter.string(from: cellDate!) == dateFindingformatter.string(from: date) {
                entriesThisMonth.append(entry)
                
                if let image = entry.value(forKey: "image") {
                    imagesThisMonth.append((image as! Data).toImage!)
                }else {
                    imagesThisMonth.append(UIImage())
                }
            }
        }
        
        
        
        
        
        dateFindingformatter.dateFormat = "MMMM"
        currentMonth = dateFindingformatter.string(from: date)
        
        dateFindingformatter.dateFormat = "YYYY"
        currentYear = dateFindingformatter.string(from: date)
        
        DispatchQueue.main.async {
            gridCollectionView.reloadData()
            
            let sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.05)
            //let rand = RandomSortFunction(interObjectDelay: 0.05)
            gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
            let animation = SpringAnimation(duration: 0.4)
            DispatchQueue.main.async {
                gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: sortFunction)
            }
            
            if direction == "forward" {
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations:{
                    self.headerView.monthLabel.alpha = 0
                    self.headerView.monthLabel.frame.origin.y = self.headerView.monthLabel.frame.origin.y + 5
                    
                    let addImg = UIImage(named: "plus")
                    self.headerView.addBtn.setImage(addImg, for: .normal)
                    
                    
                }, completion: { (success) -> Void in
                    self.headerView.monthLabel.text = self.currentMonth
                    self.headerView.yearLabel.text = self.currentYear
                    self.headerView.monthLabel.frame.origin.y = self.headerView.monthLabel.frame.origin.y - 10
                    self.headerView.monthLabel.alpha = 0.0
                    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations:{
                        self.headerView.monthLabel.frame.origin.y = self.headerView.monthLabel.frame.origin.y + 5
                        self.headerView.monthLabel.alpha = 1
                        self.headerView.addBtn.alpha = 1
                    }, completion: { (success) -> Void in
                        self.view.hideToastActivity()
                    })
                })
            } else {
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations:{
                    self.headerView.monthLabel.alpha = 0
                    self.headerView.monthLabel.frame.origin.y = self.headerView.monthLabel.frame.origin.y - 5
                    
                    
                }, completion: { (success) -> Void in
                    self.headerView.monthLabel.text = self.currentMonth
                    self.headerView.yearLabel.text = self.currentYear
                    self.headerView.monthLabel.frame.origin.y = self.headerView.monthLabel.frame.origin.y + 10
                    self.headerView.monthLabel.alpha = 0.0
                    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations:{
                        self.headerView.monthLabel.frame.origin.y = self.headerView.monthLabel.frame.origin.y - 5
                        self.headerView.monthLabel.alpha = 1
                    }, completion: { (success) -> Void in
                        self.view.hideToastActivity()
                    })
                })
            }
        }
        
        self.scrollView.hideAllToasts()
        if entriesThisMonth.count == 0 && self.childViewControllers.count < 2 && !showingFavorites && scrollView.contentOffset.y == 0 {
            var style = ToastStyle()
            style.titleColor = COLOR_TEXT
            style.titleFont = UIFont(name: "Avenir-Black", size: 25)!
            style.messageColor = COLOR_TEXT
            style.messageFont = UIFont(name: "Avenir-Roman", size: 15)!
            style.backgroundColor = UIColor.clear
            style.cornerRadius = 5
            style.fadeDuration = 1
            style.messageAlignment = .center
            style.titleAlignment = .center
            style.imageSize = CGSize(width: 185, height: 158)
            style.horizontalPadding = 0
            
            if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white  {
                // toast presented with multiple options and with a completion closure
                self.scrollView.makeToast("", duration: 1000, point: CGPoint(x: self.view.frame.width/2 + self.view.frame.width*0.8, y: self.view.frame.height/2), title: "", image: UIImage(named: "groupLight")!, style: style) { didTap in
                    if didTap {
                        self.headerView.menuBtn.isSelected = true
                        self.menuAction()
                    }
                }
            } else {
                // toast presented with multiple options and with a completion closure
                self.scrollView.makeToast("", duration: 1000, point: CGPoint(x: self.view.frame.width/2 + self.view.frame.width*0.8, y: self.view.frame.height/2), title: "", image: UIImage(named: "group")!, style: style) { didTap in
                    if didTap {
                        self.headerView.menuBtn.isSelected = true
                        self.menuAction()
                    }
                }
            }
        }
    }
    

    
//    @objc func filterSearch() {
//
//        entriesThisMonth.removeAll()
//        imagesThisMonth.removeAll()
//
//        self.view.makeToastActivity(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2))
//
//        self.headerView.showFavorites()
//        self.scrollView.hideAllToasts()
//
//        showingFavorites = false
//
//
//        var searchBar:UISearchBar = UISearchBar()
//
//
//        searchBar.frame = CGRect(x: self.view.frame.width*0.5 + 10, y: 60, width: self.view.frame.width-80, height: 50)
//        searchBar.searchBarStyle = UISearchBarStyle.prominent
//        searchBar.placeholder = " Search..."
//        searchBar.sizeToFit()
//        searchBar.isTranslucent = false
//        searchBar.backgroundImage = UIImage()
//        searchBar.delegate = self
//        self.scrollView.addSubview(searchBar)
//
//        DispatchQueue.main.async {
//
//            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations:{
//                self.headerView.menuBtn.isSelected = true
//                self.headerView.menuBtn.setImage(UIImage(), for: .normal)
//                self.headerView.menuBtn.tintColor = COLOR_BG
//                self.headerView.yearLabel.text = ""
//                self.headerView.monthLabel.text = ""
//                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width*0.5, y: 0), animated: true)
//                self.gradient.opacity = 0
//                gridCollectionView.alpha = 1
//                let addImg = UIImage(named: "x-1")
//                self.headerView.addBtn.setImage(addImg, for: .normal)
//
//            }, completion: { (success) -> Void in
//                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut], animations:{
//                    self.menuVC.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 100)
//                }, completion: { (success) -> Void in
//                    gridCollectionView.reloadData()
//
//                    //let sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.05)
//                    let rand = RandomSortFunction(interObjectDelay: 0.05)
//                    gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
//                    let animation = SpringAnimation(duration: 0.4)
//                    gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: rand)
//
//                    self.view.hideToastActivity()
//                })
//            })
//        }
//    }
    

    @objc func filterFavorites() {
        
        entriesThisMonth.removeAll()
        imagesThisMonth.removeAll()
        
        self.view.makeToastActivity(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2))
        
        self.headerView.showFavorites()
        self.scrollView.hideAllToasts()
        
        showingFavorites = true

        for row in 0..<entries.count{
            let entry = entries[row]
            let cellFav = entry.value(forKey: "favorite") as! Bool
            
            if cellFav {
                entriesThisMonth.append(entry)
                
                if let image = entry.value(forKey: "image") {
                    imagesThisMonth.append((image as! Data).toImage!)
                }else {
                    imagesThisMonth.append(UIImage())
                }
            }
        }
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations:{
                self.headerView.menuBtn.isSelected = true
                self.headerView.menuBtn.setImage(UIImage(named: "star-1")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.headerView.menuBtn.tintColor = UIColor(rgb: 0xFFC404)
                self.headerView.yearLabel.text = ""
                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width*0.8, y: 0), animated: true)
                
                gridCollectionView.alpha = 1
                
                let addImg = UIImage(named: "x-1")
                self.headerView.addBtn.setImage(addImg, for: .normal)
            }, completion: { (success) -> Void in

                gridCollectionView.reloadData()
                
                //let sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.05)
                let rand = RandomSortFunction(interObjectDelay: 0.05)
                gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
                let animation = SpringAnimation(duration: 0.4)
                gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: rand)
                
                self.view.hideToastActivity()
                
                self.gradient.opacity = 0

            })
        }
    }
    
    @objc func menuAction() {
        
        self.impactFeedbackGenerator.light.impactOccurred()
        
        self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), animated: true)

    }
    
    @objc func themeChanged() {
        UIApplication.shared.statusBarStyle = statusbar
        setNeedsStatusBarAppearanceUpdate()
        gridCollectionView.backgroundColor = COLOR_BG
        scrollView.backgroundColor = COLOR_BG
        view.backgroundColor = COLOR_BG
        gridCollectionView.reloadData()
        
        headerView.monthLabel.textColor = COLOR_TEXT
        headerView.yearLabel.textColor = COLOR_TEXT
        headerView.menuBtn.tintColor = COLOR_TEXT
        headerView.preferencesBtn.tintColor = COLOR_TEXT
        headerView.favoritesBtn.tintColor = COLOR_TEXT
        headerView.createTodayButton.backgroundColor = COLOR_BG
        headerView.createTodayButton.setTitleColor(COLOR_TEXT, for: .normal)
        headerView.createTodayButton.layer.borderColor = COLOR_TEXT.withAlphaComponent(0.5).cgColor
        headerView.bg.backgroundColor = COLOR_BG
        headerView.addBtn.tintColor = COLOR_TEXT
        
        postScrollView.backgroundColor = COLOR_BG
        postImageView.backgroundColor = COLOR_BG
        postDateLabel.textColor = COLOR_TEXT
        postContentLabel.textColor = COLOR_TEXT.withAlphaComponent(0.8)
        pageAction.tintColor = COLOR_TEXT
        
        settingsButton.tintColor = COLOR_TEXT
        //searchButton.tintColor = COLOR_TEXT
        viewallButton.tintColor = COLOR_TEXT
        favoritesButton.tintColor = COLOR_TEXT
        currentButton.tintColor = COLOR_TEXT
        
        
        settingsButton.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        //searchButton.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        viewallButton.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        favoritesButton.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
        currentButton.setTitleColor(COLOR_TEXT.withAlphaComponent(0.5), for: .normal)
    }

    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradient.colors = gradientSet[currentGradient]
            animateGradient()
        }
    }
    
    func getData() {
        let fetchRequest = NSFetchRequest<Entries>(entityName: "Entries")
        let sort = NSSortDescriptor(key: #keyPath(Entries.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
       
        //let predicate = NSPredicate(format: "%K BETWEEN {%@, %@}", argumentArray: [#keyPath(Entries.date), Date.getThisMonthStart(Date()), Date.getThisMonthEnd(Date())])
        //fetchRequest.predicate = predicate
        
        do {
            entries = try context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch Expenses")
        }
    }
    
    // gradient colors
    let g1 = UIColor(rgb: 0x00E2E8).withAlphaComponent(0.5).cgColor
    let g2 = UIColor(rgb: 0x4643FF).withAlphaComponent(0.5).cgColor
    let g3 = UIColor(rgb: 0xFE09AD).withAlphaComponent(0.5).cgColor
    let g4 = UIColor(rgb: 0xFFA415).withAlphaComponent(0.5).cgColor
    
    func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.delegate = self
        gradientChangeAnimation.duration = 1.5
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    @objc func actionBtnAction(btn: UIButton) {
        
        impactFeedbackGenerator.medium.impactOccurred()
        
        let dropDown = DropDown()
        
        DropDown.appearance().textColor = COLOR_TEXT
        DropDown.appearance().textFont = UIFont(name: "Avenir-Book", size: 14)!
        DropDown.appearance().backgroundColor = COLOR_BG
        DropDown.appearance().selectionBackgroundColor = COLOR_BG
        DropDown.appearance().cellHeight = 55
        
        // The view to which the drop down will appear on
        dropDown.anchorView = pageAction // UIView or UIBarButtonItem
        dropDown.animationduration = 0.2
        dropDown.cornerRadius = 5
        dropDown.dimmedBackgroundColor = COLOR_BG.withAlphaComponent(0.8)
        //dropDown.separatorColor = UIColor.black.withAlphaComponent(0.2)
        dropDown.shadowColor = UIColor.black.withAlphaComponent(0.2)
        
        dropDown.width = self.postImageView.bounds.width
        // The list of items to display. Can be changed dynamically
        
        let entry = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
        let curr = entry.value(forKey: "favorite") as! Bool
        
        if curr {
            dropDown.dataSource = ["Unfavorite", "Share", "Edit", "Delete"]
        } else {
            dropDown.dataSource = ["Favorite", "Share", "Edit", "Delete"]
        }
        
        dropDown.direction = .any
        
//        dropDown.cellNib = UINib(nibName: "CustomDropDownCell", bundle: nil)
//        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
//            guard let cell = cell as? CustomDropDownCell else { return }
//
//            // Setup your custom UI components
//            cell.suffixLabel.text = "gvhk"//"Suffix \(index)"
//        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            switch index {
            case 0:
                print("favorite")
                
                let entry = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
                let curr = entry.value(forKey: "favorite") as! Bool
                
                if curr {
                    self.modelFactory.updateFavorite(favorite: false, entry: entry, v: self.view)
                } else {
                    self.modelFactory.updateFavorite(favorite: true, entry: entry, v: self.view)
                }
                
                self.hideFullImage()
                gridCollectionView.delegate?.collectionView!(gridCollectionView, didSelectItemAt: (gridCollectionView.indexPathsForSelectedItems?.first)!)
                
            case 1:
                print("share")
                
                let firstActivityItem = "#pocketlog"
                let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
                // If you want to put an image
                //let image : UIImage = UIImage(named: "image.jpg")!
                self.pageAction.alpha = 0
                let image: UIImage = self.postScrollView.snapshot()!
                self.pageAction.alpha = 1
                
                let activityViewController : UIActivityViewController = UIActivityViewController(
                    activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
                
                // This lines is for the popover you need to show in iPad
                activityViewController.popoverPresentationController?.sourceView = self.postScrollView
                
                // This line remove the arrow of the popover to show in iPad
                activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
                activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
                
                self.present(activityViewController, animated: true, completion: nil)

                
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAsset(from: snapshot)
//                }, completionHandler: { success, error in
//                    if success {
//                        // Saved successfully!
//                        self.view.makeToast("Post saved to photos")
//                    }
//                    else if let error = error {
//                        // Save photo failed with error
//                    }
//                    else {
//                        // Save photo failed with no error
//                    }
//                })
                
            case 2:
                print("edit")
                
                let entry = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
                
                let vc = NewPost()
                
                vc.entry = entry
                vc.selectedDate = (entry.value(forKey: "date") as! Date?)!
                
                if let imageData = entry.value(forKey: "image"){
                    if (imageData as? Data != nil){
                        vc.image = (entry.value(forKey: "image") as! Data).toImage
                    }
                }
                
                if (entry.value(forKey: "content") as! String?) != ""{
                    vc.content = entry.value(forKey: "content") as! String?
                }
                
                vc.newPost = false
                if self.headerView.scrunched {
                    if self.showingFavorites {
                        self.headerView.unscrunchHeader(withFavorites: true)
                    } else {
                        self.headerView.unscrunchHeader(withFavorites: false)
                    }
                    self.headerView.scrunched = false
                }
                
                self.present(vc, animated: true) {
                    
                }
            case 3:
                print("delete")
                let alert = UIAlertController(title: "Delete this Entry?", message: "You can't undo this action", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        let entryToDelete = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
                        self.context.delete(entryToDelete)
                        
                        entries.removeAll()
                        
                        do {
                            try self.context.save()
                        } catch _ {
                            print("error")
                        }
                        
                        //NotificationCenter.default.post(name: .reloadCoreData, object: nil)
                        
                        self.getData()

                        self.dateFindingformatter.dateFormat = "MMMM yyyy"
                        let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)

                        self.hideFullImage()
                        self.filterEntries(date: curr!, direction: "forward")
                        self.fetchAndSave()
                        
                    }}))
                self.present(alert, animated: true, completion: nil)
            default:
                print("error")
            }
        }
        dropDown.show()
    }
    
    @objc func willEnterForeground() {
        // restart animation when app is reopened
        animateGradient()
    }

    @objc func reloadCoreData(notification: NSNotification) {
        
        let layout = gridCollectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of
        if DATE_ON_CARD {
            layout?.minimumLineSpacing = 25
        } else {
            layout?.minimumLineSpacing = 15
        }
        
        dateFindingformatter.dateFormat = "MMMM yyyy"
        let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)

        getData()
        filterEntries(date: curr!, direction: "forward")
        fetchAndSave()
        
        
       
        
        
        
        let sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.25)
        gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
        let animation = SpringAnimation(duration: 1.7)
        gridCollectionView.reloadData()
        DispatchQueue.main.async {
            gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: sortFunction)
            if self.postScrollView.alpha == 1 {
                self.hideFullImage()
                gridCollectionView.delegate?.collectionView!(gridCollectionView, didSelectItemAt: self.selectedIndexPath)
            }
        }
        

        
    }

    @objc func createNewPost() {
        if self.headerView.menuBtn.tintColor != UIColor.white {
            backToToday()
            //self.filterEntries(date: Date(), direction: "forward")
        } else {
            let vc = NewPost()
            vc.selectedDate = Date()
            self.present(vc, animated: true) {
            }
        }
    }
    
    func fetchAndSave() {
        //code to execute during refresher
        //self.view.makeToastActivity(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.width/2))
        //self.view.makeToast("Syncing with Icloud")
        
        
        CloudCore.pull(to: persistentContainer, error: { (error) in
            print("⚠️ FetchAndSave error: \(error)")
            DispatchQueue.main.async {
                //self.view.hideToast()
            }
        }) {
            DispatchQueue.main.async {
                //self.view.hideToast()
            }
        }
    }
    
    var cellFrameInSuperview:CGRect!
    
    func showFullImage(of image:UIImage?, content:String ,dateContent: String) {
        postScrollView.subviews.forEach({ $0.removeFromSuperview() })
        postScrollView.removeConstraints(postScrollView.constraints)
        postImageView.removeConstraints(postImageView.constraints)
        postFavoriteImageView.removeConstraints(postFavoriteImageView.constraints)
        postDateLabel.removeConstraints(postDateLabel.constraints)
        pageAction.removeConstraints(pageAction.constraints)
        postContentLabel.removeConstraints(postContentLabel.constraints)
        postScrollView.isUserInteractionEnabled = true
        
        let theAttributes:UICollectionViewLayoutAttributes! = gridCollectionView.layoutAttributesForItem(at: (gridCollectionView.indexPathsForSelectedItems?.first)!)
        cellFrameInSuperview  = gridCollectionView.convert(theAttributes.frame, to: scrollView.superview)
        
        self.postScrollView.frame = cellFrameInSuperview
        self.postScrollView.alpha = 1

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations:{
            gridCollectionView.alpha = 0.2
            self.postScrollView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: self.view.frame.height)

        }, completion: { (success) -> Void in
            
            gridCollectionView.alpha = 0.0
        })

        self.postScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        //dynamically set the size of the imageview to fit the aspect ratio
        var ratio: CGFloat!
        var imageHeight: CGFloat!
        
        if image!.size.width != 0{
            ratio = image!.size.width / image!.size.height
        } else {
            ratio = 0.0
        }
        
        if ratio != 0 {
            if (self.view.frame.width / ratio) > 500{
                imageHeight = 500
            } else {
                imageHeight = (self.view.frame.width / ratio)
            }
        } else {
            imageHeight = 0
        }
        

        
        let labelHeight = postContentLabel.heightForPostView(text: content, font: UIFont(name: "Avenir-Book", size: 14)!, width: self.view.frame.width-40)
        postImageView.image = image
        postScrollView.contentSize = CGSize(width: self.view.frame.width, height: imageHeight + labelHeight + 100)

        postScrollView.transform = CGAffineTransform(scaleX: 1, y: 1)
        postScrollView.addSubview(postImageView)
        
        postImageView.centerXAnchor.constraint(equalTo: postScrollView.centerXAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: postScrollView.topAnchor, constant: 10).isActive = true
        postImageView.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor, constant: 15).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: view.frame.width-30).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        let entry = entriesThisMonth[(gridCollectionView.indexPathsForSelectedItems?.first?.row)!]
        let entryIsFavorited = entry.value(forKey: "favorite") as! Bool
        
        if entryIsFavorited {
            postDateLabel.text = dateContent
            postScrollView.addSubview(postDateLabel)
            postDateLabel.centerXAnchor.constraint(equalTo: postScrollView.centerXAnchor).isActive = true
            postDateLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 15).isActive = true
            postDateLabel.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor, constant: 40).isActive = true
            postDateLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            postDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            postFavoriteImageView.image = UIImage(named: "star")?.withRenderingMode(.alwaysTemplate)
            postFavoriteImageView.tintColor = COLOR_TEXT
            postScrollView.addSubview(postFavoriteImageView)
            
            //postFavoriteImageView.centerXAnchor.constraint(equalTo: postScrollView.centerXAnchor).isActive = true
            postFavoriteImageView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 18).isActive = true
            postFavoriteImageView.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor, constant: 15).isActive = true
            postFavoriteImageView.widthAnchor.constraint(equalToConstant: 13).isActive = true
            postFavoriteImageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        } else {
            postDateLabel.text = dateContent
            postScrollView.addSubview(postDateLabel)
            postDateLabel.centerXAnchor.constraint(equalTo: postScrollView.centerXAnchor).isActive = true
            postDateLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 15).isActive = true
            postDateLabel.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor, constant: 15).isActive = true
            postDateLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
            postDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
    
        postContentLabel.text = content
        postScrollView.addSubview(postContentLabel)
        postContentLabel.centerXAnchor.constraint(equalTo: postScrollView.centerXAnchor).isActive = true
        postContentLabel.topAnchor.constraint(equalTo: postDateLabel.bottomAnchor, constant: 10).isActive = true
        postContentLabel.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor, constant: 15).isActive = true
        postContentLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        postContentLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        postScrollView.addSubview(pageAction)
        pageAction.centerXAnchor.constraint(equalTo: postScrollView.centerXAnchor).isActive = true
        pageAction.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 0).isActive = true
        pageAction.leadingAnchor.constraint(equalTo: postScrollView.leadingAnchor, constant: 15).isActive = true
        //pageAction.trailingAnchor.constraint(equalTo: postScrollView.trailingAnchor, constant: 15).isActive = true
        pageAction.widthAnchor.constraint(equalToConstant: view.frame.width-30).isActive = true
        pageAction.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func hideFullImage() {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.preferredFramesPerSecond30,.curveEaseInOut], animations:{
            gridCollectionView.alpha = 1
            self.postScrollView.frame = self.cellFrameInSuperview
            self.postScrollView.isUserInteractionEnabled = false
            self.postScrollView.alpha = 0
        }, completion: nil)
    }
    
}



extension MainFeed: UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance  {
    
    // MARK: - FSCalendar delegate
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return true
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        dateFindingformatter.dateFormat = "MMMM d"
        
        for row in 0..<entriesThisMonth.count{
            let entry = entriesThisMonth[row]
            let cellDate = entry.value(forKey: "date") as! Date?
            if dateFindingformatter.string(from: cellDate!) == dateFindingformatter.string(from: date) {
                return 1
            }
        }
        return 0
    }
    
    @objc func filterNextMonth(){
        impactFeedbackGenerator.medium.impactOccurred()
        DispatchQueue.main.async {
            self.dateFindingformatter.dateFormat = "MMMM yyyy"
            let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)

            
            self.filterEntries(date: (curr?.getNextMonth())!, direction: "forward")
            

        }
    }
    
    @objc func filterPrevMonth(){
        impactFeedbackGenerator.medium.impactOccurred()
        DispatchQueue.main.async {
            self.dateFindingformatter.dateFormat = "MMMM yyyy"
            let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)
            
            self.filterEntries(date: (curr?.getPreviousMonth())!, direction: "backward")
            
            
        }
    }
    
    @objc func filterAll(){
        impactFeedbackGenerator.medium.impactOccurred()

        self.scrollView.hideAllToasts()
        showingFavorites = false
        
        entriesThisMonth.removeAll()
        imagesThisMonth.removeAll()
    
        for row in 0..<entries.count{
            let entry = entries[row]
            
            entriesThisMonth.append(entry)
            
            if let image = entry.value(forKey: "image") {
                imagesThisMonth.append((image as! Data).toImage!)
            }else {
                imagesThisMonth.append(UIImage())
            }
            
        }
        
        self.view.makeToastActivity(CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2))
        
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations:{
                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width*0.8, y: 0), animated: true)
                
                self.headerView.menuBtn.isSelected = true
                self.headerView.monthLabel.text = "All Logs"
                self.headerView.menuBtn.setImage(UIImage(named: "viewall")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.headerView.menuBtn.tintColor = UIColor(rgb: 0x0076FF)
                self.headerView.yearLabel.text = ""
                let addImg = UIImage(named: "x-1")
                self.headerView.addBtn.setImage(addImg, for: .normal)
                
                gridCollectionView.alpha = 1
            }, completion: { (success) -> Void in
                gridCollectionView.reloadData()
                
                //let sortFunction = CorneredSortFunction(corner: .topLeft, interObjectDelay: 0.05)
                let rand = RandomSortFunction(interObjectDelay: 0.05)
                gridCollectionView.spruce.prepare(with: [.fadeIn, .expand(.slightly)])
                let animation = SpringAnimation(duration: 0.4)
                gridCollectionView.spruce.animate([.fadeIn, .expand(.slightly)], animationType: animation, sortFunction: rand)
                
                self.view.hideToastActivity()
                self.gradient.opacity = 0
            })
        }

    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let formatter = DateFormatter()
       
        formatter.dateFormat = "MMMM"
        
        print(formatter.string(from: calendar.currentPage))
        print(currentMonth)
        
        if formatter.string(from: calendar.currentPage) != currentMonth {
            filterEntries(date: calendar.currentPage, direction: "forward")

        }
        
    }
    
    func scrollToSelectedDate(cal: FSCalendar) {
        let dateToFind = cal.selectedDate
        
        for row in 0..<gridCollectionView.numberOfItems(inSection: 0) {
            let entry = entriesThisMonth[row]
            let cellDate = entry.value(forKey: "date") as! Date?
            
            if dateFindingformatter.string(from: cellDate!) == dateFindingformatter.string(from: dateToFind!) {
                gridCollectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: .centeredVertically, animated: true)
                
                let cell = gridCollectionView.cellForItem(at: IndexPath(row: row, section: 0))
//                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
//                    cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//                })
                
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.scrollView.hideAllToasts()

        if (calendar.cell(for: date, at: monthPosition)?.numberOfEvents)! >= 1 {
            scrollToSelectedDate(cal: calendar)

        }
        
//        let g1 = UIColor(rgb: 0x00E2E8).withAlphaComponent(1)
//        let g2 = UIColor(rgb: 0x4643FF).withAlphaComponent(1)
//        let g3 = UIColor(rgb: 0xFE09AD).withAlphaComponent(1)
//        let g4 = UIColor(rgb: 0xFFA415).withAlphaComponent(1)
        
        var style = ToastStyle()
        style.titleColor = COLOR_BG
        style.titleFont = UIFont(name: "Avenir-Black", size: 14)!
        style.messageColor = COLOR_BG
        style.messageFont = UIFont(name: "Avenir-Roman", size: 12)!
        style.backgroundColor = COLOR_TEXT.withAlphaComponent(0.9)
        style.cornerRadius = 5
        style.fadeDuration = 1
        style.messageAlignment = .center
        style.titleAlignment = .center
        style.horizontalPadding = 120
        style.verticalPadding = 5
        
        dateFindingformatter.dateFormat = "MMMM d yyyy"
        // toast presented with multiple options and with a completion closure
        self.scrollView.makeToast("tap to create", duration: 1, point: CGPoint(x: self.view.frame.width/2 + self.view.frame.width*0.8, y: self.view.frame.height - 140), title: dateFindingformatter.string(from: calendar.selectedDate!), image: nil, style: style) { didTap in
            if didTap {
                let vc = NewPost()
                vc.selectedDate = calendar.selectedDate!
                self.present(vc, animated: true) {
                }
            }
        }
    }
    
    
    

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let entry = entriesThisMonth[indexPath.row]
        var text = false
        var image = false
        
        if let imageData = entry.value(forKey: "image"){
            if (imageData as? Data != nil){
                image = true
                
                
//                let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
//                if let imgSrc = CGImageSourceCreateWithData(imageData as! CFData, options as CFDictionary) {
//                    let metadata = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary) as? [String : AnyObject]
//
//                    print(metadata)
//
//                    if let gpsData = metadata?[kCGImagePropertyGPSDictionary as String] {
//                        //do interesting stuff here
//                        print(gpsData)
//                    }
//                }
                
            }
        }
        if (entry.value(forKey: "content") as! String?) != ""{
            text = true
        }
        
        if text && image {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagetextcell", for: indexPath) as! ImageTextCell
            let content = entry.value(forKey: "content") as! String?
            
            if !DATE_ON_CARD {
                cell.dateLabel.textColor = COLOR_BG
            }else {
                cell.dateLabel.textColor = COLOR_TEXT.withAlphaComponent(0.5)
            }
            
            cell.dateLabel.text = cellFormatter.string(from: (entry.value(forKey: "date") as! Date?)!)
            cell.imageView.image = imagesThisMonth[indexPath.row]

            //set the content frame and text
            let labelHeight = cell.contentLabel.heightForCardView(text: content!, font: UIFont(name: "Avenir-Book", size: 11)!, width: 155)
            cell.contentLabel.frame = CGRect(x: 5, y: 120, width: 155, height: labelHeight)
            cell.contentLabel.text = content
            
            cell.contentLabel.textColor = COLOR_TEXT
            



            return cell
        } else if text {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textcell", for: indexPath) as! TextCell
            cell.dateLabel.text = cellFormatter.string(from: (entry.value(forKey: "date") as! Date?)!)
            let content = entry.value(forKey: "content") as! String?
            
            if !DATE_ON_CARD {
                cell.dateLabel.textColor = COLOR_BG
            }else {
                cell.dateLabel.textColor = COLOR_TEXT.withAlphaComponent(0.5)
            }
            
            //set the content frame and text
            let labelHeight = cell.contentLabel.heightForView(text: content!, font: UIFont(name: "Avenir-Book", size: 11)!, width: 155)
            cell.contentLabel.frame = CGRect(x: 2, y: 0, width: 155, height: labelHeight)
            cell.contentLabel.text = content
            
            cell.contentLabel.textColor = COLOR_TEXT


            
            return cell
        } else if image {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagecell", for: indexPath) as! ImageCell
            cell.dateLabel.text = cellFormatter.string(from: (entry.value(forKey: "date") as! Date?)!)
            cell.imageView.image = imagesThisMonth[indexPath.row]//(entry.value(forKey: "image") as! Data).toImage
 
            if !DATE_ON_CARD {
                cell.dateLabel.textColor = COLOR_BG
            } else {
                cell.dateLabel.textColor = COLOR_TEXT.withAlphaComponent(0.5)
            }
            
            return cell
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "imagetextcell", for: indexPath) as! ImageTextCell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x < self.view.frame.width*0.8 {
            let halfWidth = self.view.frame.width/2
            let alpha: CGFloat = (scrollView.contentOffset.x / halfWidth )
            let gradalpha: CGFloat = alpha * -1 + 1.2
            
            
            
            if alpha > 0 {
                gridCollectionView.alpha = CGFloat(alpha)+0.2
                
//                if headerView.yearLabel.alpha != 0 {
//                    menuVC.view.frame = CGRect(x: 0, y: self.view.frame.height - CGFloat(alpha*90), width: menuVC.view.frame.width, height: menuVC.view.frame.height)
//                }
                
                print(gradalpha)
                gradient.opacity = Float(gradalpha)
            }
        }
        
//        if scrollView.contentOffset.x > 25 && scrollView.panGestureRecognizer.isEnabled{
//            impactFeedbackGenerator.medium.impactOccurred()
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//            scrollView.panGestureRecognizer.isEnabled = false
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.dateFindingformatter.dateFormat = "MMMM yyyy"
//                let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)
//
//                self.filterEntries(date: (curr?.getNextMonth())!, direction: "forward")
//                scrollView.panGestureRecognizer.isEnabled = true
//
//            }
//
//        } else if scrollView.contentOffset.x < -25 && scrollView.panGestureRecognizer.isEnabled{
//            impactFeedbackGenerator.medium.impactOccurred()
//            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//            scrollView.panGestureRecognizer.isEnabled = false
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self.dateFindingformatter.dateFormat = "MMMM yyyy"
//                let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)
//
//                self.filterEntries(date: (curr?.getPreviousMonth())!, direction: "backward")
//                scrollView.panGestureRecognizer.isEnabled = true
//
//            }
//        }
//
        
//        switch scrollView.panGestureRecognizer.state {
//        case .began:
//            // User began dragging
//            //print("began")
//        case .changed:
//            // User is currently dragging the scroll view
//            //print("changed")
//        case .possible:
//            // The scroll view scrolling but the user is no longer touching the scrollview (table is decelerating)
//            //print("possible")
////            if willShowExtraInfo {
////                var style = ToastStyle()
////                style.titleColor = COLOR_TEXT
////                style.titleFont = UIFont(name: "Avenir-Black", size: 25)!
////                style.messageColor = COLOR_TEXT
////                style.messageFont = UIFont(name: "Avenir-Roman", size: 15)!
////                style.backgroundColor = COLOR_BG
////                style.cornerRadius = 5
////                style.fadeDuration = 1
////                style.messageAlignment = .center
////                style.titleAlignment = .center
////                style.imageSize = CGSize(width: 140, height: 60)
////                style.horizontalPadding = 150
////                
////                // toast presented with multiple options and with a completion closure
////                self.view.makeToast("\n\nMemories :  \(entriesThisMonth.count.description)\n\n Photos :  5\n\nWords :  1254\n\nFavorites :  2\n\n", duration: 2, point: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-385), title: "Info", image: nil, style: style) { didTap in
////                    if didTap {
////                        
////                    }
////                }
////            }
//        default:
//            break
//        }
        
//        if scrollView.contentOffset.y < -150 {
//
//            if !willShowExtraInfo{
//                impactFeedbackGenerator.medium.impactOccurred()
//                willShowExtraInfo = true
//                showInfoLabel.textColor = COLOR_TEXT
//            }
//        } else if scrollView.contentOffset.y > -150 && willShowExtraInfo{
//            willShowExtraInfo = false
//            showInfoLabel.textColor = COLOR_TEXT.withAlphaComponent(0.5)
//        }
//
//
//        if scrollView.contentOffset.y < 0 && willShowExtraInfo{
//            let scalefactor = (scrollView.contentOffset.y * -1) / 150
//            showInfoLabel.transform = CGAffineTransform(scaleX: scalefactor, y: scalefactor)
//        }
        
        if postScrollView.contentOffset.y < 0 && postScrollView.alpha == 1{
            let scalefactor = (scrollView.contentOffset.y * -1) / self.view.frame.height
            self.postScrollView.transform = CGAffineTransform(scaleX: 1 - scalefactor, y: 1 - scalefactor)
            
            print(scrollView.contentOffset.y)
            
            print(scalefactor)
        } else if postScrollView.alpha == 1{
            self.postScrollView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        
        
        
        
        if headerView != nil && scrollView.contentOffset.y > 50 {
            if !self.headerView.scrunched {
                if self.showingFavorites {
                    self.headerView.scrunchHeader(withFavorites: true)
                } else {
                    self.headerView.scrunchHeader(withFavorites: false)
                }
                self.headerView.scrunched = true
            }
        } else if headerView != nil && scrollView.contentOffset.y < 50{
            if self.headerView.scrunched {
                if self.showingFavorites {
                    self.headerView.unscrunchHeader(withFavorites: true)
                } else {
                    self.headerView.unscrunchHeader(withFavorites: false)
                }
                self.headerView.scrunched = false
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entriesThisMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
            cell?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        //cell?.contentView.backgroundColor = COLOR_TEXT.withAlphaComponent(0.05)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        //cell?.contentView.backgroundColor = COLOR_BG
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell = gridCollectionView.cellForItem(at: indexPath)  as? ImageTextCell
//        gridCollectionView.bringSubview(toFront: selectedCell!)
//
//        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
//            selectedCell?.transform = CGAffineTransform(scaleX: 2, y: 2)
//        })
        
        
        selectedIndexPath = indexPath
        
        print("did select")
        
        if self.childViewControllers.count >= 3 {
            self.menuAction()

        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell{
                if let image = cell.imageView.image {
                    DispatchQueue.main.async {
                        self.showFullImage(of: image,content: "", dateContent: cell.dateLabel.text!)
                    }
                } else {
                    print("no photo")
                }
            } else if let cell = collectionView.cellForItem(at: indexPath) as? ImageTextCell{
                if let image = cell.imageView.image {
                    DispatchQueue.main.async {
                        self.showFullImage(of: image,content: cell.contentLabel.text!, dateContent: cell.dateLabel.text!)
                    }
                } else {
                    print("no photo")
                }
            } else if let cell = collectionView.cellForItem(at: indexPath) as? TextCell{
                if let content = cell.contentLabel.text {
                    let image: UIImage = UIImage()
                    DispatchQueue.main.async {
                        self.showFullImage(of: image,content: content, dateContent: cell.dateLabel.text!)
                    }
                } else {
                    print("no content")
                }
            }
        }
    }
    
    @objc func scrollFromSettings(){
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func scrollToSettings(){
        self.scrollView.hideAllToasts()
        

        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations:{
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width*0.8, y: 0), animated: false)
        }, completion: { (success) -> Void in
            let preferencesPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Preferences") as! Preferences
            self.present(preferencesPage, animated: true) {
                
            }
        })

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        if kind == UICollectionElementKindSectionHeader {
            headerView = (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderView", for: indexPath) as! CollectionHeaderView)
            
            if showingFavorites{
                headerView.layer.cornerRadius = 1
                headerView.clipsToBounds = false
                //headerView.menuBtn.addTarget(self, action: #selector(createNewPost), for: .touchUpInside)
                headerView.monthLabel.text = "Favorites"
                headerView.monthLabel.backgroundColor = UIColor.clear
                headerView.monthLabel.layer.cornerRadius = 3
                headerView.monthLabel.clipsToBounds = true
                //headerView.yearLabel.text = entriesThisMonth.count.description
                headerView.yearLabel.backgroundColor = UIColor.clear
                headerView.yearLabel.layer.cornerRadius = 3
                headerView.yearLabel.clipsToBounds = true
                headerView.backgroundColor = UIColor.clear
            } else {
                headerView.layer.cornerRadius = 1
                headerView.clipsToBounds = false
                headerView.menuBtn.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
                headerView.monthLabel.backgroundColor = UIColor.clear
                headerView.monthLabel.layer.cornerRadius = 3
                headerView.monthLabel.clipsToBounds = true
                headerView.yearLabel.backgroundColor = UIColor.clear
                headerView.yearLabel.layer.cornerRadius = 3
                headerView.yearLabel.clipsToBounds = true
                //headerView.monthBtn.addTarget(self, action: #selector(filterFavorites), for: .allTouchEvents)
                headerView.backToTodayButton.addTarget(self, action: #selector(backToToday), for: .allTouchEvents)
                headerView.addBtn.addTarget(self, action: #selector(createNewPost), for: .allTouchEvents)
                headerView.backgroundColor = UIColor.clear
                headerView.preferencesBtn.addTarget(self, action: #selector(scrollToSettings), for: .touchUpInside)
                headerView.favoritesBtn.addTarget(self, action: #selector(filterFavorites), for: .touchUpInside)
                headerView.createTodayButton.addTarget(self, action: #selector(createNewPost), for: .touchUpInside)
                headerView.backgroundColor = UIColor.clear

            }

            return headerView
        }
        
        else if kind == UICollectionElementKindSectionFooter {
            footer = (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFooterView", for: indexPath) as! CollectionFooterView)
            
            footer.layer.cornerRadius = 1
            footer.clipsToBounds = false

            //headerView.addSubview(headerView.yearLabel)
            footer.backgroundColor = UIColor.clear
            
            return footer
        }
        return footer
    }
    
    @objc func backToToday(){
        self.showingFavorites = false

        
        for vc in self.childViewControllers{
            if vc.title == "menu" {
                (vc as? Calendar)?.calendar.setCurrentPage(Date(), animated: true)
            }
        }
        
        DispatchQueue.main.async {
            
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations:{
                self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width*0.8, y: 0), animated: true)
                
                self.headerView.menuBtn.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), for: .normal)
                self.headerView.menuBtn.tintColor = COLOR_TEXT
                gridCollectionView.alpha = 1
                self.gradient.opacity = 0


            }, completion: { (success) -> Void in
                self.filterEntries(date: Date(), direction: "forward")

            })
        }
    }
    
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == postScrollView {
            if scrollView.zoomScale > 1 {
                //postDetailsView.isHidden = true
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("did end scrolling animation")
        if scrollView.zoomScale == 1.0 {
            //postDetailsView.isHidden = false
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("did end zooming")
        
        if scrollView.zoomScale > 1{
            //scrollView.setZoomScale(1.0, animated: true)
            //postDetailsView.isHidden = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == postScrollView {
            //postDetailsView.isHidden = true
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == postScrollView {
            if scrollView.contentOffset.y < -50  /*|| scrollView.contentOffset.x < -50 ||  scrollView.contentOffset.x > 50*/ {
                hideFullImage()
            }
        }
    }
    
    // MARK: - Prefered
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
            return .default
        } else {
            return .lightContent
        }
        return statusbar
    }
}


extension UIImage {
//    var toData: Data? {
//        if let d = UIImageJPEGRepresentation(self, 0.7) { return  d }
//        return nil
//    }
    
    var toData: Data? {
        if let d = UIImagePNGRepresentation(self) { return  d }
        return nil
    }
}

extension Data {
    var toImage: UIImage? {
        if let d = UIImage(data: self) { return  d }
        return nil
    }
}

extension UILabel {
    
    func heightForPostView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 1000
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 14
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func heightForCardView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 6
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension UITextView {
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let tv:UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        tv.font = font
        tv.text = text
        tv.sizeToFit()
        
        return tv.frame.height
    }
}


extension Date {
    
    func getLast6Month() -> Date? {
        return NSCalendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    func getLast3Month() -> Date? {
        return NSCalendar.current.date(byAdding: .month, value: -3, to: self)
    }
    
    func getYesterday() -> Date? {
        return NSCalendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    func getLast7Day() -> Date? {
        return NSCalendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    func getLast30Day() -> Date? {
        return NSCalendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return NSCalendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    func getNextMonth() -> Date? {
        return NSCalendar.current.date(byAdding: .month, value: 1, to: self)
    }
    
    func getThisMonthStart() -> Date? {
        let components = NSCalendar.current.dateComponents([.year, .month], from: self)
        return NSCalendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = NSCalendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return NSCalendar.current.date(from: components as DateComponents)!
    }
    
    func getLastMonthStart() -> Date? {
        let components:NSDateComponents = NSCalendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return NSCalendar.current.date(from: components as DateComponents)!
    }
    
    func getLastMonthEnd() -> Date? {
        let components:NSDateComponents = NSCalendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return NSCalendar.current.date(from: components as DateComponents)!
    }
}


extension Notification.Name {
    static let reloadCoreData = Notification.Name("reloadCD")
    static let themeChanged = Notification.Name("themeChanged")
    static let scrollFromSettings = Notification.Name("scrollFromSettings")
}


extension UIScrollView {
    
    func snapshot() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(self.contentSize, true, 5)
        
        
        let savedContentOffset = self.contentOffset
        let savedFrame = self.frame
        
        self.contentOffset = CGPoint(x: 0, y: 5)
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        
        
        
        print(savedFrame)
        print(self.frame)
        
        print("yer 1")
        let context = UIGraphicsGetCurrentContext()!
        print("yer 2")
        self.layer.render(in: context)
        print("yer 3")
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.contentOffset = savedContentOffset
        self.frame = savedFrame
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
//    func screenshot() -> UIImage? {
//        let savedContentOffset = contentOffset
//        let savedFrame = frame
//
//        UIGraphicsBeginImageContext(contentSize)
//        contentOffset = .zero
//        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
//
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//
//        layer.render(in: context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext();
//
//        contentOffset = savedContentOffset
//        frame = savedFrame
//
//        return image
//    }
}








//        if showingFavorites{
//            showingFavorites = false
//            headerView.menuBtn.isSelected = false
//            filterEntries(date: Date(), direction: "forward")
//
//            headerView.hideFavorites()
//
//        }else if self.childViewControllers.count >= 1{
//            var vcToRemove : UIViewController!
//
//            for vc in self.childViewControllers{
//                if vc.title == "menu" {
//                    vcToRemove = vc
//                }
//            }
//
//            headerView.unhideMonth()
//            headerView.menuBtn.isSelected = false
//
//            self.scrollView.hideAllToasts()
//            if entriesThisMonth.count == 0 && scrollView.contentOffset.y == 0{
//                var style = ToastStyle()
//                style.titleColor = COLOR_TEXT
//                style.titleFont = UIFont(name: "Avenir-Black", size: 25)!
//                style.messageColor = COLOR_TEXT
//                style.messageFont = UIFont(name: "Avenir-Roman", size: 15)!
//                style.backgroundColor = UIColor.clear
//                style.cornerRadius = 5
//                style.fadeDuration = 1
//                style.messageAlignment = .center
//                style.titleAlignment = .center
//                style.imageSize = CGSize(width: 185, height: 158)
//                style.horizontalPadding = 0
//
//
//
//                if UserDefaults.standard.color(forKey: "COLOR_BG") == UIColor.white {
//                    // toast presented with multiple options and with a completion closure
//                    self.view.makeToast("", duration: 1000, point: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2), title: "", image: UIImage(named: "groupLight")!, style: style) { didTap in
//                        if didTap {
//                            self.headerView.menuBtn.isSelected = true
//                            self.menuAction()
//                        }
//                    }
//                } else {
//                    // toast presented with multiple options and with a completion closure
//                    self.view.makeToast("", duration: 1000, point: CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2), title: "", image: UIImage(named: "group")!, style: style) { didTap in
//                        if didTap {
//                            self.headerView.menuBtn.isSelected = true
//                            self.menuAction()
//                        }
//                    }
//                }
//            }
//
//
//            //animate view back down
//            UIView.animate(withDuration: 0.30, delay: 0, options: [.curveEaseInOut], animations:{
//                gridCollectionView.alpha = 1
//                //vcToRemove.view.frame = vcToRemove.view.frame.offsetBy(dx:  0, dy: 360)
//                vcToRemove.view.frame = vcToRemove.view.frame.offsetBy(dx:  0, dy: 290)
//
//            }, completion: { (success) -> Void in
//                //remove previous instance
//                vcToRemove.view.removeFromSuperview()
//                vcToRemove.removeFromParentViewController()
//                vcToRemove = nil
//                //self.scrollView.isScrollEnabled = true
//
//            })
//        } else {
//
//
//            menuVC.title = "menu"
//            self.addChildViewController(menuVC)
//            self.view.addSubview(menuVC.view)
//            menuVC.didMove(toParentViewController: self)
//            //menuVC.view.frame = CGRect(x: 10, y: self.view.frame.height, width: self.view.frame.width - 20, height: 360)
//            menuVC.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 290)
//
////            gridCollectionView.setContentOffset(CGPoint(x: 0, y: 60), animated: true)
////
////            self.headerView.scrunchHeader()
//            self.headerView.hideMonth()
//
//            self.scrollView.hideAllToasts()
//
//
//
//            dateFindingformatter.dateFormat = "MMMM yyyy"
//
//            menuVC.calendar.delegate = self
//            menuVC.calendar.dataSource = self
//            menuVC.calendar.setCurrentPage(self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)!, animated: true)
//
//
//            UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 7, initialSpringVelocity: 1.0, options: [], animations: {
//                gridCollectionView.alpha = 0.9
//                //menuVC.view.frame = menuVC.view.frame.offsetBy(dx:  0, dy: -360)
//                self.menuVC.view.frame = self.menuVC.view.frame.offsetBy(dx:  0, dy: -290)
//
//            }, completion: { (success) -> Void in
//
//                //self.scrollView.isScrollEnabled = false
//            })
//        }


//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//            if postScrollView.alpha == 0{
//                if !showingFavorites && self.childViewControllers.count < 2{
//                    switch swipeGesture.direction {
//                    case UISwipeGestureRecognizerDirection.left:
//                        print("Swiped right")
//                        impactFeedbackGenerator.medium.impactOccurred()
//
//                        DispatchQueue.main.async {
//                            self.dateFindingformatter.dateFormat = "MMMM yyyy"
//                            let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)
//
//                            self.filterEntries(date: (curr?.getNextMonth())!, direction: "forward")
//                        }
//
//                    case UISwipeGestureRecognizerDirection.down:
//                        print("Swiped down")
//                    case UISwipeGestureRecognizerDirection.right:
//                        print("Swiped left")
//
//                        impactFeedbackGenerator.medium.impactOccurred()
//
//                        DispatchQueue.main.async {
//                            self.dateFindingformatter.dateFormat = "MMMM yyyy"
//                            let curr = self.dateFindingformatter.date(from: self.currentMonth + " " + self.currentYear)
//
//                            self.filterEntries(date: (curr?.getPreviousMonth())!, direction: "backward")
//                        }
//
//                    case UISwipeGestureRecognizerDirection.up:
//                        print("Swiped up")
//                    default:
//                        break
//                    }
//                }
//            }
//        }
//    }

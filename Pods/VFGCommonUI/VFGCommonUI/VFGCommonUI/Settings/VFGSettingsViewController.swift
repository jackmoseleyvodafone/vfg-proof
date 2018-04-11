//
//  VFGSettingsViewController.swift
//  VFGCommonUI
//
//  Created by Ehab on 11/28/17.
//

import UIKit


public protocol SettingDelegate {
    func itemDidSelected(title: String)
    func userMsisdn() -> String
}

public protocol SettingDataSource {
    func sectionsDataSource() -> [VFGSettingsSection]
}

open class VFGSettingsViewController: UIViewController, VFGRootViewControllerContent {
    public var delegate : SettingDelegate?
    
    public var dataSource : SettingDataSource?
    
    var sections : [VFGSettingsSection] = [VFGSettingsSection]()
    
    @IBOutlet var tableView: UITableView!
    
    private let privacySettingsMsisdnUserdefaultsKey : String = "PrivacySettingsMsisdn"
    //MARK: - VFGRootViewControllerContent Protocol Variables
    
    public var rootViewControllerContentStatusBarState: VFGRootViewControllerStatusBarState {
        return .black
    }
    public var rootViewControllerContentTopBarTitle: String = ""
    
    public var rootViewControllerContentTopBarScrollDelegate: VFGTopBarScrollDelegate? = nil
    
    public var topBarRightButtonHidden: Bool = false
    
    @IBOutlet weak private var pagetitleLabel: UILabel!
    
    @IBOutlet weak private var labelTopConstraint: NSLayoutConstraint!
    
    static public func viewController() -> VFGSettingsViewController {
        return UIStoryboard(name: "VFGSettings", bundle: VFGCommonUIBundle.bundle()).instantiateInitialViewController() as! VFGSettingsViewController
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        let msisdn : String = self.delegate?.userMsisdn() ?? ""
        UserDefaults.standard.set(msisdn, forKey: self.privacySettingsMsisdnUserdefaultsKey)
        if let sectionsList : [VFGSettingsSection] = self.dataSource?.sectionsDataSource(){
            sections = sectionsList
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    /// Use to setup the view with the content of the model
    private func setupView(){
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        pagetitleLabel.applyStyle(VFGTextStyle.pageTitleColored(UIColor.VFGWhite))
        pagetitleLabel.text = "Settings"
        // Setting up the top margin and the chipped view
        labelTopConstraint.constant = VFGTopBar.topBarHeight
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: UITableViewDataSource
extension VFGSettingsViewController: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].subSection.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : VFGSettingsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCellID", for: indexPath) as! VFGSettingsTableViewCell
        cell.setup(title: self.sections[indexPath.section].subSection[indexPath.row].title, body: self.sections[indexPath.section].subSection[indexPath.row].body, isSwitchHidden: self.sections[indexPath.section].subSection[indexPath.row].isSwitchHidden)
        return cell
        
    }
    
}
extension VFGSettingsViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : VFGSettingsHeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "SettingHeaderTableViewCellID") as! VFGSettingsHeaderTableViewCell
        cell.setup(title: sections[section].title)
        return cell.contentView
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 71
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.itemDidSelected(title: self.sections[indexPath.section].subSection[indexPath.row].title)
    }
}


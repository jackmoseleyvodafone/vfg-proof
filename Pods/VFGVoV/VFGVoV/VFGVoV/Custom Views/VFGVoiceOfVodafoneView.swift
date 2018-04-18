//
//  VFGVoiceOfVodafoneView.swift
//  VFGVoV
//
//  Created by Mohamed Magdy on 5/23/17.
//  Copyright © 2017 Mohamed Magdy. All rights reserved.
//

import UIKit
import VFGCommonUI
import VFGCommonUtils
import VFGDataAccess

internal enum VovCellType : Int {
    case eventDriven = 0
    case campagin = 1
    case welcome = 2
}

fileprivate enum VFGVoiceOfVodafoneViewConstants : String {
    case welcomeMessageCellId = "VFGVovWelcomeMessageCollectionViewCellId"
    case welcomeMessageCellNibName = "VFGVovWelcomeMessageCollectionViewCell"
    case generalCellId = "VFGVovGeneralCollectionViewCellId"
    case generalCellNibName = "VFGVovGeneralCollectionViewCell"
}
let persistentMessagesKey = "persistentMessagesKey"
let pageControlInitialTranslation: CGFloat = -20.0
/*
 Voice of Vodafone View class
 */
public class VFGVoiceOfVodafoneView: VFGVoVBaseView {

    //***************************
    // MARK: Public properties
    //***************************
    /*
     @param dataSourceArray array of type VFGVovBaseModel
     */
    public var dataSourceArray : [VFGVovBaseModel]?
    /*
     @param heightConstraint it must be setted equal to height Constraint of vov container view in app
     */
    public var heightConstraint: NSLayoutConstraint?

    public var isWelcomeMessageAnimatedOnceBefore: Bool? = false

    /*
     @param delegate delegate of handling some operations
     */
    public weak var delegate : VFGVoiceOfVodafoneViewDelegate?
    /*
     @param shouldHideFirstMessage Bool, make it true if you are going to animate first cell
     */
    public var shouldHideFirstMessage : Bool = false

    //***************************
    // MARK: private properties
    //***************************
    fileprivate let deletedViewTag : Int = -2
    fileprivate var cellsHeight: [CGFloat]  = [CGFloat] ()
    fileprivate var maxMessagesNumber : Int = 0
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    fileprivate var collectionViewNumberOfItems : Int = 0
    fileprivate var welcomeMessageCell: VFGVovWelcomeMessageCollectionViewCell?
    fileprivate var deletedCellIndexPath : IndexPath?
    fileprivate var isCellBeforeWelcomeMessage : Bool = false
    @IBOutlet fileprivate weak var pageControl: UIPageControl!
    @IBOutlet fileprivate weak var collectionView: UICollectionView! {
        didSet {
            collectionView.isPagingEnabled = true
            collectionView.dataSource = self
            collectionView.alwaysBounceHorizontal = true
            pageControl?.numberOfPages = 0
        }
    }
    //**********************
    // MARK: Public Methods
    //**********************
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.loadFromNib()
        self.registerCollectionViewCells()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
        self.registerCollectionViewCells()
    }
    /*
     setup function is to load Vov settings
     @param dataArray: Array of VFGVovBaseModel, must have 1 or more of VFGVovBaseModel object to load Vov
     @param sender: VFGVoiceOfVodafoneViewDelegate, delegate
     @param animated: Bool, to handle scrolling to first item in collectionview animation
     */
    public func setup(dataArray dataModelArray: [VFGVovBaseModel],sender delegate : VFGVoiceOfVodafoneViewDelegate?, animated shouldAnimate: Bool) {
        
        self.superview?.layoutIfNeeded()
        self.restAlldata()
        
        self.dataSourceArray = dataModelArray
        self.delegate = delegate
        self.maxMessagesNumber = self.delegate?.maxNumberOfMessages?() ?? 6
        self.collectionViewNumberOfItems = self.numberOfMessages()
        placeWelcomeMessageInCorrectIndex(dataModelArray: dataModelArray)
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.reloadData()
        self.pageControl.currentPage = 0
        if self.collectionViewNumberOfItems > 1 {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .init(rawValue: 0), animated: shouldAnimate)
        }

        if let height : CGFloat = self.cellsHeight.first {
            self.resizeCurrentViewHeight(height: height)
        }

    }

    
    public func loadValidPersistentCampainMessages()-> [VovMessage]{

        var updatedMessages = [VovMessage]()
        // Load all vov messages from local storage
        if let savedData = UserDefaults.standard.object(forKey: persistentMessagesKey) as? Data {
            if let savedMessages = NSKeyedUnarchiver.unarchiveObject(with: savedData) as? [VovMessage] {
                for message: VovMessage in savedMessages {
             
                    if message.autoExpireAsInt! > 0 && message.dateReceived != nil && message.autoExpireAsInt != nil{
                        let expirationDate = message.dateReceived?.addingTimeInterval(TimeInterval(message.autoExpireAsInt! * 60))
                        if expirationDate! > Date() {
                            
                                updatedMessages.append(message)
                        
                        }
                        let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: updatedMessages)
                        UserDefaults.standard.set(updatedData, forKey: persistentMessagesKey)
                    }else if message.autoExpireAsInt! == -1  && message.autoExpireAsInt != nil{
    
                        updatedMessages.append(message)
                            let updatedData: Data = NSKeyedArchiver.archivedData(withRootObject: updatedMessages)
                            UserDefaults.standard.set(updatedData, forKey: persistentMessagesKey)
                        
                    }
                }
            }
        }
    
    
        return updatedMessages
    }

    /*
     get actual index of view in data source array by tag
     @param tag: Int, tag of view
     @return index of view in data source array if exist or 0 if not
     */
    public func getActualIndexOfView(tag: Int) -> Int {
        if let dataSource : [VFGVovBaseModel] = self.dataSourceArray {
            for (index, model) in dataSource.enumerated() {
                if let generalModel: VFGVovGeneralModel = model as? VFGVovGeneralModel, generalModel.messageId  == tag  {
                    return index
                }
            }
        }
        return 0
    }
    /*
     reload voice of vodafone data and views
     @param dataArray: Array of VFGVovBaseModel, must have 1 or more of VFGVovBaseModel object to load Vov
     */
    public func reloadData(dataSource : [VFGVovBaseModel]) {
        self.restAlldata()
        self.dataSourceArray = dataSource
        self.collectionView.reloadData()
    }

    public func updateVov(animated: Bool) {
        self.cellsHeight.removeAll()
        self.collectionViewNumberOfItems = self.numberOfMessages()
        self.pageControl.numberOfPages = self.collectionViewNumberOfItems
        if animated {
            self.collectionView.reloadSections(IndexSet(integersIn: 0...0))
        } else {
            UIView.performWithoutAnimation {
                self.collectionView.reloadSections(IndexSet(integersIn: 0...0))
            }
        }
        self.collectionView.isUserInteractionEnabled = true

    }
    /*
     delete Cell in voice of vodafone
     @param index: int, actual index of vov cell
     @param animated: Bool, should delete with animation
     */
    public func deleteCell(index item: Int, animated: Bool) {
        self.pageControl.alpha = 0
        animated == false ? self.deleteCellWithoutAnimation(item: item) :
            self.deleteCellWithAnimation(item: item)
    }
    /*
     Navigate to VoV message with selected index
     @param index: int, actual index of vov cell
     @param animated: Bool, should navigate with animation
     */
    public func displayVoVMessageWithIndex(_ index : Int, animated : Bool) {
        collectionView.scrollRectToVisible(CGRect(x: collectionView.frame.size.width * CGFloat(index) , y: collectionView.frame.origin.y, width: collectionView.frame.size.width, height: collectionView.frame.size.height), animated: animated)
    }

    public func animateNewCell(index : IndexPath) {

        if let cell : UICollectionViewCell = self.collectionView.cellForItem(at: index)  {
            self.heightConstraint?.constant = self.cellsHeight[index.row]
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()

            self.collectionView.alpha = 0.0
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)



            UIView.animate(withDuration: 0.6,
                           delay: 0.0,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
                            self.collectionView.alpha = 1.0
            }, completion: { (isFinised) in
                self.shouldHideFirstMessage = false
            })
        }
    }

    public func animateCellBeforeWelcomeMessage(index : Int) {
        self.collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {

            let indexPath : IndexPath = IndexPath.init(item: index, section: 0)
            if let cell : UICollectionViewCell = self.collectionView.cellForItem(at: indexPath)  {
                self.heightConstraint?.constant = self.cellsHeight[indexPath.row]
                self.superview?.layoutIfNeeded()
                cell.alpha = 1.0
                UIView.animate(withDuration: 0.6,
                               delay: 0.0,
                               usingSpringWithDamping: 13,
                               initialSpringVelocity: 1,
                               options: .curveEaseInOut,
                               animations: {
                                self.layoutIfNeeded()
                                cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                                cell.alpha = 0.0
                }, completion:{ (isFinished) in
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    cell.alpha = 1
                    self.animateNewCell(index: indexPath)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8, execute: {
                    cell.alpha = 1
                    self.updateVov(animated: false)
                })
            }
        })
    }

    public func animateFirstCell() {
        self.collectionView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            let indexPath : IndexPath = IndexPath(item: 0, section: 0)
            if let newCell : VFGCollectionViewCell = self.collectionView.cellForItem(at: indexPath) as? VFGVovGeneralCollectionViewCell,
                newCell.cellType != .welcome {
                self.animateNewCell(index: IndexPath(item: 0, section: 0))
                self.collectionView.alpha = 1
            }
        })
    }
    //**********************
    // MARK: Private Methods
    //**********************
    func updatePageControl() {
        for (index, dot) in pageControl.subviews.enumerated() {
            if index == pageControl.currentPage {
                dot.backgroundColor = .white
            } else {
                dot.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.4)
                dot.layer.cornerRadius = dot.frame.size.height / 2
                dot.layer.borderColor = UIColor.white.cgColor
                dot.layer.borderWidth = 1
            }
        }
    }
    private func placeWelcomeMessageInCorrectIndex(dataModelArray: [VFGVovBaseModel]){
    
        //To move this logic to a seperate function
        if dataModelArray.count > 1 && self.maxMessagesNumber > 1  {
            for item in dataModelArray {
                if item is VFGVovWelcomeMessage {
                    if dataModelArray.count < self.maxMessagesNumber {
                        
                        let maxIndex = dataModelArray.count - 2
                        dataSourceArray = Array(dataModelArray[0...maxIndex])
                        dataSourceArray?.append(item)
                    }
                    else{
                        let maxIndex = self.maxMessagesNumber - 2
                        dataSourceArray = Array(dataModelArray[0...maxIndex])
                        dataSourceArray?.append(item)
                    }
                }
            }
        }
        else{
            //show only welcome
            for i in 0..<dataModelArray.count {
                if (dataModelArray[i] is VFGVovWelcomeMessage) {
                    dataSourceArray = Array(dataSourceArray![i...i])
                }
            }
        }
    }
    @IBAction fileprivate func pageControlValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        self.updatePageControl()
        self.displayVoVMessageWithIndex(currentPage, animated: true)
    }

    fileprivate func initializeCompletion() {
            //PageControl Animation
            self.pageControl.transform = CGAffineTransform(translationX: 0.0, y: pageControlInitialTranslation)
            UIView.animate(withDuration: generalAnimationDuration, animations: {
                self.pageControl.transform = CGAffineTransform.identity
            })
    
        //Welcome Cell components animation
        welcomeMessageCell!.startAnimation()
    }
    private func registerCollectionViewCells() {

        // welcome message
        self.collectionView.register(UINib(nibName: VFGVoiceOfVodafoneViewConstants.welcomeMessageCellNibName.rawValue, bundle: VFGVoVBundle.bundle()), forCellWithReuseIdentifier: VFGVoiceOfVodafoneViewConstants.welcomeMessageCellId.rawValue)

        // general cell
        self.collectionView.register(UINib(nibName: VFGVoiceOfVodafoneViewConstants.generalCellNibName.rawValue, bundle: VFGVoVBundle.bundle()), forCellWithReuseIdentifier: VFGVoiceOfVodafoneViewConstants.generalCellId.rawValue)

    }

    fileprivate func numberOfMessages() -> Int {
        if let dataSource: [VFGVovBaseModel] = self.dataSourceArray {
            if self.maxMessagesNumber < dataSource.count {
                return self.maxMessagesNumber
            }
            return dataSource.count
        }
        return 0
    }

    fileprivate func shiftRightView(view : UIView) {
        var frame : CGRect = view.frame
        frame.origin.x -= UIScreen.main.bounds.size.width
        view.frame = frame
    }

    fileprivate func resizeCurrentViewHeight(height : CGFloat) {
        self.heightConstraint?.constant = height
        self.layoutIfNeeded()
        self.superview?.layoutIfNeeded()
    }

    private func restAlldata(){
        self.cellsHeight.removeAll()
        self.dataSourceArray?.removeAll()
    }

    private func deleteCellWithoutAnimation(item index: Int) {
        deletedCellIndexPath  = IndexPath(item: index, section: 0)

        if index + 1 < self.cellsHeight.count {
            self.resizeCurrentViewHeight(height: self.cellsHeight[index + 1])
        }
        if let dataArray : [VFGVovBaseModel] = self.dataSourceArray ,
            let deleteIndexPath : IndexPath = deletedCellIndexPath,
            index < dataArray.count{

            self.cellsHeight.removeAll()

            self.dataSourceArray?.remove(at: index)
            if (self.dataSourceArray?[index] as? VFGVovGeneralModel)?.piriorty == .eventDriven {
                (self.dataSourceArray?[index] as? VFGVovGeneralModel)?.isViewed = true
            }
            self.collectionViewNumberOfItems -= 1
            UIView.performWithoutAnimation({
                self.collectionView.deleteItems(at: [deleteIndexPath])
            })
        }
    }

    private func deleteCellWithAnimation(item index: Int){

        deletedCellIndexPath  = IndexPath(item: index, section: 0)

        /*
         delete should be excusted if
         - there's next cell
         - deletedCellIndexPath is not nil
         */

        if index + 1 < self.cellsHeight.count ,
            let deleteIndexPath : IndexPath = deletedCellIndexPath,
            let cell : VFGCollectionViewCell = self.collectionView.cellForItem(at: deleteIndexPath) as? VFGCollectionViewCell ,
            let nextCell : VFGCollectionViewCell = self.collectionView.cellForItem(at: IndexPath(item: index + 1, section: 0)) as? VFGCollectionViewCell {

            (nextCell as? VFGVovGeneralCollectionViewCell)?.rightButton?.isUserInteractionEnabled = false
            (nextCell as? VFGVovGeneralCollectionViewCell)?.leftButton?.isUserInteractionEnabled = false
            var frame : CGRect = cell.frame

            frame.size = nextCell.frame.size

            frame.origin.y = 0

            nextCell.frame.origin.y = 0

            self.heightConstraint?.constant = self.cellsHeight[index + 1]
            self.superview?.layoutIfNeeded()

            UIView.animate(withDuration: 0.33, animations: {

                cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                cell.alpha = 0.0

            }, completion: {
                (isFinised) in
                self.cellsHeight.removeAll()

                self.dataSourceArray?.remove(at: index )

                cell.alpha = 0

                self.collectionViewNumberOfItems -= 1

                UIView.performWithoutAnimation({
                    self.collectionView.deleteItems(at: [deleteIndexPath])
                })
            })

            UIView.animate(withDuration: 0.57,
                           delay: 0.1,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.18,
                           options: .curveEaseInOut,
                           animations: {
                            nextCell.frame = frame
            }, completion:{ (isFinished) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    (cell as? VFGVovGeneralCollectionViewCell)?.rightButton?.isUserInteractionEnabled = true
                    (cell as? VFGVovGeneralCollectionViewCell)?.leftButton?.isUserInteractionEnabled = true
                    (nextCell as? VFGVovGeneralCollectionViewCell)?.leftButton?.isUserInteractionEnabled = true
                    (nextCell as? VFGVovGeneralCollectionViewCell)?.rightButton?.isUserInteractionEnabled = true
                })
            })
        }
        else{
            VFGLogger.log("Wrong cell index")
        }
    }
}

// MARK: - UICollection View Data Source
extension VFGVoiceOfVodafoneView : UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        self.pageControl.numberOfPages = self.collectionViewNumberOfItems
        self.pageControl.alpha = 1
        self.updatePageControl()

        return self.collectionViewNumberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell : UICollectionViewCell = UICollectionViewCell()

        if let dataModelArray : [AnyObject] = self.dataSourceArray {

            // welcome message
            if let vovModel :VFGVovWelcomeMessage =  dataModelArray[indexPath.item] as? VFGVovWelcomeMessage  , let welcomeMessageCollectionViewCell : VFGVovWelcomeMessageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: VFGVoiceOfVodafoneViewConstants.welcomeMessageCellId.rawValue, for: indexPath) as? VFGVovWelcomeMessageCollectionViewCell {
                welcomeMessageCollectionViewCell.updateModel(model: vovModel)
                welcomeMessageCollectionViewCell.layoutIfNeeded()
                cell = welcomeMessageCollectionViewCell
            }
                // general messages
            else if let vovModel :VFGVovGeneralModel =  dataModelArray[indexPath.item] as? VFGVovGeneralModel, let generalCollectionViewCell : VFGVovGeneralCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: VFGVoiceOfVodafoneViewConstants.generalCellId.rawValue, for: indexPath) as? VFGVovGeneralCollectionViewCell  {
                generalCollectionViewCell.updateModel(model: vovModel)
                generalCollectionViewCell.delegate = self
                generalCollectionViewCell.layoutIfNeeded()

                cell = generalCollectionViewCell

                if shouldHideFirstMessage, indexPath.item == 0 {
                    cell.alpha = 0
                } else if isCellBeforeWelcomeMessage {
                    cell.alpha = 0
                }
                self.isCellBeforeWelcomeMessage = false
                self.shouldHideFirstMessage = false
            }
        }
        return cell
    }
}

// MARK: - UICollection View Delegate Flow Layout
extension VFGVoiceOfVodafoneView : UICollectionViewDelegateFlowLayout  {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var voVViewExpectedHeight : CGFloat = 115

        var extraConstant : CGFloat = 0
        if UIScreen.isIpad {
            voVViewExpectedHeight  = 120
            extraConstant = 30
        }

        if self.dataSourceArray?.count == 1 {
            extraConstant = 0
        }

        if let dataModelArray : [AnyObject] = self.dataSourceArray {
            if let _ :VFGVovWelcomeMessage =  dataModelArray[indexPath.item] as? VFGVovWelcomeMessage  {
                self.cellsHeight.append(voVViewExpectedHeight + self.collectionViewBottomConstraint.constant)
                return CGSize(width: collectionView.frame.size.width, height: voVViewExpectedHeight)
            }
            else if let vovModel :VFGVovGeneralModel =  dataModelArray[indexPath.item] as? VFGVovGeneralModel{
                let cell : VFGVoVGeneralCell = VFGVoVGeneralCell(model: vovModel)
                self.cellsHeight.append(cell.bounds.size.height + self.collectionViewBottomConstraint.constant + extraConstant )
                return CGSize(width: collectionView.frame.size.width - 1
                    , height: cell.bounds.size.height + extraConstant )
            }
        }
        return self.collectionView.bounds.size
    }
}

// MARK: - UICollection View Delegate
extension VFGVoiceOfVodafoneView : UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 1
        if isCellBeforeWelcomeMessage {
            cell.alpha = 0
            isCellBeforeWelcomeMessage = false
            self.animateNewCell(index: indexPath)
        }
        else if let newCell : VFGCollectionViewCell = cell as? VFGVovGeneralCollectionViewCell,
            newCell.cellType == .eventDriven, indexPath.item == 0 {
            cell.alpha = 1
            (self.dataSourceArray?[indexPath.item] as? VFGVovGeneralModel)?.isViewed = true
        }
        else if let newCell : VFGVovWelcomeMessageCollectionViewCell = cell as? VFGVovWelcomeMessageCollectionViewCell,
            newCell.cellType == .welcome, indexPath.item == 0, isWelcomeMessageAnimatedOnceBefore ?? false == false {
            self.isWelcomeMessageAnimatedOnceBefore = true
            newCell.contentView.alpha = 0
            newCell.verticalSeparator.alpha = 0.0
            newCell.greetingLabel.alpha = 0.0
            newCell.marketNameLabel.alpha = 0.0

            welcomeMessageCell = newCell
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                self.startVoiceOfVodafoneAnimationForView(newCell.contentView)
            })

            DispatchQueue.main.asyncAfter(deadline: .now()+0.5+0.6, execute: {
                self.initializeCompletion()
            })
        }
    }
}

// MARK: - UIScrollView Delegate
extension VFGVoiceOfVodafoneView : UIScrollViewDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.pageControl.alpha = 0
        })
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.pageControl.alpha = 1
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x.truncatingRemainder(dividingBy: self.frame.size.width)

        if self.cellsHeight.count > 0, offset > 0 , offset <= self.bounds.width   {
            let pageIndex = round(scrollView.contentOffset.x/self.frame.width)
            pageControl.currentPage = Int(pageIndex)
            self.updatePageControl()



            var curentCellNumber = Int(self.collectionView.contentOffset.x / self.frame.size.width) < 0 ? Int(self.collectionView.contentOffset.x / self.frame.size.width) * -1 : Int(self.collectionView.contentOffset.x / self.frame.size.width)

            var expectedCellNumber = curentCellNumber

            if curentCellNumber < self.cellsHeight.count - 1 {
                expectedCellNumber += 1
            }
            if self.cellsHeight.count == 1 {
                expectedCellNumber = 0
                curentCellNumber = 0
            }

            var expectedHeight: CGFloat = self.cellsHeight[expectedCellNumber]
            var currentHeight = self.cellsHeight[curentCellNumber]
            var extraHeight = expectedHeight - currentHeight
            var heightDifference = offset / (self.collectionView.frame.size.width / extraHeight )

            if scrollView.panGestureRecognizer.translation(in: scrollView).x * -1 <= 0 {

                expectedHeight = self.cellsHeight[curentCellNumber]
                currentHeight = self.cellsHeight[expectedCellNumber]
                extraHeight = expectedHeight - currentHeight
                heightDifference = (self.collectionView.frame.size.width - offset) / (self.collectionView.frame.size.width / extraHeight)
            }
            if (self.dataSourceArray?[curentCellNumber] as? VFGVovGeneralModel)?.piriorty == .eventDriven {
                print (curentCellNumber)
                (self.dataSourceArray?[curentCellNumber] as? VFGVovGeneralModel)?.isViewed = true
            }
            resizeCurrentViewHeight(height: currentHeight + heightDifference )
        }
    }
}

extension VFGVoiceOfVodafoneView : VFGVoVGeneralCellDelegate {

    /*
     left button did Selected in voice of vodafone cell
     @param index: int, actual index of vov cell
     */
    public func leftButtonDidSelected(_ index: Int) {
        let actualIndex : Int = getActualIndexOfView(tag: index)
        self.delegate?.leftButtonDidSelected?(actualIndex)
    }

    /*
     right button did Selected in voice of vodafone cell
     @param index: int, actual index of vov cell
     */
    public func rightButtonDidSelected(_ index: Int) {
        let actualIndex : Int = getActualIndexOfView(tag: index)
        self.delegate?.rightButtonDidSelected?(actualIndex)
    }
}

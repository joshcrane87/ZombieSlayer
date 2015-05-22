//
//  InAppPurchaseUtilities.swift
//  CircleJump
//
//  Created by Josh Crane on 5/22/15
//

import Foundation
import StoreKit
private let _sharedInAppUtils = InAppUtils()
let IAUtilsProductPurchasedNotification:NSString = "IAUtilsProductPurchasedNotification"
let IAUtilsFailedProductPurchasedNotification:NSString = "IAUtilsFailedProductPurchasedNotification"
class InAppUtils : NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    var _transactionGoing:Bool!
    //MARK:- Initialization -
    class var sharedInAppUtils : InAppUtils{
        return _sharedInAppUtils
    }
    override init() {
        super.init()
        _transactionGoing = false
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    //MARK:- Requests -
    func removeAds(inAppID:NSString) {
        if (!_transactionGoing) {
            var request = SKProductsRequest(productIdentifiers: NSSet(object: inAppID) as Set<NSObject>)
            request.delegate = self
            request.start()
            _transactionGoing = true
        }
    }
    func restorePurchase() {
        if (!_transactionGoing) {
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            _transactionGoing = true
        }
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        var myProduct = response.products as NSArray
        if (myProduct.count > 0) {
            if (SKPaymentQueue.canMakePayments()) {
                var newPayment = SKPayment(product: myProduct.objectAtIndex(0) as! SKProduct)
                SKPaymentQueue.defaultQueue().addPayment(newPayment)
            }
            else {
                var alertView = UIAlertView(title: "Your Device is Limited", message: "We have noticed that you device restrictions setting are currently limited. you can change it by going to Settings -> General -> Restrictions and turn it off", delegate: nil, cancelButtonTitle: "Ok")
                alertView.show()
            }
        }
        else {
            var alertView = UIAlertView(title: "Notification", message: "In app purchases comming soon!", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
        }
    }
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions{
            
            let skTransaction:SKPaymentTransaction = transaction as! SKPaymentTransaction
            switch (skTransaction.transactionState) {
            case SKPaymentTransactionState.Purchased:
                self.completeTransaction(skTransaction)
            case SKPaymentTransactionState.Failed:
                self.failedTransaction(skTransaction)
            case SKPaymentTransactionState.Restored:
                self.restoreTransaction(skTransaction)
            default:
                break
            }
        }
    }
    func paymentQueue(queue: SKPaymentQueue!, restoreCompletedTransactionsFailedWithError error: NSError!) {
        _transactionGoing = false
        NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
    }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        if (queue.transactions.count > 0) {
            return
        }
        else {
            var alertView = UIAlertView(title: "Notification", message: "There are no previous purchases to be restored!", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
            NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
            _transactionGoing = false
        }
    }
    //MARK:- Transaction State Handlers -
    func completeTransaction(transaction:SKPaymentTransaction){
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        _transactionGoing = false
        NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsProductPurchasedNotification as String, object: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isPurchased")
    }
    func restoreTransaction(transaction:SKPaymentTransaction){
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        _transactionGoing = false
        NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsProductPurchasedNotification as String, object: nil)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isPurchased")
    }
    func failedTransaction(transaction:SKPaymentTransaction){
        if (transaction.error.code != SKErrorPaymentCancelled) {
            var alertView = UIAlertView(title: "Purchase Unsuccessful", message: "Your purchase failed. Please try again", delegate: nil, cancelButtonTitle: "Ok")
            alertView.show()
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        _transactionGoing = false
        NSNotificationCenter.defaultCenter().postNotificationName(IAUtilsFailedProductPurchasedNotification as String, object: nil)
    }
}
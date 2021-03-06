//
//  PhotoAlbumViewController+CoreDataExtension.swift
//  VirtualTourist
//
//  Created by felix on 8/21/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData



extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.performBatchUpdates({
            print("performBatchUpdates")
            self.blockOperations.forEach { $0.start() }
            }, completion: { finished in
                self.blockOperations.removeAll(keepCapacity: false)
        })
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        blockOperations.removeAll(keepCapacity: false)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
            
        case .Insert:
            guard let newIndexPath = newIndexPath else { return }
            let op = NSBlockOperation { [weak self] in self?.collectionView.insertItemsAtIndexPaths([newIndexPath]) }
            blockOperations.append(op)
            
        case .Update:
            guard let newIndexPath = newIndexPath else { return }
            let op = NSBlockOperation { [weak self] in self?.collectionView.reloadItemsAtIndexPaths([newIndexPath]) }
            blockOperations.append(op)
            
        case .Move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            let op = NSBlockOperation { [weak self] in self?.collectionView.moveItemAtIndexPath(indexPath, toIndexPath: newIndexPath) }
            blockOperations.append(op)
            
        case .Delete:
            guard let indexPath = indexPath else { return }
            let op = NSBlockOperation { [weak self] in self?.collectionView.deleteItemsAtIndexPaths([indexPath]) }
            blockOperations.append(op)
            
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
            
        case .Insert:
            let op = NSBlockOperation { [weak self] in self?.collectionView.insertSections(NSIndexSet(index: sectionIndex)) }
            blockOperations.append(op)
            
        case .Update:
            let op = NSBlockOperation { [weak self] in self?.collectionView.reloadSections(NSIndexSet(index: sectionIndex)) }
            blockOperations.append(op)
            
        case .Delete:
            let op = NSBlockOperation { [weak self] in self?.collectionView.deleteSections(NSIndexSet(index: sectionIndex)) }
            blockOperations.append(op)
            
        default: break
            
        }
    }
}
 
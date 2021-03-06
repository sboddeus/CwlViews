//
//  CwlTableView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/27.
//  Copyright © 2017 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose with or without
//  fee is hereby granted, provided that the above copyright notice and this permission notice
//  appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
//  SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
//  AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
//  NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
//  OF THIS SOFTWARE.
//

#if os(iOS)

// MARK: - Binder Part 1: Binder
public class TableView<RowData>: Binder, TableViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableView {
	enum Binding: TableViewBinding {
		public typealias RowDataType = RowData
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case tableViewStyle(Constant<UITableView.Style>)

		//	1. Value bindings may be applied at construction and may subsequently change.
		case allowsMultipleSelection(Dynamic<Bool>)
		case allowsMultipleSelectionDuringEditing(Dynamic<Bool>)
		case allowsSelection(Dynamic<Bool>)
		case allowsSelectionDuringEditing(Dynamic<Bool>)
		case backgroundView(Dynamic<ViewConvertible?>)
		case cellLayoutMarginsFollowReadableWidth(Dynamic<Bool>)
		case estimatedRowHeight(Dynamic<CGFloat>)
		case estimatedSectionFooterHeight(Dynamic<CGFloat>)
		case estimatedSectionHeaderHeight(Dynamic<CGFloat>)
		case isEditing(Signal<SetOrAnimate<Bool>>)
		case remembersLastFocusedIndexPath(Dynamic<Bool>)
		case rowHeight(Dynamic<CGFloat>)
		case sectionFooterHeight(Dynamic<CGFloat>)
		case sectionHeaderHeight(Dynamic<CGFloat>)
		case sectionIndexBackgroundColor(Dynamic<UIColor?>)
		case sectionIndexColor(Dynamic<UIColor?>)
		case sectionIndexMinimumDisplayRowCount(Dynamic<Int>)
		case sectionIndexTitles(Dynamic<[String]?>)
		case sectionIndexTrackingBackgroundColor(Dynamic<UIColor?>)
		case separatorColor(Dynamic<UIColor?>)
		case separatorEffect(Dynamic<UIVisualEffect?>)
		case separatorInset(Dynamic<UIEdgeInsets>)
		case separatorInsetReference(Dynamic<UITableView.SeparatorInsetReference>)
		case separatorStyle(Dynamic<UITableViewCell.SeparatorStyle>)
		case tableData(Dynamic<TableSectionAnimatable<RowData>>)
		case tableFooterView(Dynamic<ViewConvertible?>)
		case tableHeaderView(Dynamic<ViewConvertible?>)
		
		//	2. Signal bindings are performed on the object after construction.
		case deselectRow(Signal<SetOrAnimate<IndexPath>>)
		case scrollToNearestSelectedRow(Signal<SetOrAnimate<UITableView.ScrollPosition>>)
		case scrollToRow(Signal<SetOrAnimate<TableScrollPosition>>)
		case selectRow(Signal<SetOrAnimate<TableScrollPosition?>>)
		
		//	3. Action bindings are triggered by the object after construction.
		case selectionDidChange(SignalInput<[TableRow<RowData>]?>)
		case userDidScrollToRow(SignalInput<TableRow<RowData>>)
		case visibleRowsChanged(SignalInput<[TableRow<RowData>]>)
		
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case accessoryButtonTapped((UITableView, TableRow<RowData>) -> Void)
		case canEditRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Bool)
		case canFocusRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Bool)
		case canMoveRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Bool)
		case canPerformAction((_ tableView: UITableView, _ action: Selector, _ tableRowData: TableRow<RowData>, _ sender: Any?) -> Bool)
		case cellConstructor((_ identifier: String?, _ rowSignal: SignalMulti<RowData>) -> TableViewCellConvertible)
		case cellIdentifier((TableRow<RowData>) -> String?)
		case commit((UITableView, UITableViewCell.EditingStyle, TableRow<RowData>) -> Void)
		case dataMissingCell((IndexPath) -> TableViewCellConvertible)
		case didDeselectRow((UITableView, TableRow<RowData>) -> Void)
		case didEndDisplayingCell((UITableView, UITableViewCell, TableRow<RowData>) -> Void)
		case didEndDisplayingFooter((UITableView, UIView, Int) -> Void)
		case didEndDisplayingHeader((UITableView, UIView, Int) -> Void)
		case didEndEditingRow((UITableView, TableRow<RowData>?) -> Void)
		case didHightlightRow((UITableView, TableRow<RowData>) -> Void)
		case didSelectRow((UITableView, TableRow<RowData>) -> Void)
		case didUnhighlightRow((UITableView, TableRow<RowData>) -> Void)
		case didUpdateFocus((UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void)
		case editActionsForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> [UITableViewRowAction]?)
		case editingStyleForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> UITableViewCell.EditingStyle)
		case estimatedHeightForFooter((_ tableView: UITableView, _ section: Int) -> CGFloat)
		case estimatedHeightForHeader((_ tableView: UITableView, _ section: Int) -> CGFloat)
		case estimatedHeightForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> CGFloat)
		case footerHeight((_ tableView: UITableView, _ section: Int) -> CGFloat)
		case footerView((_ tableView: UITableView, _ section: Int, _ title: String?) -> ViewConvertible?)
		case headerHeight((_ tableView: UITableView, _ section: Int) -> CGFloat)
		case headerView((_ tableView: UITableView, _ section: Int, _ title: String?) -> ViewConvertible?)
		case heightForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> CGFloat)
		case indentationLevelForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Int)
		case indexPathForPreferredFocusedView((UITableView) -> IndexPath)
		case moveRow((UITableView, TableRow<RowData>, IndexPath) -> Void)
		case shouldHighlightRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Bool)
		case shouldIndentWhileEditingRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Bool)
		case shouldShowMenuForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Bool)
		case shouldUpdateFocus((UITableView, UITableViewFocusUpdateContext) -> Bool)
		case targetIndexPathForMoveFromRow((_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath)
		case titleForDeleteConfirmationButtonForRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> String?)
		case willBeginEditingRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> Void)
		case willDeselectRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> IndexPath?)
		case willDisplayFooter((_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void)
		case willDisplayHeader((_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void)
		case willDisplayRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>, _ cell: UITableViewCell) -> Void)
		case willSelectRow((_ tableView: UITableView, _ tableRowData: TableRow<RowData>) -> IndexPath?)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TableView.Binding
		public typealias Inherited = ScrollView.Preparer
		public typealias Instance = UITableView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage(rowsChanged: rowsChanged, cellIdentifier: cellIdentifier) }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}

		var cellIdentifier: (TableRow<RowData>) -> String? = { _ in nil }
		var rowsChanged: MultiOutput<[TableRow<RowData>]>? = nil
		var tableViewStyle: UITableView.Style = .plain
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableView.Preparer {
	var delegateIsRequired: Bool { return true }
	
	func constructInstance(type: Instance.Type, parameters: Parameters) -> Instance {
		return type.init(frame: CGRect.zero, style: tableViewStyle)
	}
	
	private static func tableRowData(at indexPath: IndexPath, in tableView: UITableView) -> TableRow<RowData> {
		return TableRow<RowData>(indexPath: indexPath, data: (tableView.delegate as? TableView<RowData>.Preparer.Storage)?.sections.values?.at(indexPath.section)?.values?.at(indexPath.row))
	}
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)

		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .tableViewStyle(let x): tableViewStyle = x.value
			
		//	1. Value bindings may be applied at construction and may subsequently change.
		
		//	2. Signal bindings are performed on the object after construction.
		
		//	3. Action bindings are triggered by the object after construction.
		case .userDidScrollToRow(let x):
			delegate().addMultiHandler1(
				{ (sv: UIScrollView) -> Void in
					guard let tableView = sv as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.first else { return }
					_ = x.send(value: TableView.Preparer.tableRowData(at: topVisibleRow, in: tableView))
				},
				#selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:))
			)
			delegate().addMultiHandler2(
				{ (sv: UIScrollView, d: Bool) -> Void in
					guard !d, let tableView = sv as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.first else { return }
					_ = x.send(value: TableView.Preparer.tableRowData(at: topVisibleRow, in: tableView))
				},
				#selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:))
			)
			delegate().addMultiHandler1(
				{ (sv: UIScrollView) -> Void in
					guard let tableView = sv as? UITableView, let topVisibleRow = tableView.indexPathsForVisibleRows?.first else { return }
					_ = x.send(value: TableView.Preparer.tableRowData(at: topVisibleRow, in: tableView))
				},
				#selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:))
			)
		case .visibleRowsChanged(let x):
			rowsChanged = rowsChanged ?? Input().multicast()
			rowsChanged?.signal.bind(to: x)
			delegate().addMultiHandler3(
				{ (tv: UITableView, _: IndexPath, _: UITableViewCell) -> Void in
					_ = (tv.delegate as? Storage)?.notifyVisibleRowsChanged(in: tv)
				},
				#selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))
			)
			delegate().addMultiHandler3(
				{ (tv: UITableView, _: IndexPath, _: UITableViewCell) -> Void in
					_ = (tv.delegate as? Storage)?.notifyVisibleRowsChanged(in: tv)
				},
				#selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:))
			)
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .accessoryButtonTapped(let x): delegate().addMultiHandler2(x, #selector(UITableViewDelegate.tableView(_:accessoryButtonTappedForRowWith:)))
		case .commit(let x): delegate().addMultiHandler3(x, #selector(UITableViewDataSource.tableView(_:commit:forRowAt:)))
		case .didDeselectRow(let x): delegate().addMultiHandler2(x, #selector(UITableViewDelegate.tableView(_:didDeselectRowAt:)))
		case .didEndDisplayingFooter(let x): delegate().addMultiHandler3(x, #selector(UITableViewDelegate.tableView(_:didEndDisplayingFooterView:forSection:)))
		case .didEndDisplayingHeader(let x): delegate().addMultiHandler3(x, #selector(UITableViewDelegate.tableView(_:didEndDisplayingHeaderView:forSection:)))
		case .didEndDisplayingCell(let x): delegate().addMultiHandler3(x, #selector(UITableViewDelegate.tableView(_:didEndDisplaying:forRowAt:)))
		case .didEndEditingRow(let x): delegate().addMultiHandler2(x, #selector(UITableViewDelegate.tableView(_:didEndEditingRowAt:)))
		case .didHightlightRow(let x): delegate().addMultiHandler2(x, #selector(UITableViewDelegate.tableView(_:didHighlightRowAt:)))
		case .didSelectRow(let x): delegate().addMultiHandler2(x, #selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
		case .didUnhighlightRow(let x): delegate().addMultiHandler2(x, #selector(UITableViewDelegate.tableView(_:didUnhighlightRowAt:)))
		case .moveRow(let x): delegate().addMultiHandler3(x, #selector(UITableViewDataSource.tableView(_:moveRowAt:to:)))
		case .canEditRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDataSource.tableView(_:canEditRowAt:)))
		case .canFocusRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:canFocusRowAt:)))
		case .canMoveRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDataSource.tableView(_:canMoveRowAt:)))
		case .canPerformAction(let x): delegate().addSingleHandler4(x, #selector(UITableViewDelegate.tableView(_:canPerformAction:forRowAt:withSender:)))
		case .cellIdentifier(let x): cellIdentifier = x
		case .didUpdateFocus(let x): delegate().addMultiHandler3(x, #selector(UITableViewDelegate.tableView(_:didUpdateFocusIn:with:)))
		case .editActionsForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:editActionsForRowAt:)))
		case .editingStyleForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:editingStyleForRowAt:)))
		case .estimatedHeightForFooter(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:estimatedHeightForFooterInSection:)))
		case .estimatedHeightForHeader(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:estimatedHeightForHeaderInSection:)))
		case .estimatedHeightForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:estimatedHeightForRowAt:)))
		case .footerHeight(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:)))
		case .footerView(let x): delegate().addSingleHandler3(x, #selector(UITableViewDelegate.tableView(_:viewForFooterInSection:)))
		case .headerHeight(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:)))
		case .headerView(let x): delegate().addSingleHandler3(x, #selector(UITableViewDelegate.tableView(_:viewForHeaderInSection:)))
		case .heightForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:heightForRowAt:)))
		case .indentationLevelForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:indentationLevelForRowAt:)))
		case .indexPathForPreferredFocusedView(let x): delegate().addSingleHandler1(x, #selector(UITableViewDelegate.indexPathForPreferredFocusedView(in:)))
		case .shouldHighlightRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:shouldHighlightRowAt:)))
		case .shouldIndentWhileEditingRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:shouldIndentWhileEditingRowAt:)))
		case .shouldShowMenuForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:shouldShowMenuForRowAt:)))
		case .shouldUpdateFocus(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:shouldUpdateFocusIn:)))
		case .targetIndexPathForMoveFromRow(let x): delegate().addSingleHandler3(x, #selector(UITableViewDelegate.tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:)))
		case .titleForDeleteConfirmationButtonForRow(let x): delegate().addSingleHandler2(x, #selector(UITableViewDelegate.tableView(_:titleForDeleteConfirmationButtonForRowAt:)))
		default: break
		}
	}
	
	func prepareInstance(_ instance: Instance, storage: Storage) {
		inheritedPrepareInstance(instance, storage: storage)

		prepareDelegate(instance: instance, storage: storage)
		instance.dataSource = storage
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .tableViewStyle: return nil
		
		case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
		case .allowsMultipleSelectionDuringEditing(let x): return x.apply(instance) { i, v in i.allowsMultipleSelectionDuringEditing = v }
		case .allowsSelection(let x): return x.apply(instance) { i, v in i.allowsSelection = v }
		case .allowsSelectionDuringEditing(let x): return x.apply(instance) { i, v in i.allowsSelectionDuringEditing = v }
		case .backgroundView(let x): return x.apply(instance) { i, v in i.backgroundView = v?.uiView() }
		case .cellLayoutMarginsFollowReadableWidth(let x): return x.apply(instance) { i, v in i.cellLayoutMarginsFollowReadableWidth = v }
		case .isEditing(let x): return x.apply(instance) { i, v in i.setEditing(v.value, animated: v.isAnimated) }
		case .estimatedRowHeight(let x): return x.apply(instance) { i, v in i.estimatedRowHeight = v }
		case .estimatedSectionFooterHeight(let x): return x.apply(instance) { i, v in i.estimatedSectionFooterHeight = v }
		case .estimatedSectionHeaderHeight(let x): return x.apply(instance) { i, v in i.estimatedSectionHeaderHeight = v }
		case .remembersLastFocusedIndexPath(let x): return x.apply(instance) { i, v in i.remembersLastFocusedIndexPath = v }
		case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
		case .sectionFooterHeight(let x): return x.apply(instance) { i, v in i.sectionFooterHeight = v }
		case .sectionHeaderHeight(let x): return x.apply(instance) { i, v in i.sectionHeaderHeight = v }
		case .sectionIndexBackgroundColor(let x): return x.apply(instance) { i, v in i.sectionIndexBackgroundColor = v }
		case .sectionIndexColor(let x): return x.apply(instance) { i, v in i.sectionIndexColor = v }
		case .sectionIndexMinimumDisplayRowCount(let x): return x.apply(instance) { i, v in i.sectionIndexMinimumDisplayRowCount = v }
		case .sectionIndexTrackingBackgroundColor(let x): return x.apply(instance) { i, v in i.sectionIndexTrackingBackgroundColor = v }
		case .separatorColor(let x): return x.apply(instance) { i, v in i.separatorColor = v }
		case .separatorEffect(let x): return x.apply(instance) { i, v in i.separatorEffect = v }
		case .separatorInset(let x): return x.apply(instance) { i, v in i.separatorInset = v }
		case .separatorInsetReference(let x): return x.apply(instance) { i, v in i.separatorInsetReference = v }
		case .separatorStyle(let x): return x.apply(instance) { i, v in i.separatorStyle = v }
		case .tableFooterView(let x): return x.apply(instance) { i, v	in i.tableFooterView = v?.uiView() }
		case .tableHeaderView(let x): return x.apply(instance) { i, v in i.tableHeaderView = v?.uiView() }
		
		//	2. Signal bindings are performed on the object after construction.
		case .deselectRow(let x): return x.apply(instance) { i, v in i.deselectRow(at: v.value, animated: v.isAnimated) }
		case .scrollToNearestSelectedRow(let x): return x.apply(instance) { i, v in i.scrollToNearestSelectedRow(at: v.value, animated: v.isAnimated) }
		case .scrollToRow(let x):
			// You can't scroll a table view until *after* the number of sections and rows has been read from the data source.
			// This occurs on didAddToWindow but the easiest way to track it is by waiting for the contentSize to be set (which is set for the first time immediately after the row count is read). This makes assumptions about internal logic of UITableView – if this logic changes in future, scrolls set on load might be lost (not a catastrophic problem).
			// Capture the scroll signal to stall it
			let capture = x.capture()
			
			// Create a signal pair that will join the capture to the destination *after* the first `contentSize` change is observed
			let pair = Signal<SetOrAnimate<TableScrollPosition>>.create()
			var kvo: NSKeyValueObservation? = instance.observe(\.contentSize) { (i, change) in
				_ = try? capture.bind(to: pair.input, resend: .all)
			}
			
			// Use the output of the pair to apply the effects as normal
			return pair.signal.apply(instance) { i, v in
				// Remove the key value observing after the first value is received.
				if let k = kvo {
					k.invalidate()
					kvo = nil
				}
				
				// Clamp to the number of actual sections and rows
				var indexPath = v.value.indexPath
				if indexPath.section >= i.numberOfSections {
					indexPath.section = i.numberOfSections - 1
				}
				if indexPath.section < 0 {
					return
				}
				if indexPath.row >= i.numberOfRows(inSection: indexPath.section) {
					indexPath.row = i.numberOfRows(inSection: indexPath.section) - 1
				}
				if indexPath.row < 0 {
					return
				}
				
				// Finally, perform the scroll
				i.scrollToRow(at: indexPath, at: v.value.position, animated: v.isAnimated)
			}
		case .selectRow(let x):
			return x.apply(instance) { i, v in
				i.selectRow(at: v.value?.indexPath, animated: v.isAnimated, scrollPosition: v.value?.position ?? .none)
			}
			
		//	3. Action bindings are triggered by the object after construction.
		case .accessoryButtonTapped: return nil
		case .commit: return nil
		case .didDeselectRow: return nil
		case .didEndDisplayingFooter: return nil
		case .didEndDisplayingHeader: return nil
		case .didEndDisplayingCell: return nil
		case .didEndEditingRow: return nil
		case .didHightlightRow: return nil
		case .didSelectRow: return nil
		case .didUnhighlightRow: return nil
		case .moveRow: return nil
		case .selectionDidChange(let x):
			return Signal.notifications(name: UITableView.selectionDidChangeNotification, object: instance).map { n -> ([TableRow<RowData>])? in
				if let tableView = n.object as? UITableView, let selection = tableView.indexPathsForSelectedRows {
					if let sections = (tableView.delegate as? Storage)?.sections.values {
						return selection.compactMap { indexPath in
							return TableRow<RowData>(indexPath: indexPath, data: sections.at(indexPath.section)?.values?.at(indexPath.row))
						}
					} else {
						return selection.map { indexPath in TableRow<RowData>(indexPath: indexPath, data: nil) }
					}
				} else {
					return nil
				}
			}.cancellableBind(to: x)
		case .userDidScrollToRow: return nil
		case .visibleRowsChanged: return nil
			
		//	4. Delegate bindings require synchronous evaluation within the object's context.
		case .canEditRow: return nil
		case .canFocusRow: return nil
		case .canMoveRow: return nil
		case .canPerformAction: return nil
		case .cellConstructor(let x):
			storage.cellConstructor = x
			return nil
		case .cellIdentifier: return nil
		case .dataMissingCell(let x):
			storage.dataMissingCell = x
			return nil
		case .didUpdateFocus: return nil
		case .editActionsForRow: return nil
		case .editingStyleForRow: return nil
		case .estimatedHeightForFooter: return nil
		case .estimatedHeightForHeader: return nil
		case .estimatedHeightForRow: return nil
		case .footerHeight: return nil
		case .footerView: return nil
		case .headerHeight: return nil
		case .headerView: return nil
		case .heightForRow: return nil
		case .indentationLevelForRow: return nil
		case .indexPathForPreferredFocusedView: return nil
		case .sectionIndexTitles(let x):
			return x.apply(instance, storage) { i, s, v in
				s.indexTitles = v
				i.reloadSectionIndexTitles()
			}
		case .shouldHighlightRow: return nil
		case .shouldIndentWhileEditingRow: return nil
		case .shouldShowMenuForRow: return nil
		case .shouldUpdateFocus: return nil
		case .tableData(let x): return x.apply(instance, storage) { i, s, v in s.applySectionAnimation(v, to: i) }
		case .targetIndexPathForMoveFromRow: return nil
		case .titleForDeleteConfirmationButtonForRow: return nil
		case .willBeginEditingRow: return nil
		case .willDeselectRow: return nil
		case .willDisplayFooter: return nil
		case .willDisplayHeader: return nil
		case .willDisplayRow: return nil
		case .willSelectRow: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableView.Preparer {
	open class Storage: ScrollView.Preparer.Storage, UITableViewDelegate, UITableViewDataSource {
		open override var isInUse: Bool { return true }
		
		open var sections = TableSectionState<RowData>()
		open var indexTitles: [String]? = nil
		open var scrollJunction: (SignalCapture<SetOrAnimate<(IndexPath, UITableView.ScrollPosition)>>, SignalInput<SetOrAnimate<(IndexPath, UITableView.ScrollPosition)>>)? = nil
		open var cellIdentifier: (TableRow<RowData>) -> String?
		open var cellConstructor: ((_ identifier: String?, _ rowSignal: SignalMulti<RowData>) -> TableViewCellConvertible)?
		open var dataMissingCell: (IndexPath) -> TableViewCellConvertible = { _ in return TableViewCell() }
		public let rowsChanged: MultiOutput<[TableRow<RowData>]>?
		
		public init(rowsChanged: MultiOutput<[TableRow<RowData>]>?, cellIdentifier: @escaping (TableRow<RowData>) -> String?) {
			self.rowsChanged = rowsChanged
			self.cellIdentifier = cellIdentifier
			super.init()
		}
		
		open func numberOfSections(in tableView: UITableView) -> Int {
			return sections.globalCount
		}
		
		open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			return sections.values?.at(section)?.globalCount ?? 0
		}
		
		open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let data = sections.values?.at(indexPath.section).flatMap { section in section.values?.at(indexPath.row - section.localOffset) }
			let identifier = cellIdentifier(TableRow(indexPath: indexPath, data: data))
			
			let cellView: UITableViewCell
			let cellInput: SignalInput<RowData>?
			if let i = identifier, let reusedView = tableView.dequeueReusableCell(withIdentifier: i) {
				cellView = reusedView
				cellInput = reusedView.associatedRowInput(valueType: RowData.self)
			} else if let cc = cellConstructor {
				let dataTuple = Input<RowData>().multicast()
				let constructed = cc(identifier, dataTuple.signal).uiTableViewCell(reuseIdentifier: identifier)
				cellView = constructed
				cellInput = dataTuple.input
				constructed.setAssociatedRowInput(to: dataTuple.input)
			} else {
				return dataMissingCell(indexPath).uiTableViewCell(reuseIdentifier: nil)
			}
			
			if let d = data {
				_ = cellInput?.send(value: d)
			}
			
			return cellView
		}
		
		open func tableView(_ tableView: UITableView, titleForHeaderInSection: Int) -> String? {
			return sections.values?.at(titleForHeaderInSection)?.leaf?.header
		}
		
		open func tableView(_ tableView: UITableView, titleForFooterInSection: Int) -> String? {
			return sections.values?.at(titleForFooterInSection)?.leaf?.footer
		}
		
		open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
			return indexTitles
		}
		
		open func notifyVisibleRowsChanged(in tableView: UITableView) {
			guard let rowsChanged = rowsChanged else { return }
			DispatchQueue.main.async { [rowsChanged] in
				if let indexPaths = tableView.indexPathsForVisibleRows, indexPaths.count > 0 {
					rowsChanged.input.send(value: indexPaths.map { indexPath in TableRow<RowData>(indexPath: indexPath, data: self.sections.values?.at(indexPath.section)?.values?.at(indexPath.row)) })
				} else {
					rowsChanged.input.send(value: [])
				}
			}
		}
		
		open func applySectionAnimation(_ sectionAnimatable: TableSectionAnimatable<RowData>, to i: UITableView) {
			let sectionMutation = sectionAnimatable.value
			
			if case .update = sectionMutation.kind {
				for (mutationIndex, rowIndex) in sectionMutation.indexSet.enumerated() {
					sectionMutation.values[mutationIndex].mapMetadata { _ in () }.apply(to: &sections.values![rowIndex].values!)
					sectionMutation.values[mutationIndex].updateMetadata(&sections.values![rowIndex])
				}
			} else {
				sectionMutation.mapValues { rowMutation -> TableRowState<RowData> in
					var rowState = TableRowState<RowData>()
					rowMutation.apply(toSubrange: &rowState)
					return rowState
				}.apply(toSubrange: &sections)
			}
			sectionMutation.updateMetadata(&sections)
			
			let animation = sectionAnimatable.animation ?? .none
			switch sectionMutation.kind {
			case .delete:
				i.deleteSections(sectionMutation.indexSet.offset(by: sections.localOffset), with: animation)
			case .move(let destination):
				i.performBatchUpdates({
					for (count, index) in sectionMutation.indexSet.offset(by: sections.localOffset).enumerated() {
						i.moveSection(index, toSection: destination + count)
					}
				}, completion: nil)
			case .insert:
				i.insertSections(sectionMutation.indexSet.offset(by: sections.localOffset), with: animation)
			case .scroll:
				i.reloadSections(sectionMutation.indexSet.offset(by: sections.localOffset), with: animation)
			case .update:
				i.performBatchUpdates({
					for (sectionIndex, change) in zip(sectionMutation.indexSet.offset(by: sections.localOffset), sectionMutation.values) {
						if change.metadata?.leaf != nil {
							i.reloadSections([sectionIndex], with: animation)
						} else {
							let indexPaths = change.indexSet.map { rowIndex in IndexPath(row: rowIndex, section: sectionIndex) }
							switch change.kind {
							case .delete: i.deleteRows(at: indexPaths, with: animation)
							case .move(let destination):
								for (count, index) in indexPaths.enumerated() {
									i.moveRow(at: index, to: IndexPath(row: destination + count, section: sectionIndex))
								}
							case .insert: i.insertRows(at: indexPaths, with: animation)
							case .scroll:
								i.reloadRows(at: indexPaths, with: animation)
							case .update:
								guard let section = sections.values?.at(sectionIndex - sections.localOffset) else { continue }
								for indexPath in indexPaths {
									guard let cell = i.cellForRow(at: indexPath), let value = section.values?.at(indexPath.row - sections.localOffset) else { continue }
									cell.associatedRowInput(valueType: RowData.self)?.send(value: value)
								}
								notifyVisibleRowsChanged(in: i)
							case .reload:
								i.reloadSections([sectionIndex], with: animation)
							}
						}
					}
				}, completion: nil)
			case .reload:
				i.reloadData()
			}

		}
	}

	open class Delegate: ScrollView.Preparer.Delegate, UITableViewDataSource, UITableViewDelegate {
		private func tableRowData(at indexPath: IndexPath, in tableView: UITableView) -> TableRow<RowData> {
			return TableRow<RowData>(indexPath: indexPath, data: (tableView.delegate as? TableView<RowData>.Preparer.Storage)?.sections.values?.at(indexPath.section)?.values?.at(indexPath.row))
		}
		
		private func metadata(section: Int, in tableView: UITableView) -> TableSectionMetadata? {
			return (tableView.delegate as? TableView<RowData>.Preparer.Storage)?.sections.values?.at(section)?.leaf
		}
		
		open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			// This is a required method of UITableViewDataSource but is implemented by the storage
			return 0
		}
		
		open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			// This is a required method of UITableViewDelegate but is implemented by the storage
			return UITableViewCell()
		}
		
		open func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
			multiHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
			return singleHandler(tableView, action, tableRowData(at: indexPath, in: tableView), sender)
		}
		
		open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
			multiHandler(tableView, view, section)
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
			multiHandler(tableView, view, section)
		}
		
		open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
			multiHandler(tableView, cell, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
			multiHandler(tableView, indexPath.map { tableRowData(at: $0, in: tableView) })
		}
		
		open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
			multiHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			multiHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
			multiHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
			return singleHandler(tableView, context, coordinator)
		}
		
		open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
			return singleHandler(tableView, section)
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
			return singleHandler(tableView, section)
		}
		
		open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
			return singleHandler(tableView, section)
		}
		
		open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
			return (singleHandler(tableView, section, metadata(section: section, in: tableView)?.footer) as ViewConvertible?)?.uiView()
		}
		
		open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
			return singleHandler(tableView, section)
		}
		
		open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
			return (singleHandler(tableView, section, metadata(section: section, in: tableView)?.header) as ViewConvertible?)?.uiView()
		}
		
		open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
			return singleHandler(tableView)
		}
		
		open func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
			multiHandler(tableView, tableRowData(at: sourceIndexPath, in: tableView), destinationIndexPath)
		}
		
		open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
			return singleHandler(tableView, context)
		}
		
		open func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
			return singleHandler(tableView, sourceIndexPath, proposedDestinationIndexPath)
		}
		
		open func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
			multiHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
			multiHandler(tableView, section, view)
		}
		
		open func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
			multiHandler(tableView, section, view)
		}
		
		open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
			multiHandler(tableView, indexPath, cell)
		}
		
		open func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
			return singleHandler(tableView, tableRowData(at: indexPath, in: tableView))
		}
		
		open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
			multiHandler(tableView, editingStyle, tableRowData(at: indexPath, in: tableView))
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: TableViewBinding {
	public typealias TableViewName<V> = BindingName<V, TableView<Binding.RowDataType>.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> TableView<Binding.RowDataType>.Binding) -> TableViewName<V> {
		return TableViewName<V>(source: source, downcast: Binding.tableViewBinding)
	}
}
public extension BindingName where Binding: TableViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: TableViewName<$2> { return .name(TableView.Binding.$1) }
	
	//	0. Static bindings are applied at construction and are subsequently immutable.
	static var tableViewStyle: TableViewName<Constant<UITableView.Style>> { return .name(TableView.Binding.tableViewStyle) }
	
	//	1. Value bindings may be applied at construction and may subsequently change.
	static var allowsMultipleSelection: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsMultipleSelection) }
	static var allowsMultipleSelectionDuringEditing: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsMultipleSelectionDuringEditing) }
	static var allowsSelection: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsSelection) }
	static var allowsSelectionDuringEditing: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsSelectionDuringEditing) }
	static var backgroundView: TableViewName<Dynamic<ViewConvertible?>> { return .name(TableView.Binding.backgroundView) }
	static var cellLayoutMarginsFollowReadableWidth: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.cellLayoutMarginsFollowReadableWidth) }
	static var estimatedRowHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.estimatedRowHeight) }
	static var estimatedSectionFooterHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.estimatedSectionFooterHeight) }
	static var estimatedSectionHeaderHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.estimatedSectionHeaderHeight) }
	static var isEditing: TableViewName<Signal<SetOrAnimate<Bool>>> { return .name(TableView.Binding.isEditing) }
	static var remembersLastFocusedIndexPath: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.remembersLastFocusedIndexPath) }
	static var rowHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.rowHeight) }
	static var sectionFooterHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.sectionFooterHeight) }
	static var sectionHeaderHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.sectionHeaderHeight) }
	static var sectionIndexBackgroundColor: TableViewName<Dynamic<UIColor?>> { return .name(TableView.Binding.sectionIndexBackgroundColor) }
	static var sectionIndexColor: TableViewName<Dynamic<UIColor?>> { return .name(TableView.Binding.sectionIndexColor) }
	static var sectionIndexMinimumDisplayRowCount: TableViewName<Dynamic<Int>> { return .name(TableView.Binding.sectionIndexMinimumDisplayRowCount) }
	static var sectionIndexTitles: TableViewName<Dynamic<[String]?>> { return .name(TableView.Binding.sectionIndexTitles) }
	static var sectionIndexTrackingBackgroundColor: TableViewName<Dynamic<UIColor?>> { return .name(TableView.Binding.sectionIndexTrackingBackgroundColor) }
	static var separatorColor: TableViewName<Dynamic<UIColor?>> { return .name(TableView.Binding.separatorColor) }
	static var separatorEffect: TableViewName<Dynamic<UIVisualEffect?>> { return .name(TableView.Binding.separatorEffect) }
	static var separatorInset: TableViewName<Dynamic<UIEdgeInsets>> { return .name(TableView.Binding.separatorInset) }
	static var separatorInsetReference: TableViewName<Dynamic<UITableView.SeparatorInsetReference>> { return .name(TableView.Binding.separatorInsetReference) }
	static var separatorStyle: TableViewName<Dynamic<UITableViewCell.SeparatorStyle>> { return .name(TableView.Binding.separatorStyle) }
	static var tableData: TableViewName<Dynamic<TableSectionAnimatable<Binding.RowDataType>>> { return .name(TableView.Binding.tableData) }
	static var tableFooterView: TableViewName<Dynamic<ViewConvertible?>> { return .name(TableView.Binding.tableFooterView) }
	static var tableHeaderView: TableViewName<Dynamic<ViewConvertible?>> { return .name(TableView.Binding.tableHeaderView) }
	
	//	2. Signal bindings are performed on the object after construction.
	static var deselectRow: TableViewName<Signal<SetOrAnimate<IndexPath>>> { return .name(TableView.Binding.deselectRow) }
	static var scrollToNearestSelectedRow: TableViewName<Signal<SetOrAnimate<UITableView.ScrollPosition>>> { return .name(TableView.Binding.scrollToNearestSelectedRow) }
	static var scrollToRow: TableViewName<Signal<SetOrAnimate<TableScrollPosition>>> { return .name(TableView.Binding.scrollToRow) }
	static var selectRow: TableViewName<Signal<SetOrAnimate<TableScrollPosition?>>> { return .name(TableView.Binding.selectRow) }
	
	//	3. Action bindings are triggered by the object after construction.
	static var selectionDidChange: TableViewName<SignalInput<[TableRow<Binding.RowDataType>]?>> { return .name(TableView.Binding.selectionDidChange) }
	static var userDidScrollToRow: TableViewName<SignalInput<TableRow<Binding.RowDataType>>> { return .name(TableView.Binding.userDidScrollToRow) }
	static var visibleRowsChanged: TableViewName<SignalInput<[TableRow<Binding.RowDataType>]>> { return .name(TableView.Binding.visibleRowsChanged) }
	
	//	4. Delegate bindings require synchronous evaluation within the object's context.
	static var accessoryButtonTapped: TableViewName<(UITableView, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.accessoryButtonTapped) }
	static var canEditRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(TableView.Binding.canEditRow) }
	static var canFocusRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(TableView.Binding.canFocusRow) }
	static var canMoveRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(TableView.Binding.canMoveRow) }
	static var canPerformAction: TableViewName<(_ tableView: UITableView, _ action: Selector, _ tableRowData: TableRow<Binding.RowDataType>, _ sender: Any?) -> Bool> { return .name(TableView.Binding.canPerformAction) }
	static var cellConstructor: TableViewName<(_ identifier: String?, _ rowSignal: SignalMulti<Binding.RowDataType>) -> TableViewCellConvertible> { return .name(TableView.Binding.cellConstructor) }
	static var cellIdentifier: TableViewName<(TableRow<Binding.RowDataType>) -> String?> { return .name(TableView.Binding.cellIdentifier) }
	static var commit: TableViewName<(UITableView, UITableViewCell.EditingStyle, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.commit) }
	static var dataMissingCell: TableViewName<(IndexPath) -> TableViewCellConvertible> { return .name(TableView.Binding.dataMissingCell) }
	static var didDeselectRow: TableViewName<(UITableView, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.didDeselectRow) }
	static var didEndDisplayingCell: TableViewName<(UITableView, UITableViewCell, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.didEndDisplayingCell) }
	static var didEndDisplayingFooter: TableViewName<(UITableView, UIView, Int) -> Void> { return .name(TableView.Binding.didEndDisplayingFooter) }
	static var didEndDisplayingHeader: TableViewName<(UITableView, UIView, Int) -> Void> { return .name(TableView.Binding.didEndDisplayingHeader) }
	static var didEndEditingRow: TableViewName<(UITableView, TableRow<Binding.RowDataType>?) -> Void> { return .name(TableView.Binding.didEndEditingRow) }
	static var didHightlightRow: TableViewName<(UITableView, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.didHightlightRow) }
	static var didSelectRow: TableViewName<(UITableView, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.didSelectRow) }
	static var didUnhighlightRow: TableViewName<(UITableView, TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.didUnhighlightRow) }
	static var didUpdateFocus: TableViewName<(UITableView, UITableViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void> { return .name(TableView.Binding.didUpdateFocus) }
	static var editActionsForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> [UITableViewRowAction]?> { return .name(TableView.Binding.editActionsForRow) }
	static var editingStyleForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> UITableViewCell.EditingStyle> { return .name(TableView.Binding.editingStyleForRow) }
	static var estimatedHeightForFooter: TableViewName<(_ tableView: UITableView, _ section: Int) -> CGFloat> { return .name(TableView.Binding.estimatedHeightForFooter) }
	static var estimatedHeightForHeader: TableViewName<(_ tableView: UITableView, _ section: Int) -> CGFloat> { return .name(TableView.Binding.estimatedHeightForHeader) }
	static var estimatedHeightForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat> { return .name(TableView.Binding.estimatedHeightForRow) }
	static var footerHeight: TableViewName<(_ tableView: UITableView, _ section: Int) -> CGFloat> { return .name(TableView.Binding.footerHeight) }
	static var footerView: TableViewName<(_ tableView: UITableView, _ section: Int, _ title: String?) -> ViewConvertible?> { return .name(TableView.Binding.footerView) }
	static var headerHeight: TableViewName<(_ tableView: UITableView, _ section: Int) -> CGFloat> { return .name(TableView.Binding.headerHeight) }
	static var headerView: TableViewName<(_ tableView: UITableView, _ section: Int, _ title: String?) -> ViewConvertible?> { return .name(TableView.Binding.headerView) }
	static var heightForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> CGFloat> { return .name(TableView.Binding.heightForRow) }
	static var indentationLevelForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Int> { return .name(TableView.Binding.indentationLevelForRow) }
	static var indexPathForPreferredFocusedView: TableViewName<(UITableView) -> IndexPath> { return .name(TableView.Binding.indexPathForPreferredFocusedView) }
	static var moveRow: TableViewName<(UITableView, TableRow<Binding.RowDataType>, IndexPath) -> Void> { return .name(TableView.Binding.moveRow) }
	static var shouldHighlightRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(TableView.Binding.shouldHighlightRow) }
	static var shouldIndentWhileEditingRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(TableView.Binding.shouldIndentWhileEditingRow) }
	static var shouldShowMenuForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Bool> { return .name(TableView.Binding.shouldShowMenuForRow) }
	static var shouldUpdateFocus: TableViewName<(UITableView, UITableViewFocusUpdateContext) -> Bool> { return .name(TableView.Binding.shouldUpdateFocus) }
	static var targetIndexPathForMoveFromRow: TableViewName<(_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath> { return .name(TableView.Binding.targetIndexPathForMoveFromRow) }
	static var titleForDeleteConfirmationButtonForRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> String?> { return .name(TableView.Binding.titleForDeleteConfirmationButtonForRow) }
	static var willBeginEditingRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> Void> { return .name(TableView.Binding.willBeginEditingRow) }
	static var willDeselectRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?> { return .name(TableView.Binding.willDeselectRow) }
	static var willDisplayFooter: TableViewName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void> { return .name(TableView.Binding.willDisplayFooter) }
	static var willDisplayHeader: TableViewName<(_ tableView: UITableView, _ section: Int, _ view: UIView) -> Void> { return .name(TableView.Binding.willDisplayHeader) }
	static var willDisplayRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>, _ cell: UITableViewCell) -> Void> { return .name(TableView.Binding.willDisplayRow) }
	static var willSelectRow: TableViewName<(_ tableView: UITableView, _ tableRowData: TableRow<Binding.RowDataType>) -> IndexPath?> { return .name(TableView.Binding.willSelectRow) }
	
	// Composite binding names
	static func rowSelected<Value>(_ keyPath: KeyPath<TableRow<Binding.RowDataType>, Value>) -> TableViewName<SignalInput<Value>> {
		return Binding.compositeName(
			value: { input in { tableView, tableRow -> Void in input.send(value: tableRow[keyPath: keyPath]) } },
			binding: TableView.Binding.didSelectRow,
			downcast: Binding.tableViewBinding
		)
	}
	static func rowSelected(_ void: Void = ()) -> TableViewName<SignalInput<TableRow<Binding.RowDataType>>> {
		return Binding.compositeName(
			value: { input in { tableView, tableRow -> Void in input.send(value: tableRow) } },
			binding: TableView.Binding.didSelectRow,
			downcast: Binding.tableViewBinding
		)
	}
	static func commit<Value>(_ keyPath: KeyPath<TableRowCommit<Binding.RowDataType>, Value>) -> TableViewName<SignalInput<Value>> {
		return Binding.compositeName(
			value: { input in { tableView, editingStyle, tableRow -> Void in input.send(value: TableRowCommit(style: editingStyle, tableRow: tableRow)[keyPath: keyPath]) } },
			binding: TableView.Binding.commit,
			downcast: Binding.tableViewBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableViewConvertible: ScrollViewConvertible {
	func uiTableView() -> UITableView
}
extension TableViewConvertible {
	public func uiScrollView() -> ScrollView.Instance { return uiTableView() }
}
extension UITableView: TableViewConvertible {
	public func uiTableView() -> UITableView { return self }
}
public extension TableView {
	func uiTableView() -> UITableView { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableViewBinding: ScrollViewBinding {
	associatedtype RowDataType
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> Self
	func asTableViewBinding() -> TableView<RowDataType>.Binding?
}
public extension TableViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self {
		return tableViewBinding(.inheritedBinding(binding))
	}
}
public extension TableViewBinding where Preparer.Inherited.Binding: TableViewBinding, Preparer.Inherited.Binding.RowDataType == RowDataType {
	func asTableViewBinding() -> TableView<RowDataType>.Binding? {
		return asInheritedBinding()?.asTableViewBinding()
	}
}
public extension TableView.Binding {
	typealias Preparer = TableView.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asTableViewBinding() -> TableView.Binding? { return self }
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> TableView<RowDataType>.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types
public struct TableSectionMetadata {
	public let header: String?
	public let footer: String?
	public init(header: String? = nil, footer: String? = nil) {
		(self.header, self.footer) = (header, footer)
	}
}

public typealias TableRowMutation<Element> = SubrangeMutation<Element, TableSectionMetadata>
public typealias TableRowAnimatable<Element> = Animatable<TableRowMutation<Element>, UITableView.RowAnimation>
public typealias TableSectionMutation<Element> = SubrangeMutation<TableRowMutation<Element>, ()>
public typealias TableSectionAnimatable<Element> = Animatable<TableSectionMutation<Element>, UITableView.RowAnimation>

public typealias TableRowState<Element> = SubrangeState<Element, TableSectionMetadata>
public typealias TableSectionState<Element> = SubrangeState<TableRowState<Element>, ()>

public extension IndexedMutation where Metadata == Subrange<Void> {
	func apply<RowData>(to sections: inout TableSectionState<RowData>) where Element == TableRowMutation<RowData> {
		if case .update = kind {
			for (mutationIndex, rowIndex) in indexSet.enumerated() {
				values[mutationIndex].mapMetadata { _ in () }.apply(to: &sections.values![rowIndex].values!)
				values[mutationIndex].updateMetadata(&sections.values![rowIndex])
			}
		} else {
			self.mapValues { rowMutation -> TableRowState<RowData> in
				var rowState = TableRowState<RowData>()
				rowMutation.apply(toSubrange: &rowState)
				return rowState
				}.apply(toSubrange: &sections)
		}
		self.updateMetadata(&sections)
	}
}

public struct TableScrollPosition {
	public let indexPath: IndexPath
	public let position: UITableView.ScrollPosition
	public init(indexPath: IndexPath, position: UITableView.ScrollPosition = .none) {
		self.indexPath = indexPath
		self.position = position
	}
	
	public static func none(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .none)
	}
	
	public static func top(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .top)
	}
	
	public static func middle(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .middle)
	}
	
	public static func bottom(_ indexPath: IndexPath) -> TableScrollPosition {
		return TableScrollPosition(indexPath: indexPath, position: .bottom)
	}
}

public struct TableRowCommit<RowData> {
	public let style: UITableViewCell.EditingStyle
	public let tableRow: TableRow<RowData>

	public init(style: UITableViewCell.EditingStyle, tableRow: TableRow<RowData>) {
		self.style = style
		self.tableRow = tableRow
	}
}

public struct TableRow<RowData> {
	public let indexPath: IndexPath
	public let data: RowData?
	
	public init(indexPath: IndexPath, data: RowData?) {
		self.indexPath = indexPath
		self.data = data
	}
}

public extension Sequence {
	func tableData() -> TableSectionAnimatable<Element> {
		return .set(.reload([.reload(Array(self))]))
	}
}

public extension Signal {
	func tableData<RowData>(_ choice: AnimationChoice = .subsequent) -> Signal<TableSectionAnimatable<RowData>> where TableRowMutation<RowData> == OutputValue {
		return map(initialState: false) { (alreadyReceived: inout Bool, rowMutation: OutputValue) -> TableSectionAnimatable<RowData> in
			if alreadyReceived || choice == .always {
				return .animate(.updated(rowMutation, at: 0), animation: .automatic)
			} else {
				if choice == .subsequent {
					alreadyReceived = true
				}
				return .set(.reload([rowMutation]))
			}
		}
	}
}

public extension Adapter where State == VarState<IndexPath?> {
	func updateFirstRow<RowData>() -> SignalInput<[TableRow<RowData>]> {
		return Input().map { $0.first?.indexPath }.bind(to: update())
	}
}

extension SignalInterface where OutputValue == IndexPath? {
	public func restoreFirstRow() -> Signal<SetOrAnimate<TableScrollPosition>> {
		return compactMap { $0.map { .top($0) } }.animate(.never)
	}
}

#endif

//
//  CwlTableView_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 28/10/2015.
//  Copyright © 2015 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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

#if os(macOS)

// MARK: - Binder Part 1: Binder
public class TableView<RowData>: Binder, TableViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}

	public static func scrollEmbedded(type: NSTableView.Type = NSTableView.self, _ bindings: Binding...) -> ScrollView {
		return ScrollView(
			.borderType -- .noBorder,
			.hasVerticalScroller -- true,
			.hasHorizontalScroller -- true,
			.autohidesScrollers -- true,
			.contentView -- ClipView(
				.documentView -- TableView<RowData>(type: type, bindings: bindings)
			)
		)
	}
}

// MARK: - Binder Part 2: Binding
public extension TableView {
	enum Binding: TableViewBinding {
		public typealias RowDataType = RowData
		
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsColumnReordering(Dynamic<Bool>)
		case allowsColumnResizing(Dynamic<Bool>)
		case allowsColumnSelection(Dynamic<Bool>)
		case allowsEmptySelection(Dynamic<Bool>)
		case allowsMultipleSelection(Dynamic<Bool>)
		case allowsTypeSelect(Dynamic<Bool>)
		case autosaveName(Dynamic<NSTableView.AutosaveName?>)
		case autosaveTableColumns(Dynamic<Bool>)
		case backgroundColor(Dynamic<NSColor>)
		case columnAutoresizingStyle(Dynamic<NSTableView.ColumnAutoresizingStyle>)
		case columns(Dynamic<[TableColumn<RowData>]>)
		case cornerView(Dynamic<ViewConvertible?>)
		case draggingDestinationFeedbackStyle(Dynamic<NSTableView.DraggingDestinationFeedbackStyle>)
		case floatsGroupRows(Dynamic<Bool>)
		case gridColor(Dynamic<NSColor>)
		case gridStyleMask(Dynamic<NSTableView.GridLineStyle>)
		case headerView(Dynamic<TableHeaderViewConvertible?>)
		case intercellSpacing(Dynamic<NSSize>)
		case rowHeight(Dynamic<CGFloat>)
		case rows(Dynamic<TableRowAnimatable<RowData>>)
		case rowSizeStyle(Dynamic<NSTableView.RowSizeStyle>)
		case selectionHighlightStyle(Dynamic<NSTableView.SelectionHighlightStyle>)
		case userInterfaceLayoutDirection(Dynamic<NSUserInterfaceLayoutDirection>)
		case usesAlternatingRowBackgroundColors(Dynamic<Bool>)
		case usesAutomaticRowHeights(Dynamic<Bool>)
		case verticalMotionCanBeginDrag(Dynamic<Bool>)

		// 2. Signal bindings are performed on the object after construction.
		case deselectAll(Signal<Void>)
		case deselectColumn(Signal<NSUserInterfaceItemIdentifier>)
		case deselectRow(Signal<Int>)
		case hideRowActions(Signal<Void>)
		case hideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)
		case highlightColumn(Signal<NSUserInterfaceItemIdentifier?>)
		case moveColumn(Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>)
		case scrollColumnToVisible(Signal<NSUserInterfaceItemIdentifier>)
		case scrollRowToVisible(Signal<Int>)
		case selectAll(Signal<Void>)
		case selectColumns(Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>)
		case selectRows(Signal<(indexes: IndexSet, byExtendingSelection: Bool)>)
		case sizeLastColumnToFit(Signal<Void>)
		case sizeToFit(Signal<Void>)
		case unhideRows(Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>)

		// 3. Action bindings are triggered by the object after construction.
		case columnMoved(SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>)
		case columnResized(SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>)
		case doubleAction(TargetAction)
		case visibleRowsChanged(SignalInput<CountableRange<Int>>)

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case acceptDrop((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> Bool)
		case didClickTableColumn((NSTableView, NSTableColumn) -> Void)
		case didDragTableColumn((NSTableView, NSTableColumn) -> Void)
		case draggingSessionEnded((_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void)
		case draggingSessionWillBegin((_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void)
		case groupRowCellConstructor((Int) -> TableCellViewConvertible)
		case heightOfRow((_ tableView: NSTableView, _ row: Int, _ rowData: RowData?) -> CGFloat)
		case isGroupRow((_ tableView: NSTableView, _ row: Int, _ rowData: RowData?) -> Bool)
		case mouseDownInHeaderOfTableColumn((NSTableView, NSTableColumn) -> Void)
		case nextTypeSelectMatch((_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int)
		case pasteboardWriter((_ tableView: NSTableView, _ row: Int, _ data: RowData?) -> NSPasteboardWriting)
		case rowActionsForRow((_ tableView: NSTableView, _ row: Int, _ data: RowData?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction])
		case rowView((_ tableView: NSTableView, _ row: Int, _ rowData: RowData?) -> TableRowViewConvertible?)
		case selectionDidChange((Notification) -> Void)
		case selectionIndexesForProposedSelection((_ tableView: NSTableView, IndexSet) -> IndexSet)
		case selectionShouldChange((_ tableView: NSTableView) -> Bool)
		case shouldReorderColumn((_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier, _ newIndex: Int) -> Bool)
		case shouldSelectRow((_ tableView: NSTableView, _ row: Int, _ rowData: RowData?) -> Bool)
		case shouldSelectTableColumn((_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool)
		case shouldTypeSelectForEvent((_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool)
		case sizeToFitWidthOfColumn((_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier) -> CGFloat)
		case sortDescriptorsDidChange((NSTableView, [NSSortDescriptor]) -> Void)
		case typeSelectString((_ tableView: NSTableView, _ cell: TableCell<RowData>) -> String?)
		case updateDraggingItems((_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void)
		case validateDrop((_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation)
	}
}

// MARK: - Binder Part 3: Preparer
public extension TableView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = TableView.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSTableView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage(visibleRowsChanged: visibleRowsChanged) }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
		
		var singleAction: TargetAction?
		var doubleAction: TargetAction?
		var visibleRowsChanged: MultiOutput<CountableRange<Int>>?
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension TableView.Preparer {
	var delegateIsRequired: Bool { return true }
	
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(.action(let x)): singleAction = x
		case .inheritedBinding(let x): inherited.prepareBinding(x)
			
		case .acceptDrop(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDataSource.tableView(_:acceptDrop:row:dropOperation:)))
		case .didDragTableColumn(let x): delegate().addMultiHandler2(x, #selector(NSTableViewDelegate.tableView(_:didDrag:)))
		case .didClickTableColumn(let x): delegate().addMultiHandler2(x, #selector(NSTableViewDelegate.tableView(_:didClick:)))
		case .doubleAction(let x): doubleAction = x
		case .draggingSessionEnded(let x): delegate().addMultiHandler4(x, #selector(NSTableViewDataSource.tableView(_:draggingSession:endedAt:operation:)))
		case .draggingSessionWillBegin(let x): delegate().addMultiHandler4(x, #selector(NSTableViewDataSource.tableView(_:draggingSession:willBeginAt:forRowIndexes:)))
		case .heightOfRow(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDelegate.tableView(_:heightOfRow:)))
		case .isGroupRow(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDelegate.tableView(_:isGroupRow:)))
		case .mouseDownInHeaderOfTableColumn(let x): delegate().addMultiHandler2(x, #selector(NSTableViewDelegate.tableView(_:mouseDownInHeaderOf:)))
		case .nextTypeSelectMatch(let x): delegate().addSingleHandler4(x, #selector(NSTableViewDelegate.tableView(_:nextTypeSelectMatchFromRow:toRow:for:)))
		case .pasteboardWriter(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDataSource.tableView(_:pasteboardWriterForRow:)))
		case .rowActionsForRow(let x): delegate().addSingleHandler4(x, #selector(NSTableViewDelegate.tableView(_:rowActionsForRow:edge:)))
		case .rowView(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDelegate.tableView(_:rowViewForRow:)))
		case .selectionDidChange(let x): delegate().addMultiHandler1(x, #selector(NSTableViewDelegate.tableViewSelectionDidChange(_:)))
		case .selectionIndexesForProposedSelection(let x): delegate().addSingleHandler2(x, #selector(NSTableViewDelegate.tableView(_:selectionIndexesForProposedSelection:)))
		case .selectionShouldChange(let x): delegate().addSingleHandler1(x, #selector(NSTableViewDelegate.selectionShouldChange(in:)))
		case .shouldReorderColumn(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDelegate.tableView(_:shouldReorderColumn:toColumn:)))
		case .shouldSelectRow(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDelegate.tableView(_:shouldSelectRow:)))
		case .shouldSelectTableColumn(let x): delegate().addSingleHandler2(x, #selector(NSTableViewDelegate.tableView(_:shouldSelect:)))
		case .shouldTypeSelectForEvent(let x): delegate().addSingleHandler3(x, #selector(NSTableViewDelegate.tableView(_:shouldTypeSelectFor:withCurrentSearch:)))
		case .sizeToFitWidthOfColumn(let x): delegate().addSingleHandler2(x, #selector(NSTableViewDelegate.tableView(_:sizeToFitWidthOfColumn:)))
		case .sortDescriptorsDidChange(let x): delegate().addMultiHandler2(x, #selector(NSTableViewDataSource.tableView(_:sortDescriptorsDidChange:)))
		case .typeSelectString(let x): delegate().addSingleHandler2(x, #selector(NSTableViewDelegate.tableView(_:typeSelectStringFor:row:)))
		case .updateDraggingItems(let x): delegate().addMultiHandler2(x, #selector(NSTableViewDataSource.tableView(_:updateDraggingItemsForDrag:)))
		case .validateDrop(let x): delegate().addSingleHandler4(x, #selector(NSTableViewDataSource.tableView(_:validateDrop:proposedRow:proposedDropOperation:)))
		case .visibleRowsChanged(let x):
			visibleRowsChanged = visibleRowsChanged ?? Input().multicast()
			visibleRowsChanged?.signal.bind(to: x)
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
		case .inheritedBinding(.action): return nil
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .allowsColumnReordering(let x): return x.apply(instance) { i, v in i.allowsColumnReordering = v }
		case .allowsColumnResizing(let x): return x.apply(instance) { i, v in i.allowsColumnResizing = v }
		case .allowsColumnSelection(let x): return x.apply(instance) { i, v in i.allowsColumnSelection = v }
		case .allowsEmptySelection(let x): return x.apply(instance) { i, v in i.allowsEmptySelection = v }
		case .allowsMultipleSelection(let x): return x.apply(instance) { i, v in i.allowsMultipleSelection = v }
		case .allowsTypeSelect(let x): return x.apply(instance) { i, v in i.allowsTypeSelect = v }
		case .autosaveName(let x): return x.apply(instance) { i, v in i.autosaveName = v }
		case .autosaveTableColumns(let x): return x.apply(instance) { i, v in i.autosaveTableColumns = v }
		case .backgroundColor(let x): return x.apply(instance) { i, v in i.backgroundColor = v }
		case .columnAutoresizingStyle(let x): return x.apply(instance) { i, v in i.columnAutoresizingStyle = v }
		case .columns(let x): return x.apply(instance, storage) { i, s, v in s.updateColumns(v.map { $0.construct() }, in: i) }
		case .cornerView(let x): return x.apply(instance) { i, v in i.cornerView = v?.nsView() }
		case .draggingDestinationFeedbackStyle(let x): return x.apply(instance) { i, v in i.draggingDestinationFeedbackStyle = v }
		case .floatsGroupRows(let x): return x.apply(instance) { i, v in i.floatsGroupRows = v }
		case .gridColor(let x): return x.apply(instance) { i, v in i.gridColor = v }
		case .gridStyleMask(let x): return x.apply(instance) { i, v in i.gridStyleMask = v }
		case .intercellSpacing(let x): return x.apply(instance) { i, v in i.intercellSpacing = v }
		case .rowHeight(let x): return x.apply(instance) { i, v in i.rowHeight = v }
		case .rowSizeStyle(let x): return x.apply(instance) { i, v in i.rowSizeStyle = v }
		case .selectionHighlightStyle(let x): return x.apply(instance) { i, v in i.selectionHighlightStyle = v }
		case .userInterfaceLayoutDirection(let x): return x.apply(instance) { i, v in i.userInterfaceLayoutDirection = v }
		case .usesAlternatingRowBackgroundColors(let x): return x.apply(instance) { i, v in i.usesAlternatingRowBackgroundColors = v }
		case .usesAutomaticRowHeights(let x): return x.apply(instance) { i, v in i.usesAutomaticRowHeights = v }
		case .verticalMotionCanBeginDrag(let x): return x.apply(instance) { i, v in i.verticalMotionCanBeginDrag = v }

		// 2. Signal bindings are performed on the object after construction.
		case .deselectAll(let x): return x.apply(instance) { i, v in i.deselectAll(nil) }
		case .deselectColumn(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
					i.deselectColumn(index)
				}
			}
		case .deselectRow(let x): return x.apply(instance) { i, v in i.deselectRow(v) }
		case .hideRowActions(let x): return x.apply(instance) { i, v in i.rowActionsVisible = false }
		case .hideRows(let x): return x.apply(instance) { i, v in i.hideRows(at: v.indexes, withAnimation: v.withAnimation) }
		case .highlightColumn(let x):
			return x.apply(instance) { i, v in
				i.highlightedTableColumn = v.flatMap { (identifier: NSUserInterfaceItemIdentifier) -> NSTableColumn? in
					return i.tableColumns.first(where: { $0.identifier == identifier })
				}
			}
		case .moveColumn(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v.identifier })?.offset {
					i.moveColumn(index, toColumn: v.toIndex)
				}
			}
		case .scrollRowToVisible(let x): return x.apply(instance) { i, v in i.scrollRowToVisible(v) }
		case .scrollColumnToVisible(let x):
			return x.apply(instance) { i, v in
				if let index = i.tableColumns.enumerated().first(where: { $0.element.identifier == v })?.offset {
					i.scrollColumnToVisible(index)
				}
			}
		case .selectAll(let x): return x.apply(instance) { i, v in i.selectAll(nil) }
		case .selectColumns(let x):
			return x.apply(instance) { i, v in
				let indexes = v.identifiers.compactMap { identifier in i.tableColumns.enumerated().first(where: { $0.element.identifier == identifier })?.offset }
				let indexSet = IndexSet(indexes)
				i.selectColumnIndexes(indexSet, byExtendingSelection: v.byExtendingSelection)
			}
		case .selectRows(let x): return x.apply(instance) { i, v in i.selectRowIndexes(v.indexes, byExtendingSelection: v.byExtendingSelection) }
		case .sizeLastColumnToFit(let x): return x.apply(instance) { i, v in i.sizeLastColumnToFit() }
		case .sizeToFit(let x): return x.apply(instance) { i, v in i.sizeToFit() }
		case .unhideRows(let x): return x.apply(instance) { i, v in i.unhideRows(at: v.indexes, withAnimation: v.withAnimation) }

		// 3. Action bindings are triggered by the object after construction.
		case .columnMoved(let x):
			return Signal.notifications(name: NSTableView.columnDidMoveNotification, object: instance).compactMap { [weak instance] notification -> (column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)? in
				guard let index = (notification.userInfo?["NSNewColumn"] as? NSNumber)?.intValue, let column = instance?.tableColumns.at(index) else {
					return nil
				}
				guard let oldIndex = (notification.userInfo?["NSNewColumn"] as? NSNumber)?.intValue else {
					return nil
				}
				return (column: column.identifier, oldIndex: oldIndex, newIndex: index)
			}.cancellableBind(to: x)
		case .columnResized(let x):
			return Signal.notifications(name: NSTableView.columnDidResizeNotification, object: instance).compactMap { notification -> (column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)? in
				guard let column = (notification.userInfo?["NSTableColumn"] as? NSTableColumn) else {
					return nil
				}
				guard let oldWidth = (notification.userInfo?["NSOldWidth"] as? NSNumber)?.doubleValue else {
					return nil
				}
				return (column: column.identifier, oldWidth: CGFloat(oldWidth), newWidth: column.width)
			}.cancellableBind(to: x)
		case .doubleAction: return nil
		case .visibleRowsChanged: return nil

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .acceptDrop: return nil
		case .didClickTableColumn: return nil
		case .didDragTableColumn: return nil
		case .draggingSessionEnded: return nil
		case .draggingSessionWillBegin: return nil
		case .groupRowCellConstructor(let x):
			storage.groupRowCellConstructor = x
			return nil
		case .headerView(let x): return x.apply(instance) { i, v in i.headerView = v?.nsTableHeaderView() }
		case .heightOfRow: return nil
		case .isGroupRow: return nil
		case .mouseDownInHeaderOfTableColumn: return nil
		case .nextTypeSelectMatch: return nil
		case .pasteboardWriter: return nil
		case .rowActionsForRow: return nil
		case .rows(let x): return x.apply(instance, storage) { i, s, v in s.applyRowAnimation(v, in: i) }
		case .rowView: return nil
		case .selectionDidChange: return nil
		case .selectionIndexesForProposedSelection: return nil
		case .selectionShouldChange: return nil
		case .shouldReorderColumn: return nil
		case .shouldSelectRow: return nil
		case .shouldSelectTableColumn: return nil
		case .shouldTypeSelectForEvent: return nil
		case .sizeToFitWidthOfColumn: return nil
		case .sortDescriptorsDidChange: return nil
		case .typeSelectString: return nil
		case .updateDraggingItems: return nil
		case .validateDrop: return nil
		}
	}
	
	func finalizeInstance(_ instance: Instance, storage: Storage) -> Lifetime? {
		var lifetimes = [Lifetime]()
		
		switch (singleAction, doubleAction) {
		case (nil, nil): break
		case (.firstResponder(let sa)?, .firstResponder(let da)?):
			instance.action = sa
			instance.doubleAction = da
			instance.target = nil
		case (.singleTarget(let st)?, .singleTarget(let dt)?):
			let target = SignalDoubleActionTarget()
			instance.target = target 
			lifetimes += target.signal.cancellableBind(to: st)
			lifetimes += target.signal.cancellableBind(to: dt)
			instance.action = SignalDoubleActionTarget.selector
			instance.doubleAction = SignalDoubleActionTarget.secondSelector
		case (let s?, nil):
			lifetimes += s.apply(to: instance, constructTarget: SignalActionTarget.init)
		case (nil, let d?):
			lifetimes += d.apply(to: instance, constructTarget: SignalActionTarget.init)
			instance.doubleAction = instance.action
			instance.action = nil
		case (.some, .some): fatalError("Action and double action may not use mix of single target and first responder")
		}
		
		return lifetimes.isEmpty ? nil : AggregateLifetime(lifetimes: lifetimes)
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension TableView.Preparer {
	open class Storage: View.Preparer.Storage, NSTableViewDelegate, NSTableViewDataSource {
		public let visibleRowsChanged: MultiOutput<CountableRange<Int>>?

		open var actionTarget: SignalDoubleActionTarget? = nil
		open var rowState: TableRowState<RowData> = TableRowState<RowData>()
		open var visibleRows: IndexSet = []
		open var groupRowCellConstructor: ((Int) -> TableCellViewConvertible)?
		open var columns: [TableColumn<RowData>.Preparer.Storage] = []
		
		public init(visibleRowsChanged: MultiOutput<CountableRange<Int>>?) {
			self.visibleRowsChanged = visibleRowsChanged
		}
		
		open override var isInUse: Bool { return true }
		
		fileprivate func rowData(at row: Int) -> RowData? {
			return rowState.values?.at(row)
		}
		
		open func columnForIdentifier(_ identifier: NSUserInterfaceItemIdentifier) -> (offset: Int, element: TableColumn<RowData>.Preparer.Storage)? {
			return columns.enumerated().first { (tuple: (offset: Int, element: TableColumn<RowData>.Preparer.Storage)) -> Bool in
				tuple.element.tableColumn.identifier == identifier
			}
		}
		
		open func numberOfRows(in tableView: NSTableView) -> Int {
			return rowState.globalCount
		}

		open func tableView(_ tableView: NSTableView, didAdd: NSTableRowView, forRow: Int) {
			DispatchQueue.main.async {
				if let vrsi = self.visibleRowsChanged?.input {
					let previousMin = self.visibleRows.min() ?? 0
					let previousMax = self.visibleRows.max() ?? previousMin
					self.visibleRows.insert(forRow)
					let newMin = self.visibleRows.min() ?? 0
					let newMax = self.visibleRows.max() ?? newMin
					if previousMin != newMin || previousMax != newMax {
						vrsi.send(value: newMin..<newMax)
					}
				}
			}
		}
		
		open func tableView(_ tableView: NSTableView, didRemove: NSTableRowView, forRow: Int) {
			DispatchQueue.main.async {
				if let vrsi = self.visibleRowsChanged?.input {
					let previousMin = self.visibleRows.min() ?? 0
					let previousMax = self.visibleRows.max() ?? previousMin
					self.visibleRows.remove(forRow)
					let newMin = self.visibleRows.min() ?? 0
					let newMax = self.visibleRows.max() ?? newMin
					if previousMin != newMin || previousMax != newMax {
						vrsi.send(value: newMin..<newMax)
					}
				}
			}
		}

		open func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
			return nil
		}
		
		open func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
			if let tc = tableColumn {
				if let col = columnForIdentifier(tc.identifier) {
					let data = rowState.values?.at(row - rowState.localOffset)
					let identifier = col.element.cellIdentifier?(data) ?? tc.identifier

					let cellView: NSTableCellView
					let cellInput: SignalInput<RowData>?
					if let reusedView = tableView.makeView(withIdentifier: identifier, owner: tableView), let downcast = reusedView as? NSTableCellView {
						cellView = downcast
						cellInput = cellView.associatedRowInput(valueType: RowData.self)
					} else if let cc = col.element.cellConstructor {
						let dataTuple = Signal<RowData>.create()
						let constructed = cc(identifier, dataTuple.signal.multicast()).nsTableCellView()
						if constructed.identifier == nil {
							constructed.identifier = identifier
						}
						cellView = constructed
						cellInput = dataTuple.input
						cellView.setAssociatedRowInput(to: dataTuple.input)
					} else {
						return col.element.dataMissingCell?()?.nsTableCellView()
					}
					
					if let d = data {
						_ = cellInput?.send(value: d)
					}
					return cellView
				}
			} else {
				return groupRowCellConstructor?(row).nsTableCellView()
			}
			return nil
		}

		open func updateColumns(_ v: [TableColumn<RowData>.Preparer.Storage], in tableView: NSTableView) {
			columns = v
			let columnsArray = v.map { $0.tableColumn }
			let newColumnSet = Set(columnsArray)
			let oldColumnSet = Set(tableView.tableColumns)
			
			for c in columnsArray {
				if !oldColumnSet.contains(c) {
					tableView.addTableColumn(c)
				}
				if !newColumnSet.contains(c) {
					tableView.removeTableColumn(c)
				}
			}
		}

		open func applyRowAnimation(_ rowAnimation: TableRowAnimatable<RowData>, in tableView: NSTableView) {
			rowAnimation.value.apply(toSubrange: &rowState)
			rowAnimation.value.updateMetadata(&rowState)
			
			let animation = rowAnimation.animation ?? []
			let indices = rowAnimation.value.indexSet.offset(by: rowState.localOffset)

			switch rowAnimation.value.kind {
			case .delete:
				tableView.removeRows(at: indices, withAnimation: animation)
			case .move(let destination):
				tableView.beginUpdates()
				for (count, index) in indices.enumerated() {
					tableView.moveRow(at: index, to: destination + count)
				}
				tableView.endUpdates()
			case .insert:
				tableView.insertRows(at: indices, withAnimation: animation)
			case .scroll:
				tableView.reloadData(forRowIndexes: indices, columnIndexes: IndexSet(integersIn: 0..<tableView.tableColumns.count))
			case .update:
				tableView.beginUpdates()
				for rowIndex in indices {
					for columnIndex in 0..<tableView.numberOfColumns {
						guard let cell = tableView.view(atColumn: columnIndex, row: rowIndex, makeIfNecessary: false) as? NSTableCellView, let value = rowState.values?.at(rowIndex - rowState.localOffset) else { continue }
						cell.associatedRowInput(valueType: RowData.self)?.send(value: value)
					}
				}
				tableView.endUpdates()
			case .reload:
				tableView.reloadData()
			}
		}
	}

	open class Delegate: DynamicDelegate, NSTableViewDelegate, NSTableViewDataSource {
		private func storage(for tableView: NSTableView) -> Storage? {
			return tableView.delegate as? Storage
		}
		
		open func tableView(_ tableView: NSTableView, didDrag tableColumn: NSTableColumn) {
			multiHandler(tableView, tableColumn)
		}

		open func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
			multiHandler(tableView, tableColumn)
		}

		open func tableView(_ tableView: NSTableView, mouseDownInHeaderOf tableColumn: NSTableColumn) {
			multiHandler(tableView, tableColumn)
		}

		open func tableView(_ tableView: NSTableView, rowViewForRow rowIndex: Int) -> NSTableRowView? {
			return (singleHandler(rowIndex, storage(for: tableView)?.rowData(at: rowIndex)) as TableRowViewConvertible?)?.nsTableRowView()
		}

		open func tableView(_ tableView: NSTableView, shouldReorderColumn columnIndex: Int, toColumn newColumnIndex: Int) -> Bool {
			if let column = tableView.tableColumns.at(columnIndex) {
				return singleHandler(tableView, column.identifier, newColumnIndex)
			}
			return false
		}

		open func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
			if let column = tableView.tableColumns.at(column) {
				return singleHandler(tableView, column.identifier)
			}
			return 0
		}

		open func tableView(_ tableView: NSTableView, shouldTypeSelectFor event: NSEvent, withCurrentSearch searchString: String?) -> Bool {
			return singleHandler(tableView, event, searchString)
		}

		open func tableView(_ tableView: NSTableView, typeSelectStringFor tableColumn: NSTableColumn?, row: Int) -> String? {
			guard let tc = tableColumn, row >= 0 else { return nil }
			return singleHandler(TableCell<RowData>(row: row, column: tc, tableView: tableView))
		}

		open func tableView(_ tableView: NSTableView, nextTypeSelectMatchFromRow startRow: Int, toRow endRow: Int, for searchString: String) -> Int {
			return singleHandler(tableView, startRow, endRow, searchString)
		}

		open func tableView(_ tableView: NSTableView, heightOfRow rowIndex: Int) -> CGFloat {
			return singleHandler(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
			return singleHandler(tableView, tableColumn)
		}

		open func tableView(_ tableView: NSTableView, selectionIndexesForProposedSelection proposedSelectionIndexes: IndexSet) -> IndexSet {
			return singleHandler(tableView, proposedSelectionIndexes)
		}

		open func tableView(_ tableView: NSTableView, shouldSelectRow rowIndex: Int) -> Bool {
			return singleHandler(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func selectionShouldChange(in tableView: NSTableView) -> Bool {
			return singleHandler(tableView)
		}

		open func tableView(_ tableView: NSTableView, isGroupRow rowIndex: Int) -> Bool {
			return singleHandler(rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
			multiHandler(tableView, oldDescriptors)
		}

		open func tableView(_ tableView: NSTableView, pasteboardWriterForRow rowIndex: Int) -> NSPasteboardWriting? {
			return singleHandler(tableView, rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}
		
		open func tableViewSelectionDidChange(_ notification: Notification) {
			multiHandler(notification)
		}
		
		open func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row rowIndex: Int, dropOperation: NSTableView.DropOperation) -> Bool {
			return singleHandler(tableView, rowIndex, storage(for: tableView)?.rowData(at: rowIndex))
		}

		open func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
			return singleHandler(tableView, info, row, dropOperation)
		}

		open func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
			return singleHandler(tableView, session, screenPoint, rowIndexes)
		}

		open func tableView(_ tableView: NSTableView, updateDraggingItemsForDrag draggingInfo: NSDraggingInfo) {
			return singleHandler(tableView, draggingInfo)
		}

		open func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
			return singleHandler(tableView, session, screenPoint, operation)
		}

		open func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
			return singleHandler(tableView, row, edge)
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
	
	// 1. Value bindings may be applied at construction and may subsequently change.
	static var allowsColumnReordering: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsColumnReordering) }
	static var allowsColumnResizing: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsColumnResizing) }
	static var allowsColumnSelection: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsColumnSelection) }
	static var allowsEmptySelection: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsEmptySelection) }
	static var allowsMultipleSelection: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsMultipleSelection) }
	static var allowsTypeSelect: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.allowsTypeSelect) }
	static var autosaveName: TableViewName<Dynamic<NSTableView.AutosaveName?>> { return .name(TableView.Binding.autosaveName) }
	static var autosaveTableColumns: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.autosaveTableColumns) }
	static var backgroundColor: TableViewName<Dynamic<NSColor>> { return .name(TableView.Binding.backgroundColor) }
	static var columnAutoresizingStyle: TableViewName<Dynamic<NSTableView.ColumnAutoresizingStyle>> { return .name(TableView.Binding.columnAutoresizingStyle) }
	static var columns: TableViewName<Dynamic<[TableColumn<Binding.RowDataType>]>> { return .name(TableView.Binding.columns) }
	static var cornerView: TableViewName<Dynamic<ViewConvertible?>> { return .name(TableView.Binding.cornerView) }
	static var draggingDestinationFeedbackStyle: TableViewName<Dynamic<NSTableView.DraggingDestinationFeedbackStyle>> { return .name(TableView.Binding.draggingDestinationFeedbackStyle) }
	static var floatsGroupRows: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.floatsGroupRows) }
	static var gridColor: TableViewName<Dynamic<NSColor>> { return .name(TableView.Binding.gridColor) }
	static var gridStyleMask: TableViewName<Dynamic<NSTableView.GridLineStyle>> { return .name(TableView.Binding.gridStyleMask) }
	static var headerView: TableViewName<Dynamic<TableHeaderViewConvertible?>> { return .name(TableView.Binding.headerView) }
	static var intercellSpacing: TableViewName<Dynamic<NSSize>> { return .name(TableView.Binding.intercellSpacing) }
	static var rowHeight: TableViewName<Dynamic<CGFloat>> { return .name(TableView.Binding.rowHeight) }
	static var rows: TableViewName<Dynamic<TableRowAnimatable<Binding.RowDataType>>> { return .name(TableView.Binding.rows) }
	static var rowSizeStyle: TableViewName<Dynamic<NSTableView.RowSizeStyle>> { return .name(TableView.Binding.rowSizeStyle) }
	static var selectionHighlightStyle: TableViewName<Dynamic<NSTableView.SelectionHighlightStyle>> { return .name(TableView.Binding.selectionHighlightStyle) }
	static var userInterfaceLayoutDirection: TableViewName<Dynamic<NSUserInterfaceLayoutDirection>> { return .name(TableView.Binding.userInterfaceLayoutDirection) }
	static var usesAlternatingRowBackgroundColors: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.usesAlternatingRowBackgroundColors) }
	static var usesAutomaticRowHeights: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.usesAutomaticRowHeights) }
	static var verticalMotionCanBeginDrag: TableViewName<Dynamic<Bool>> { return .name(TableView.Binding.verticalMotionCanBeginDrag) }
	
	// 2. Signal bindings are performed on the object after construction.
	static var deselectAll: TableViewName<Signal<Void>> { return .name(TableView.Binding.deselectAll) }
	static var deselectColumn: TableViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(TableView.Binding.deselectColumn) }
	static var deselectRow: TableViewName<Signal<Int>> { return .name(TableView.Binding.deselectRow) }
	static var hideRowActions: TableViewName<Signal<Void>> { return .name(TableView.Binding.hideRowActions) }
	static var hideRows: TableViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(TableView.Binding.hideRows) }
	static var highlightColumn: TableViewName<Signal<NSUserInterfaceItemIdentifier?>> { return .name(TableView.Binding.highlightColumn) }
	static var moveColumn: TableViewName<Signal<(identifier: NSUserInterfaceItemIdentifier, toIndex: Int)>> { return .name(TableView.Binding.moveColumn) }
	static var scrollColumnToVisible: TableViewName<Signal<NSUserInterfaceItemIdentifier>> { return .name(TableView.Binding.scrollColumnToVisible) }
	static var scrollRowToVisible: TableViewName<Signal<Int>> { return .name(TableView.Binding.scrollRowToVisible) }
	static var selectAll: TableViewName<Signal<Void>> { return .name(TableView.Binding.selectAll) }
	static var selectColumns: TableViewName<Signal<(identifiers: Set<NSUserInterfaceItemIdentifier>, byExtendingSelection: Bool)>> { return .name(TableView.Binding.selectColumns) }
	static var selectRows: TableViewName<Signal<(indexes: IndexSet, byExtendingSelection: Bool)>> { return .name(TableView.Binding.selectRows) }
	static var sizeLastColumnToFit: TableViewName<Signal<Void>> { return .name(TableView.Binding.sizeLastColumnToFit) }
	static var sizeToFit: TableViewName<Signal<Void>> { return .name(TableView.Binding.sizeToFit) }
	static var unhideRows: TableViewName<Signal<(indexes: IndexSet, withAnimation: NSTableView.AnimationOptions)>> { return .name(TableView.Binding.unhideRows) }
	
	// 3. Action bindings are triggered by the object after construction.
	static var columnMoved: TableViewName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldIndex: Int, newIndex: Int)>> { return .name(TableView.Binding.columnMoved) }
	static var columnResized: TableViewName<SignalInput<(column: NSUserInterfaceItemIdentifier, oldWidth: CGFloat, newWidth: CGFloat)>> { return .name(TableView.Binding.columnResized) }
	static var doubleAction: TableViewName<TargetAction> { return .name(TableView.Binding.doubleAction) }
	static var visibleRowsChanged: TableViewName<SignalInput<CountableRange<Int>>> { return .name(TableView.Binding.visibleRowsChanged) }
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
	static var acceptDrop: TableViewName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> Bool> { return .name(TableView.Binding.acceptDrop) }
	static var didClickTableColumn: TableViewName<(NSTableView, NSTableColumn) -> Void> { return .name(TableView.Binding.didClickTableColumn) }
	static var didDragTableColumn: TableViewName<(NSTableView, NSTableColumn) -> Void> { return .name(TableView.Binding.didDragTableColumn) }
	static var draggingSessionEnded: TableViewName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ endedAt: NSPoint, _ operation: NSDragOperation) -> Void> { return .name(TableView.Binding.draggingSessionEnded) }
	static var draggingSessionWillBegin: TableViewName<(_ tableView: NSTableView, _ session: NSDraggingSession, _ willBeginAt: NSPoint, _ forRowIndexes: IndexSet) -> Void> { return .name(TableView.Binding.draggingSessionWillBegin) }
	static var groupRowCellConstructor: TableViewName<(Int) -> TableCellViewConvertible> { return .name(TableView.Binding.groupRowCellConstructor) }
	static var heightOfRow: TableViewName<(_ tableView: NSTableView, _ row: Int, _ rowData: Binding.RowDataType?) -> CGFloat> { return .name(TableView.Binding.heightOfRow) }
	static var isGroupRow: TableViewName<(_ tableView: NSTableView, _ row: Int, _ rowData: Binding.RowDataType?) -> Bool> { return .name(TableView.Binding.isGroupRow) }
	static var mouseDownInHeaderOfTableColumn: TableViewName<(NSTableView, NSTableColumn) -> Void> { return .name(TableView.Binding.mouseDownInHeaderOfTableColumn) }
	static var nextTypeSelectMatch: TableViewName<(_ tableView: NSTableView, _ startRow: Int, _ endRow: Int, _ searchString: String) -> Int> { return .name(TableView.Binding.nextTypeSelectMatch) }
	static var pasteboardWriter: TableViewName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?) -> NSPasteboardWriting> { return .name(TableView.Binding.pasteboardWriter) }
	static var rowActionsForRow: TableViewName<(_ tableView: NSTableView, _ row: Int, _ data: Binding.RowDataType?, _ edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction]> { return .name(TableView.Binding.rowActionsForRow) }
	static var rowView: TableViewName<(_ tableView: NSTableView, _ row: Int, _ rowData: Binding.RowDataType?) -> TableRowViewConvertible?> { return .name(TableView.Binding.rowView) }
	static var selectionDidChange: TableViewName<(Notification) -> Void> { return .name(TableView.Binding.selectionDidChange) }
	static var selectionIndexesForProposedSelection: TableViewName<(_ tableView: NSTableView, IndexSet) -> IndexSet> { return .name(TableView.Binding.selectionIndexesForProposedSelection) }
	static var selectionShouldChange: TableViewName<(_ tableView: NSTableView) -> Bool> { return .name(TableView.Binding.selectionShouldChange) }
	static var shouldReorderColumn: TableViewName<(_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier, _ newIndex: Int) -> Bool> { return .name(TableView.Binding.shouldReorderColumn) }
	static var shouldSelectRow: TableViewName<(_ tableView: NSTableView, _ row: Int, _ rowData: Binding.RowDataType?) -> Bool> { return .name(TableView.Binding.shouldSelectRow) }
	static var shouldSelectTableColumn: TableViewName<(_ tableView: NSTableView, _ column: NSTableColumn?) -> Bool> { return .name(TableView.Binding.shouldSelectTableColumn) }
	static var shouldTypeSelectForEvent: TableViewName<(_ tableView: NSTableView, _ event: NSEvent, _ searchString: String?) -> Bool> { return .name(TableView.Binding.shouldTypeSelectForEvent) }
	static var sizeToFitWidthOfColumn: TableViewName<(_ tableView: NSTableView, _ column: NSUserInterfaceItemIdentifier) -> CGFloat> { return .name(TableView.Binding.sizeToFitWidthOfColumn) }
	static var sortDescriptorsDidChange: TableViewName<(NSTableView, [NSSortDescriptor]) -> Void> { return .name(TableView.Binding.sortDescriptorsDidChange) }
	static var typeSelectString: TableViewName<(_ tableView: NSTableView, _ cell: TableCell<Binding.RowDataType>) -> String?> { return .name(TableView.Binding.typeSelectString) }
	static var updateDraggingItems: TableViewName<(_ tableView: NSTableView, _ forDrag: NSDraggingInfo) -> Void> { return .name(TableView.Binding.updateDraggingItems) }
	static var validateDrop: TableViewName<(_ tableView: NSTableView, _ info: NSDraggingInfo, _ proposedRow: Int, _ proposedDropOperation: NSTableView.DropOperation) -> NSDragOperation> { return .name(TableView.Binding.validateDrop) }

	// Composite binding names
	static func doubleAction<Value>(_ keyPath: KeyPath<Binding.Preparer.Instance, Value>) -> TableViewName<SignalInput<Value>> {
		return Binding.keyPathActionName(keyPath, TableView.Binding.doubleAction, Binding.tableViewBinding)
	}
	static func cellSelected<Value>(_ keyPath: KeyPath<TableCell<Binding.RowDataType>, Value>) -> TableViewName<SignalInput<Value?>> {
		return Binding.compositeName(
			value: { (input: SignalInput<Value?>) in
				{ (notification: Notification) -> Void in
					guard let view = (notification.object as? NSTableView) else { return }
					let cell = TableCell<Binding.RowDataType>(row: view.selectedRow, column: view.selectedColumn, tableView: view)
					let value = cell?[keyPath: keyPath]
					_ = input.send(value: value)
				}
			},
			binding: TableView.Binding.selectionDidChange,
			downcast: Binding.tableViewBinding
		)
	}
	static func cellSelected(_ void: Void = ()) -> TableViewName<SignalInput<TableCell<Binding.RowDataType>?>> {
		return Binding.compositeName(
			value: { (input: SignalInput<TableCell<Binding.RowDataType>?>) in
				{ (notification: Notification) -> Void in
					guard let view = (notification.object as? NSTableView) else { return }
					let cell = TableCell<Binding.RowDataType>(row: view.selectedRow, column: view.selectedColumn, tableView: view)
					_ = input.send(value: cell)
				}
			},
			binding: TableView.Binding.selectionDidChange,
			downcast: Binding.tableViewBinding
		)
	}
	static func selectRow(_ void: Void = ()) -> TableViewName<Signal<Int?>> {
		return Binding.compositeName(
			value:
				{ (input: Signal<Int?>) in
					return input.map {
						$0.map { (indexes: IndexSet(integer: $0), byExtendingSelection: false) } ?? (indexes: IndexSet(), byExtendingSelection: false)
					}
				},
			binding: TableView.Binding.selectRows,
			downcast: Binding.tableViewBinding
		)
	}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol TableViewConvertible: ControlConvertible {
	func nsTableView() -> NSTableView
}
extension NSTableView: TableViewConvertible, HasDelegate {
	public func nsTableView() -> NSTableView { return self }
}
public extension TableViewConvertible {
	func nsControl() -> Control.Instance { return nsTableView() }
}
public extension TableView {
	func nsTableView() -> NSTableView { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol TableViewBinding: ControlBinding {
	associatedtype RowDataType
	static func tableViewBinding(_ binding: TableView<RowDataType>.Binding) -> Self
	func asTableViewBinding() -> TableView<RowDataType>.Binding?
}
public extension TableViewBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
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
public typealias TableRowMutation<Element> = SubrangeMutation<Element, ()>
public typealias TableRowAnimatable<Element> = Animatable<TableRowMutation<Element>, NSTableView.AnimationOptions>

public typealias TableRowState<Element> = SubrangeState<Element, ()>

public struct TableCell<RowData> {
	public let row: Int?
	public let column: Int?
	public let columnIdentifier: NSUserInterfaceItemIdentifier?
	public let data: RowData?
	
	public init?(row: Int, column: Int, tableView: NSTableView) {
		guard row >= 0 || column >= 0 else {
			return nil
		}
		self.row = row > 0 ? row : nil
		self.column = column > 0 ? column : nil
		self.columnIdentifier = tableView.tableColumns.at(column)?.identifier
		self.data = (tableView.delegate as? TableView<RowData>.Preparer.Storage)?.rowData(at: row)
	}
	
	public init?(row: Int, column: NSTableColumn, tableView: NSTableView) {
		self.init(row: row, column: tableView.column(withIdentifier: column.identifier), tableView: tableView)
	}
}

public extension Sequence {
	func tableData() -> TableRowAnimatable<Element> {
		return .set(.reload(Array(self)))
	}
}

public extension Signal {
	func tableData<RowData>(_ choice: AnimationChoice = .subsequent) -> Signal<TableRowAnimatable<RowData>> where IndexedMutation<RowData, ()> == OutputValue {
		return map(initialState: false) { (alreadyReceived: inout Bool, rowMutation: OutputValue) -> TableRowAnimatable<RowData> in
			if alreadyReceived || choice == .always {
				return .animate(TableRowMutation(kind: rowMutation.kind, metadata: nil, indexSet: rowMutation.indexSet, values: rowMutation.values), animation: .effectFade)
			} else {
				if choice == .subsequent {
					alreadyReceived = true
				}
				return .set(TableRowMutation(kind: rowMutation.kind, metadata: nil, indexSet: rowMutation.indexSet, values: rowMutation.values))
			}
		}
	}

	func tableData<RowData>(_ choice: AnimationChoice = .subsequent) -> Signal<TableRowAnimatable<RowData>> where TableRowMutation<RowData> == OutputValue {
		return map(initialState: false) { (alreadyReceived: inout Bool, rowMutation: OutputValue) -> TableRowAnimatable<RowData> in
			if alreadyReceived || choice == .always {
				return .animate(rowMutation, animation: .effectFade)
			} else {
				if choice == .subsequent {
					alreadyReceived = true
				}
				return .set(rowMutation)
			}
		}
	}
}

public extension Adapter where State == VarState<Int?> {
	func updateFirstRow() -> SignalInput<CountableRange<Int>> {
		return Input().map { $0.first }.bind(to: update())
	}
}

#endif

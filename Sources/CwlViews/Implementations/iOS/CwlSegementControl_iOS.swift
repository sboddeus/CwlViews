//
//  MyView.swift
//  CwlViews
//
//  Created by Sye Boddeus on 9/5/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

#if os(iOS)

import UIKit

// NOTE: If using this with the `internal` access CwlViews (e.g. Xcode app templates) then you'll need to remove the `public` access modifiers from this file.
// e.g. search for `public ` and replace with nothing.

// MARK: - Binder Part 1: Binder
public class SegmentedControl: Binder, SegmentControlConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension SegmentedControl {
	enum Binding: SegmentedControlBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.
		/* case someProperty(Constant<PropertyType>) */

		// 1. Value bindings may be applied at construction and may subsequently change.
		/* case someProperty(Dynamic<PropertyType>) */
        case backgroundImage(Dynamic<UIImage?>)
        case segments(Dynamic<[SegmentDescriptor]>)

		// 2. Signal bindings are performed on the object after construction.
		/* case someFunction(Signal<FunctionParametersAsTuple>) */

		// 3. Action bindings are triggered by the object after construction.
		/* case someAction(SignalInput<CallbackParameters>) */

		// 4. Delegate bindings require synchronous evaluation within the object's context.
		/* case someDelegateFunction((Param) -> Result)) */
	}
}

// MARK: - Binder Part 3: Preparer
public extension SegmentedControl {
	struct Preparer: BinderEmbedderConstructor /* or BinderDelegateEmbedderConstructor */ {
		public typealias Binding = SegmentedControl.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = UISegmentedControl
		
		/*
		// If instance construction requires parameters, uncomment this
		public typealias Parameters = (paramOne, paramTwo)
		*/
		
		public var inherited = Inherited()
		public init() {}
		
		/*
		// If Preparer is BinderDelegateEmbedderConstructor, use these instead of the `init` on the previous line
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		*/
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension SegmentedControl.Preparer {
	/* If instance construction requires parameters, uncomment this
	func constructInstance(type: Instance.Type, parameters: Preparer.Parameters) -> Instance {
		return type.init(paramOne: parameters.0, paramTwo: parameters.1)
	}
	*/

	/* Enable if delegate bindings used or setup prior to other bindings required 
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
		case .someDelegate(let x): delegate().addMultiHandler(x, #selector(someDelegateFunction))
		default: break
		}
	}
	*/

	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
        case .backgroundImage(let x):
            return x.apply(instance) { i, v in i.setBackgroundImage(v, for: .normal, barMetrics: .default) }
        case .segments(let x):
            return x.apply(instance) {i, v in
                var count = 0
                for segment in v {
                    i.insertSegment(withTitle: segment.title, at: segment.position, animated: true)
                    count += 1
                }
            }
		/* All bindings should have an "apply" (although some might simply return nil). Here are some typical examples... */
		/* case .someStatic(let x): instance.someStatic = x.value */
		/* case .someProperty(let x): return x.apply(instance) { i, v in i.someProperty = v } */
		/* case .someSignal(let x): return x.apply(instance) { i, v in i.something(v) } */
		/* case .someAction(let x): return instance.addListenerAndReturnLifetime(x) */
		/* case .someDelegate(let x): return nil */
        }
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension SegmentedControl.Preparer {
	public typealias Storage = Control.Preparer.Storage
	/*
	// Use instead of previous line if additional runtime storage is required
	open class Storage: Control.Preparer.Storage {}
	*/
	
	/*
	// Enable if Preparer is BinderDelegateEmbedderConstructor
	open class Delegate: DynamicDelegate, UISegmentControlDelegate {
		open func someDelegateFunction(_ segmentControl: UISegmentControlDelegate) -> Bool {
			return singleHandler(segmentControl)
		}
	}
	*/
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SegmentedControlBinding {
	public typealias SegmentControlName<V> = BindingName<V, SegmentedControl.Binding, Binding>
			private static func name<V>(_ source: @escaping (V) -> SegmentedControl.Binding) -> SegmentControlName<V> {
		return SegmentControlName<V>(source: source, downcast: Binding.segmentControlBinding)
	}
}
public extension BindingName where Binding: SegmentedControlBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SegmentControlName<$2> { return .name(SegmentControl.Binding.$1) }
    static var backgroundImage: SegmentControlName<Dynamic<UIImage?>> { return .name(SegmentedControl.Binding.backgroundImage) }
    static var segments: SegmentControlName<Dynamic<[SegmentDescriptor]>> { return .name(SegmentedControl.Binding.segments)}
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SegmentControlConvertible: ControlConvertible {
	func uiSegmentedControl() -> SegmentedControl.Instance
}
extension SegmentControlConvertible {
	public func uiControl() -> Control.Instance { return uiSegmentedControl() }
}
extension UISegmentedControl: SegmentControlConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func uiSegmentedControl() -> SegmentedControl.Instance { return self }
}
public extension SegmentedControl {
	func uiSegmentedControl() -> SegmentedControl.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SegmentedControlBinding: ControlBinding {
	static func segmentControlBinding(_ binding: SegmentedControl.Binding) -> Self
	func asSegmentControlBinding() -> SegmentedControl.Binding?
}
public extension SegmentedControlBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return segmentControlBinding(.inheritedBinding(binding))
	}
}
extension SegmentedControlBinding where Preparer.Inherited.Binding: SegmentedControlBinding {
	func asSegmentControlBinding() -> SegmentedControl.Binding? {
		return asInheritedBinding()?.asSegmentControlBinding()
	}
}
public extension SegmentedControl.Binding {
	typealias Preparer = SegmentedControl.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asSegmentControlBinding() -> SegmentedControl.Binding? { return self }
	static func segmentControlBinding(_ binding: SegmentedControl.Binding) -> SegmentedControl.Binding {
		return binding
	}
}

#endif
// MARK: - Binder Part 9: Other supporting types
public struct SegmentDescriptor {
    public let title: String
    public let position: Int
    
    public init(title: String, position: Int) {
        self.title = title
        self.position = position
    }
}

// MARK: - Binder Part 10: Test support
#if canImport(CwlViews)
	//extension BindingParser where Downcast: ViewSubclassBinding {
		// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
		// Replace: case ([^\(]+)\((.+)\)$
		// With:    public static var $1: BindingParser<$2, ViewSubclass.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asViewSubclassBinding() }) }
	//}
#endif
//
//  CwlScrollView_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/26.
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
public class ScrollView: Binder, ScrollViewConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension ScrollView {
	enum Binding: ScrollViewBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case panGestureRecognizerStyles(Constant<PanGestureRecognizer>)
		case pinchGestureRecognizerStyles(Constant<PinchGestureRecognizer>)
		
		// 1. Value bindings may be applied at construction and may subsequently change.
		case alwaysBounceHorizontal(Dynamic<Bool>)
		case alwaysBounceVertical(Dynamic<Bool>)
		case bounces(Dynamic<Bool>)
		case bouncesZoom(Dynamic<Bool>)
		case canCancelContentTouches(Dynamic<Bool>)
		case contentInset(Dynamic<UIEdgeInsets>)
		case contentInsetAdjustmentBehavior(Dynamic<UIScrollView.ContentInsetAdjustmentBehavior>)
		case contentOffset(Dynamic<SetOrAnimate<CGPoint>>)
		case contentSize(Dynamic<CGSize>)
		case decelerationRate(Dynamic<UIScrollView.DecelerationRate>)
		case delaysContentTouches(Dynamic<Bool>)
		case indicatorStyle(Dynamic<UIScrollView.IndicatorStyle>)
		case isDirectionalLockEnabled(Dynamic<Bool>)
		case isPagingEnabled(Dynamic<Bool>)
		case isScrollEnabled(Dynamic<Bool>)
		case maximumZoomScale(Dynamic<CGFloat>)
		case minimumZoomScale(Dynamic<CGFloat>)
		case scrollIndicatorInsets(Dynamic<UIEdgeInsets>)
		case scrollsToTop(Dynamic<Bool>)
		case showsHorizontalScrollIndicator(Dynamic<Bool>)
		case showsVerticalScrollIndicator(Dynamic<Bool>)
		case zoomScale(Dynamic<CGFloat>)
		
		@available(iOS 10.0, *) case refreshControl(Dynamic<UIRefreshControl?>)
		
		// 2. Signal bindings are performed on the object after construction.
		case flashScrollIndicators(Signal<Void>)
		case scrollRectToVisible(Signal<(rect: CGRect, animated: Bool)>)
		case zoom(Signal<(rect: CGRect, animated: Bool)>)
		
		// 3. Action bindings are triggered by the object after construction.
		case didEndDecelerating(SignalInput<CGPoint>)
		case didEndDragging(SignalInput<(CGPoint, Bool)>)
		case didEndScrollingAnimation(SignalInput<CGPoint>)
		case didEndZooming(SignalInput<CGFloat>)
		case didScroll(SignalInput<CGPoint>)
		case didScrollToTop(SignalInput<Void>)
		case didZoom(SignalInput<CGFloat>)
		case userDidScroll(SignalInput<CGPoint>)
		case willBeginDecelerating(SignalInput<Void>)
		case willBeginDragging(SignalInput<CGPoint>)
		case willBeginZooming(SignalInput<CGFloat>)
		
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case shouldScrollToTop((_ scrollView: UIScrollView) -> Bool)
		case viewForZooming((_ scrollView: UIScrollView) -> UIView?)
		case willEndDragging((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)
	}
}

// MARK: - Binder Part 3: Preparer
public extension ScrollView {
	struct Preparer: BinderDelegateEmbedderConstructor {
		public typealias Binding = ScrollView.Binding
		public typealias Inherited = View.Preparer
		public typealias Instance = UIScrollView
		
		public var inherited = Inherited()
		public var dynamicDelegate: Delegate? = nil
		public let delegateClass: Delegate.Type
		public init(delegateClass: Delegate.Type) {
			self.delegateClass = delegateClass
		}
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension ScrollView.Preparer {
	mutating func prepareBinding(_ binding: Binding) {
		switch binding {
		case .inheritedBinding(let x): inherited.prepareBinding(x)
			
		case .didEndDecelerating(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
		case .didEndDragging(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
		case .didEndScrollingAnimation(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation(_:)))
		case .didEndZooming(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidEndZooming(_:with:atScale:)))
		case .didScroll(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidScroll(_:)))
		case .didScrollToTop(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:)))
		case .didZoom(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewDidZoom(_:)))
		case .shouldScrollToTop(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewShouldScrollToTop(_:)))
		case .userDidScroll(let x):
			delegate().userDidScroll = x
			delegate().ensureHandler(for: #selector(UIScrollViewDelegate.scrollViewDidScrollToTop(_:)))
			delegate().ensureHandler(for: #selector(UIScrollViewDelegate.scrollViewDidEndDragging(_:willDecelerate:)))
			delegate().ensureHandler(for: #selector(UIScrollViewDelegate.scrollViewDidEndDecelerating(_:)))
		case .viewForZooming(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.viewForZooming(in:)))
		case .willBeginDecelerating(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillBeginDecelerating(_:)))
		case .willBeginDragging(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillBeginDragging(_:)))
		case .willBeginZooming(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillBeginZooming(_:with:)))
		case .willEndDragging(let x): delegate().addHandler(x, #selector(UIScrollViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:)))
		default: break
		}
	}
	
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)
			
		//	0. Static bindings are applied at construction and are subsequently immutable.
		case .panGestureRecognizerStyles(let x):
			x.value.apply(to: instance.panGestureRecognizer)
			return nil
		case .pinchGestureRecognizerStyles(let x):
			if let pgr = instance.pinchGestureRecognizer {
				x.value.apply(to: pgr)
			}
			return nil
			
		// 1. Value bindings may be applied at construction and may subsequently change.
		case .alwaysBounceHorizontal(let x): return x.apply(instance) { i, v in i.alwaysBounceHorizontal = v }
		case .alwaysBounceVertical(let x): return x.apply(instance) { i, v in i.alwaysBounceVertical = v }
		case .bounces(let x): return x.apply(instance) { i, v in i.bounces = v }
		case .bouncesZoom(let x): return x.apply(instance) { i, v in i.bouncesZoom = v }
		case .canCancelContentTouches(let x): return x.apply(instance) { i, v in i.canCancelContentTouches = v }
		case .contentInset(let x): return x.apply(instance) { i, v in i.contentInset = v }
		case .contentInsetAdjustmentBehavior(let x): return x.apply(instance) { i, v in i.contentInsetAdjustmentBehavior = v }
		case .contentOffset(let x): return x.apply(instance) { i, v in i.setContentOffset(v.value, animated: v.isAnimated) }
		case .contentSize(let x): return x.apply(instance) { i, v in i.contentSize = v }
		case .decelerationRate(let x): return x.apply(instance) { i, v in i.decelerationRate = v }
		case .delaysContentTouches(let x): return x.apply(instance) { i, v in i.delaysContentTouches = v }
		case .indicatorStyle(let x): return x.apply(instance) { i, v in i.indicatorStyle = v }
		case .isDirectionalLockEnabled(let x): return x.apply(instance) { i, v in i.isDirectionalLockEnabled = v }
		case .isPagingEnabled(let x): return x.apply(instance) { i, v in i.isPagingEnabled = v }
		case .isScrollEnabled(let x): return x.apply(instance) { i, v in i.isScrollEnabled = v }
		case .maximumZoomScale(let x): return x.apply(instance) { i, v in i.maximumZoomScale = v }
		case .minimumZoomScale(let x): return x.apply(instance) { i, v in i.minimumZoomScale = v }
		case .scrollIndicatorInsets(let x): return x.apply(instance) { i, v in i.scrollIndicatorInsets = v }
		case .scrollsToTop(let x): return x.apply(instance) { i, v in i.scrollsToTop = v }
		case .showsHorizontalScrollIndicator(let x): return x.apply(instance) { i, v in i.showsHorizontalScrollIndicator = v }
		case .showsVerticalScrollIndicator(let x): return x.apply(instance) { i, v in i.showsVerticalScrollIndicator = v }
		case .zoomScale(let x): return x.apply(instance) { i, v in i.zoomScale = v }
		
		case .refreshControl(let x):
			guard #available(iOS 10.0, *) else { return nil }
			return x.apply(instance) { i, v in i.refreshControl = v }
			
		// 2. Signal bindings are performed on the object after construction.
		case .flashScrollIndicators(let x): return x.apply(instance) { i, v in i.flashScrollIndicators() }
		case .scrollRectToVisible(let x): return x.apply(instance) { i, v in i.scrollRectToVisible(v.rect, animated: v.animated) }
		case .zoom(let x): return x.apply(instance) { i, v in i.zoom(to: v.rect, animated: v.animated) }
			
		// 3. Action bindings are triggered by the object after construction.
		case .didEndDecelerating: return nil
		case .didEndDragging: return nil
		case .didEndScrollingAnimation: return nil
		case .didEndZooming: return nil
		case .didScroll: return nil
		case .didScrollToTop: return nil
		case .didZoom: return nil
		case .userDidScroll: return nil
		case .willBeginDecelerating: return nil
		case .willBeginDragging: return nil
		case .willBeginZooming: return nil
			
		// 4. Delegate bindings require synchronous evaluation within the object's context.
		case .shouldScrollToTop: return nil
		case .viewForZooming: return nil
		case .willEndDragging: return nil
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension ScrollView.Preparer {
	open class Storage: View.Preparer.Storage, UIScrollViewDelegate {}
	
	open class Delegate: DynamicDelegate, UIScrollViewDelegate {
		open var userDidScroll: SignalInput<CGPoint>?
		
		open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
			if !decelerate {
				userDidScroll?.send(value: scrollView.contentOffset)
			}
			handler(ofType: SignalInput<(CGPoint, Bool)>.self)?.send(value: (scrollView.contentOffset, decelerate))
		}
		
		open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
			userDidScroll?.send(value: scrollView.contentOffset)
			handler(ofType: SignalInput<Void>.self)?.send(value: ())
		}
		
		open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
			userDidScroll?.send(value: scrollView.contentOffset)
			handler(ofType: SignalInput<CGPoint>.self)?.send(value: scrollView.contentOffset)
		}
		
		open var didScroll: SignalInput<CGPoint>?
		open func scrollViewDidScroll(_ scrollView: UIScrollView) {
			didScroll?.send(value: scrollView.contentOffset)
		}
		
		open func scrollViewDidZoom(_ scrollView: UIScrollView) {
			handler(ofType: SignalInput<CGFloat>.self)!.send(value: scrollView.zoomScale)
		}
		
		open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
			handler(ofType: SignalInput<CGPoint>.self)!.send(value: scrollView.contentOffset)
		}
		
		open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
			handler(ofType: SignalInput<Void>.self)!.send(value: ())
		}
		
		open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
			handler(ofType: SignalInput<CGFloat>.self)!.send(value: scrollView.contentScaleFactor)
		}
		
		open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
			handler(ofType: SignalInput<CGFloat>.self)!.send(value: scale)
		}
		
		open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
			handler(ofType: SignalInput<CGPoint>.self)!.send(value: scrollView.contentOffset)
		}
		
		open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
			handler(ofType: ((UIScrollView, CGPoint, UnsafeMutablePointer<CGPoint>) -> Void).self)!(scrollView, velocity, targetContentOffset)
		}
		
		open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
			return handler(ofType: ((UIScrollView) -> Bool).self)!(scrollView)
		}
		
		open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
			return handler(ofType: ((UIScrollView) -> UIView?).self)!(scrollView)
		}
	}
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: ScrollViewBinding {
	public typealias ScrollViewName<V> = BindingName<V, ScrollView.Binding, Binding>
	private typealias B = ScrollView.Binding
	private static func name<V>(_ source: @escaping (V) -> ScrollView.Binding) -> ScrollViewName<V> {
		return ScrollViewName<V>(source: source, downcast: Binding.scrollViewBinding)
	}
}
public extension BindingName where Binding: ScrollViewBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: ScrollViewName<$2> { return .name(B.$1) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol ScrollViewConvertible: ViewConvertible {
	func uiScrollView() -> ScrollView.Instance
}
extension ScrollViewConvertible {
	public func uiView() -> View.Instance { return uiScrollView() }
}
extension UIScrollView: ScrollViewConvertible, HasDelegate {
	public func uiScrollView() -> ScrollView.Instance { return self }
}
public extension ScrollView {
	func uiScrollView() -> ScrollView.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol ScrollViewBinding: ViewBinding {
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> Self
}
public extension ScrollViewBinding {
	static func viewBinding(_ binding: View.Binding) -> Self {
		return scrollViewBinding(.inheritedBinding(binding))
	}
}
public extension ScrollView.Binding {
	public typealias Preparer = ScrollView.Preparer
	static func scrollViewBinding(_ binding: ScrollView.Binding) -> ScrollView.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif
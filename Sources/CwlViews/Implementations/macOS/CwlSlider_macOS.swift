//
//  CwlSlider_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/4/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
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
public class Slider: Binder, SliderConvertible {
	public var state: BinderState<Preparer>
	public required init(type: Preparer.Instance.Type, parameters: Preparer.Parameters, bindings: [Preparer.Binding]) {
		state = .pending(type: type, parameters: parameters, bindings: bindings)
	}
}

// MARK: - Binder Part 2: Binding
public extension Slider {
	enum Binding: SliderBinding {
		case inheritedBinding(Preparer.Inherited.Binding)
		
		// 0. Static bindings are applied at construction and are subsequently immutable.

		// 1. Value bindings may be applied at construction and may subsequently change.
		case allowsTickMarkValuesOnly(Dynamic<Bool>)
		case altIncrementValue(Dynamic<Double>)
		case isVertical(Dynamic<Bool>)
		case maxValue(Dynamic<Double>)
		case minValue(Dynamic<Double>)
		case numberOfTickMarks(Dynamic<Int>)
		case sliderType(Dynamic<NSSlider.SliderType>)
		case tickMarkPosition(Dynamic<NSSlider.TickMarkPosition>)
		case trackFillColor(Dynamic<NSColor?>)

		// 2. Signal bindings are performed on the object after construction.

		// 3. Action bindings are triggered by the object after construction.

		// 4. Delegate bindings require synchronous evaluation within the object's context.
	}
}

// MARK: - Binder Part 3: Preparer
public extension Slider {
	struct Preparer: BinderEmbedderConstructor {
		public typealias Binding = Slider.Binding
		public typealias Inherited = Control.Preparer
		public typealias Instance = NSSlider
		
		public var inherited = Inherited()
		public init() {}
		
		public func constructStorage(instance: Instance) -> Storage { return Storage() }
		public func inheritedBinding(from: Binding) -> Inherited.Binding? {
			if case .inheritedBinding(let b) = from { return b } else { return nil }
		}
	}
}

// MARK: - Binder Part 4: Preparer overrides
public extension Slider.Preparer {
	func applyBinding(_ binding: Binding, instance: Instance, storage: Storage) -> Lifetime? {
		switch binding {
		case .inheritedBinding(let x): return inherited.applyBinding(x, instance: instance, storage: storage)

		case .allowsTickMarkValuesOnly(let x): return x.apply(instance) { i, v in i.allowsTickMarkValuesOnly = v }
		case .altIncrementValue(let x): return x.apply(instance) { i, v in i.altIncrementValue = v }
		case .isVertical(let x): return x.apply(instance) { i, v in i.isVertical = v }
		case .maxValue(let x): return x.apply(instance) { i, v in i.maxValue = v }
		case .minValue(let x): return x.apply(instance) { i, v in i.minValue = v }
		case .numberOfTickMarks(let x): return x.apply(instance) { i, v in i.numberOfTickMarks = v }
		case .sliderType(let x): return x.apply(instance) { i, v in i.sliderType = v }
		case .tickMarkPosition(let x): return x.apply(instance) { i, v in i.tickMarkPosition = v }
		case .trackFillColor(let x): return x.apply(instance) { i, v in i.trackFillColor = v }
		}
	}
}

// MARK: - Binder Part 5: Storage and Delegate
extension Slider.Preparer {
	public typealias Storage = Control.Preparer.Storage
}

// MARK: - Binder Part 6: BindingNames
extension BindingName where Binding: SliderBinding {
	public typealias SliderName<V> = BindingName<V, Slider.Binding, Binding>
	private static func name<V>(_ source: @escaping (V) -> Slider.Binding) -> SliderName<V> {
		return SliderName<V>(source: source, downcast: Binding.sliderBinding)
	}
}
public extension BindingName where Binding: SliderBinding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: SliderName<$2> { return .name(Slider.Binding.$1) }

	static var allowsTickMarkValuesOnly: SliderName<Dynamic<Bool>> { return .name(Slider.Binding.allowsTickMarkValuesOnly) }
	static var altIncrementValue: SliderName<Dynamic<Double>> { return .name(Slider.Binding.altIncrementValue) }
	static var isVertical: SliderName<Dynamic<Bool>> { return .name(Slider.Binding.isVertical) }
	static var maxValue: SliderName<Dynamic<Double>> { return .name(Slider.Binding.maxValue) }
	static var minValue: SliderName<Dynamic<Double>> { return .name(Slider.Binding.minValue) }
	static var numberOfTickMarks: SliderName<Dynamic<Int>> { return .name(Slider.Binding.numberOfTickMarks) }
	static var sliderType: SliderName<Dynamic<NSSlider.SliderType>> { return .name(Slider.Binding.sliderType) }
	static var tickMarkPosition: SliderName<Dynamic<NSSlider.TickMarkPosition>> { return .name(Slider.Binding.tickMarkPosition) }
	static var trackFillColor: SliderName<Dynamic<NSColor?>> { return .name(Slider.Binding.trackFillColor) }
}

// MARK: - Binder Part 7: Convertible protocols (if constructible)
public protocol SliderConvertible: ControlConvertible {
	func nsSlider() -> Slider.Instance
}
extension SliderConvertible {
	public func nsControl() -> Control.Instance { return nsSlider() }
}
extension NSSlider: SliderConvertible /* , HasDelegate // if Preparer is BinderDelegateEmbedderConstructor */ {
	public func nsSlider() -> Slider.Instance { return self }
}
public extension Slider {
	func nsSlider() -> Slider.Instance { return instance() }
}

// MARK: - Binder Part 8: Downcast protocols
public protocol SliderBinding: ControlBinding {
	static func sliderBinding(_ binding: Slider.Binding) -> Self
	func asSliderBinding() -> Slider.Binding?
}
public extension SliderBinding {
	static func controlBinding(_ binding: Control.Binding) -> Self {
		return sliderBinding(.inheritedBinding(binding))
	}
}
public extension SliderBinding where Preparer.Inherited.Binding: SliderBinding {
	func asSliderBinding() -> Slider.Binding? {
		return asInheritedBinding()?.asSliderBinding()
	}
}
public extension Slider.Binding {
	typealias Preparer = Slider.Preparer
	func asInheritedBinding() -> Preparer.Inherited.Binding? { if case .inheritedBinding(let b) = self { return b } else { return nil } }
	func asSliderBinding() -> Slider.Binding? { return self }
	static func sliderBinding(_ binding: Slider.Binding) -> Slider.Binding {
		return binding
	}
}

// MARK: - Binder Part 9: Other supporting types

#endif

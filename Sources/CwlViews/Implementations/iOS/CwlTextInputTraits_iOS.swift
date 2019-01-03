//
//  CwlTextInputTraits_iOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/04/18.
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

/// A type that hold an array of UITextInputTraits in a binding-like manner so they can be constructed using BindingName syntax.
/// This type is not implemented as a binder because it does not construct an instance or binder storage. It is a helper-type used by other binders that conform to the UITextInputTraits protocol.
public struct TextInputTraits {
	let bindings: [Binding]
	public init(bindings: [Binding]) {
		self.bindings = bindings
	}
	public init(_ bindings: Binding...) {
		self.init(bindings: bindings)
	}
	
	public enum Binding {
		case autocapitalizationType(Dynamic<UITextAutocapitalizationType>)
		case autocorrectionType(Dynamic<UITextAutocorrectionType>)
		case enablesReturnKeyAutomatically(Dynamic<Bool>)
		case isSecureTextEntry(Dynamic<Bool>)
		case keyboardAppearance(Dynamic<UIKeyboardAppearance>)
		case keyboardType(Dynamic<UIKeyboardType>)
		case returnKeyType(Dynamic<UIReturnKeyType>)
		case spellCheckingType(Dynamic<UITextSpellCheckingType>)
		
		@available(iOS 11.0, *) case smartDashesType(Dynamic<UITextSmartDashesType>)
		@available(iOS 11.0, *) case smartInsertDeleteType(Dynamic<UITextSmartInsertDeleteType>)
		@available(iOS 11.0, *) case smartQuotesType(Dynamic<UITextSmartQuotesType>)
		@available(iOS 10.0, *) case textContentType(Dynamic<UITextContentType>)
	}
	
	// No, you're not seeing things, this is one method, copy and pasted three times with a different instance parameter type.
	// Unfortunately, optional Objective-C vars – as used in the UITextInputTraits protocol – don't work in Swift, so everything must be done manually, instead.
	public func apply(to instance: UISearchBar) -> Lifetime? {
		return AggregateLifetime(lifetimes: bindings.lazy.compactMap { trait in
			switch trait {
			case .autocapitalizationType(let x): return x.apply(instance) { i, v in i.autocapitalizationType = v }
			case .autocorrectionType(let x): return x.apply(instance) { i, v in i.autocorrectionType = v }
			case .spellCheckingType(let x): return x.apply(instance) { i, v in i.spellCheckingType = v }
			case .enablesReturnKeyAutomatically(let x): return x.apply(instance) { i, v in i.enablesReturnKeyAutomatically = v }
			case .keyboardAppearance(let x): return x.apply(instance) { i, v in i.keyboardAppearance = v }
			case .keyboardType(let x): return x.apply(instance) { i, v in i.keyboardType = v }
			case .returnKeyType(let x): return x.apply(instance) { i, v in i.returnKeyType = v }
			case .isSecureTextEntry(let x): return x.apply(instance) { i, v in i.isSecureTextEntry = v }
			case .textContentType(let x):
				guard #available(iOS 10.0, *) else { return nil }
				return x.apply(instance) { i, v in i.textContentType = v }
			case .smartDashesType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartDashesType = v }
			case .smartQuotesType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartQuotesType = v }
			case .smartInsertDeleteType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartInsertDeleteType = v }
			}
		})
	}
	
	// No, you're not seeing things, this is one method, copy and pasted three times with a different instance parameter type.
	// Unfortunately, optional Objective-C vars – as used in the UITextInputTraits protocol – don't work in Swift 4.2, so everything must be done manually, instead.
	public func apply(to instance: UITextField) -> Lifetime? {
		return AggregateLifetime(lifetimes: bindings.lazy.compactMap { trait in
			switch trait {
			case .autocapitalizationType(let x): return x.apply(instance) { i, v in i.autocapitalizationType = v }
			case .autocorrectionType(let x): return x.apply(instance) { i, v in i.autocorrectionType = v }
			case .spellCheckingType(let x): return x.apply(instance) { i, v in i.spellCheckingType = v }
			case .enablesReturnKeyAutomatically(let x): return x.apply(instance) { i, v in i.enablesReturnKeyAutomatically = v }
			case .keyboardAppearance(let x): return x.apply(instance) { i, v in i.keyboardAppearance = v }
			case .keyboardType(let x): return x.apply(instance) { i, v in i.keyboardType = v }
			case .returnKeyType(let x): return x.apply(instance) { i, v in i.returnKeyType = v }
			case .isSecureTextEntry(let x): return x.apply(instance) { i, v in i.isSecureTextEntry = v }
			case .textContentType(let x):
				guard #available(iOS 10.0, *) else { return nil }
				return x.apply(instance) { i, v in i.textContentType = v }
			case .smartDashesType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartDashesType = v }
			case .smartQuotesType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartQuotesType = v }
			case .smartInsertDeleteType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartInsertDeleteType = v }
			}
		})
	}
	
	// No, you're not seeing things, this is one method, copy and pasted three times with a different instance parameter type.
	// Unfortunately, Objective-C protocols with optional, settable vars – as used in the UITextInputTraits protocol – don't work in Swift 4.2, so everything must be done manually, instead.
	public func apply(to instance: UITextView) -> Lifetime? {
		return AggregateLifetime(lifetimes: bindings.lazy.compactMap { trait in
			switch trait {
			case .autocapitalizationType(let x): return x.apply(instance) { i, v in i.autocapitalizationType = v }
			case .autocorrectionType(let x): return x.apply(instance) { i, v in i.autocorrectionType = v }
			case .spellCheckingType(let x): return x.apply(instance) { i, v in i.spellCheckingType = v }
			case .enablesReturnKeyAutomatically(let x): return x.apply(instance) { i, v in i.enablesReturnKeyAutomatically = v }
			case .keyboardAppearance(let x): return x.apply(instance) { i, v in i.keyboardAppearance = v }
			case .keyboardType(let x): return x.apply(instance) { i, v in i.keyboardType = v }
			case .returnKeyType(let x): return x.apply(instance) { i, v in i.returnKeyType = v }
			case .isSecureTextEntry(let x): return x.apply(instance) { i, v in i.isSecureTextEntry = v }
			case .textContentType(let x):
				guard #available(iOS 10.0, *) else { return nil }
				return x.apply(instance) { i, v in i.textContentType = v }
			case .smartDashesType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartDashesType = v }
			case .smartQuotesType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartQuotesType = v }
			case .smartInsertDeleteType(let x):
				guard #available(iOS 11.0, *) else { return nil }
				return x.apply(instance) { i, v in i.smartInsertDeleteType = v }
			}
		})
	}
}

extension BindingName where Source == Binding, Binding == TextInputTraits.Binding {
	// NOTE: for some reason, any attempt at a TextInputTraitsName typealias led to a compiler crash so the explicit BindingName<V, TextInputTraits.Binding, TextInputTraits.Binding> must be used instead.
	private typealias B = TextInputTraits.Binding
	private static func name<V>(_ source: @escaping (V) -> TextInputTraits.Binding) -> BindingName<V, TextInputTraits.Binding, TextInputTraits.Binding> {
		return BindingName<V, TextInputTraits.Binding, TextInputTraits.Binding>(source: source, downcast: { b in b})
	}
}
public extension BindingName where Source == Binding, Binding == TextInputTraits.Binding {
	// You can easily convert the `Binding` cases to `BindingName` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    static var $1: BindingName<$2> { return .name(B.$1) }
	static var autocapitalizationType: BindingName<Dynamic<UITextAutocapitalizationType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.autocapitalizationType) }
	static var autocorrectionType: BindingName<Dynamic<UITextAutocorrectionType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.autocorrectionType) }
	static var enablesReturnKeyAutomatically: BindingName<Dynamic<Bool>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.enablesReturnKeyAutomatically) }
	static var isSecureTextEntry: BindingName<Dynamic<Bool>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.isSecureTextEntry) }
	static var keyboardAppearance: BindingName<Dynamic<UIKeyboardAppearance>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.keyboardAppearance) }
	static var keyboardType: BindingName<Dynamic<UIKeyboardType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.keyboardType) }
	static var returnKeyType: BindingName<Dynamic<UIReturnKeyType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.returnKeyType) }
	static var spellCheckingType: BindingName<Dynamic<UITextSpellCheckingType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.spellCheckingType) }
	
	@available(iOS 11.0, *) static var smartDashesType: BindingName<Dynamic<UITextSmartDashesType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.smartDashesType) }
	@available(iOS 11.0, *) static var smartInsertDeleteType: BindingName<Dynamic<UITextSmartInsertDeleteType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.smartInsertDeleteType) }
	@available(iOS 11.0, *) static var smartQuotesType: BindingName<Dynamic<UITextSmartQuotesType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.smartQuotesType) }
	@available(iOS 10.0, *) static var textContentType: BindingName<Dynamic<UITextContentType>, TextInputTraits.Binding, TextInputTraits.Binding> { return .name(B.textContentType) }
}

#endif
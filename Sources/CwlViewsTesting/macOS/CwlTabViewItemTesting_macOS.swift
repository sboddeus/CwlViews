//
//  CwlTabViewItem_macOS.swift
//  CwlViews
//
//  Created by Matt Gallagher on 30/3/19.
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

extension BindingParser where Downcast: TabViewItemBinding {
	// You can easily convert the `Binding` cases to `BindingParser` using the following Xcode-style regex:
	// Replace: case ([^\(]+)\((.+)\)$
	// With:    public static var $1: BindingParser<$2, TabViewItem.Binding, Downcast> { return .init(extract: { if case .$1(let x) = \$0 { return x } else { return nil } }, upcast: { \$0.asTabViewItemBinding() }) }
		
	// 0. Static bindings are applied at construction and are subsequently immutable.

	// 1. Value bindings may be applied at construction and may subsequently change.
	public static var color: BindingParser<Dynamic<NSColor>, TabViewItem.Binding, Downcast> { return .init(extract: { if case .color(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewItemBinding() }) }
	public static var image: BindingParser<Dynamic<NSImage?>, TabViewItem.Binding, Downcast> { return .init(extract: { if case .image(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewItemBinding() }) }
	public static var initialFirstResponderTag: BindingParser<Dynamic<Int>, TabViewItem.Binding, Downcast> { return .init(extract: { if case .initialFirstResponderTag(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewItemBinding() }) }
	public static var label: BindingParser<Dynamic<String>, TabViewItem.Binding, Downcast> { return .init(extract: { if case .label(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewItemBinding() }) }
	public static var toolTip: BindingParser<Dynamic<String>, TabViewItem.Binding, Downcast> { return .init(extract: { if case .toolTip(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewItemBinding() }) }
	public static var view: BindingParser<Dynamic<ViewConvertible>, TabViewItem.Binding, Downcast> { return .init(extract: { if case .view(let x) = $0 { return x } else { return nil } }, upcast: { $0.asTabViewItemBinding() }) }
	
	// 2. Signal bindings are performed on the object after construction.
	
	// 3. Action bindings are triggered by the object after construction.
	
	// 4. Delegate bindings require synchronous evaluation within the object's context.
}

#endif

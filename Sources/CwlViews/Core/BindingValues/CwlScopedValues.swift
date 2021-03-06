//
//  ScopedValues.swift
//  CwlViews
//
//  Created by Matt Gallagher on 2017/03/23.
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

import Foundation

public struct ScopedValues<Scope, Value>: ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = ScopedValues<Scope, Value>

	public let pairs: [(scope: Scope, value: Value)]
	
	public init(arrayLiteral elements: ScopedValues<Scope, Value>...) {
		self.pairs = elements.flatMap { $0.pairs }
	}
	
	public init(pairs: [(Scope, Value)]) {
		self.pairs = pairs
	}
	
	public init(scope: Scope, value: Value) {
		self.pairs = [(scope, value)]
	}
	
	public static func value(_ value: Value, for scope: Scope) -> ScopedValues<Scope, Value> {
		return ScopedValues(scope: scope, value: value)
	}
}

extension Dynamic {
	// Gets the subsequent (i.e. after construction) values from the `Dynamic`
	public func apply<I: AnyObject, Scope, V>(instance: I, removeOld: @escaping (I, Scope, V) -> Void, applyNew: @escaping (I, Scope, V) -> Void) -> Lifetime? where ScopedValues<Scope, V> == Value {
		var previous: ScopedValues<Scope, V>? = nil
		return apply(instance) { i, v in
			for (scope, value) in previous?.pairs ?? [] {
				removeOld(instance, scope, value)
			}
			previous = v
			for (scope, value) in v.pairs {
				applyNew(instance, scope, value)
			}
		}
	}
}

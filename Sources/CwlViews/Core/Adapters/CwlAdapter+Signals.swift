//
//  CwlAdapter+Signals.swift
//  CwlViews
//
//  Created by Matt Gallagher on 15/1/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

public extension Adapter {
	
	func encoded(formatting: JSONEncoder.OutputFormatting = .prettyPrinted) -> Signal<Data> {
		return codableValueChanged.startWith(()).transform { _ in Signal<Data>.Next.single(Result<Data, Error> { () throws -> Data in
			let enc = JSONEncoder()
			enc.outputFormatting = formatting
			return try enc.encode(self)
		}.mapFailure(SignalEnd.other) ) }
	}
	
	var message: SignalInput<State.Message> { return multiInput }
}

extension Signal where OutputValue == Data {

	public func logJson(prefix: String = "") -> SignalOutput<Data> {
		return subscribeValues { data in
			if let string = String(data: data, encoding: .utf8) {
				print("\(prefix)\(string)")
			}
		}
	}

}

extension Signal where OutputValue == String {
}

extension Adapter: SignalInputInterface {

	public var input: SignalInput<State.DefaultMessage> {
		if let i = multiInput as? SignalInput<State.DefaultMessage>  {
			return i
		} else {
			return Input<State.DefaultMessage>().map(State.message).bind(to: multiInput)
		}
	}
	
}

extension Adapter where State: SingleValueAdapterState {

	/// Access to `state` values emitted from `combinedSignal`.
	public var state: Signal<State> {
		return combinedSignal.compactMap { content in content.state }
	}
	
}

/// If `withMutableState` is called re-entrantly (i.e. already inside the `ModelState`'s mutex) then the underlying `combinedSignal` will not emit synchronously and the `withMutableState` function will throw this error.
public struct AdapterFailedToEmit: Error {}

extension Adapter: CodableContainer {
	public init(from decoder: Decoder) throws {
		let c = try decoder.singleValueContainer()
		let p = try c.decode(State.self)
		self.init(adapterState: p)
	}
	
	public func encode(to encoder: Encoder) throws {
		if let s = combinedSignal.peek()?.state {
			var c = encoder.singleValueContainer()
			try c.encode(s)
		}
	}
	
	public var childCodableContainers: [CodableContainer] {
		return (combinedSignal.peek()?.state as? CodableContainer)?.childCodableContainers ?? []
	}
	
	public var codableValueChanged: Signal<Void> {
		if State.self is CodableContainer.Type {
			return combinedSignal.flatMapLatest { (content: State.Output) -> Signal<Void> in
				let cc = content.state as! CodableContainer
				return cc.codableValueChanged.startWith(())
			}.dropActivation()
		}
		return combinedSignal.map { _ in () }.dropActivation()
	}
	
	public func cancel() {
		if State.self is CodableContainer.Type, let value = combinedSignal.peek()?.state, var sc = value as? CodableContainer {
			sc.cancel()
		}
		input.cancel()
	}
}

//
//  SliderView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Matt Gallagher on 10/2/19.
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

import CwlViews

struct SliderViewState: CodableContainer {
	let value: Var<Float>
	init() {
		value = Var(.initial)
	}
}

func sliderView(_ sliderViewState: SliderViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(marginEdges: .allLayout,
				.view(
					Label(
						.text <-- sliderViewState.value.allChanges().map { .localizedStringWithFormat(.valueFormat, $0, Float.max) },
						.font -- UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .regular)
					)
				),
				.space(),
				.view(
					Slider(
						.isContinuous -- true,
						.minimumValue -- .min,
						.maximumValue -- .max,
						.value <-- sliderViewState.value.animate(),
						.action(.valueChanged, \.value) --> sliderViewState.value.update()
					)
				)
			)
		)
	)
}

private extension Float {
	static let min: Float = 0
	static let max: Float = 500
	static let initial: Float = 100
}

private extension String {
	static let valueFormat = NSLocalizedString("%.1f of %.1f", comment: "")
}

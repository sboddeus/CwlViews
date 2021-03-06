//
//  SegmentedControlView.swift
//  CwlViewsCatalog_iOS
//
//  Created by Sye Boddeus on 9/5/19.
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

struct SegmentedViewState: CodableContainer {
	let indexValue: Var<Int>
	init() {
		indexValue = Var(1)
	}
}

func segmentedControlView(_ viewState: SegmentedViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				marginEdges: .allLayout,
				length: .equalTo(constant: 100.0),
				breadth: .equalTo(constant: 400.0),
				.vertical(
					align: .center,
					.view(Label(.text <-- viewState.indexValue.allChanges().map { value in "\(value)" })),
					.space(),
					.view(
						SegmentedControl(
							.momentary -- false,
							.selectItem <-- viewState.indexValue,
							.tintColor -- .red,
							.contentPositionAdjustment -- .right(UIOffset(horizontal: 5, vertical: 5)),
							.dividerImage -- .value(
								.drawn(width: 10, height: 10) { $0.fillEllipse(in: $1) },
								for: LeftRightControlStateAndMetrics()
							),
							.action(.valueChanged, \.selectedSegmentIndex) --> viewState.indexValue.update(),
							.segments -- [
								.title("0", width: 40),
								.title("1", width: 40),
								.title("2", width: 40, enabled: false),
								.title("3", width: 40)
							]
						)
					)
				)
			)
		)
	)
}

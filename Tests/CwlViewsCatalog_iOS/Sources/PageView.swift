//
//  PageView.swift
//  CwlViews
//
//  Created by Matt Gallagher on 10/2/19.
//  Copyright © 2019 Matt Gallagher ( https://www.cocoawithlove.com ). All rights reserved.
//

import CwlViews

struct PageViewState: CodableContainer {
	init() {
	}
}

func pageView(_ pageViewState: PageViewState, _ navigationItem: NavigationItem) -> ViewControllerConvertible {
	return ViewController(
		.navigationItem -- navigationItem,
		.view -- View(
			.backgroundColor -- .white,
			.layout -- .center(
				.view(Label(.text -- CatalogName.pageViewController.rawValue))
			)
		)
	)
}
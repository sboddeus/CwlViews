//
//  ImageView.swift
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

struct ImageViewState: CodableContainer {
	init() {
	}
}

func imageView(_ imageViewState: ImageViewState) -> ViewConvertible {
	return View(
		.layer -- Layer(.backgroundColor -- NSColor.lightGray.cgColor),
		.layout -- .center(
			.view(
				breadth: .equalTo(ratio: 1.0),
				relativity: .breadthRelativeToLength,
				ImageView(
					.image -- .drawn(width: 512, height: 512, drawIcon),
					.verticalContentCompressionResistancePriority -- .layoutMid,
					.horizontalContentCompressionResistancePriority -- .layoutMid
				)
			),
			.space(),
			.view(
				TextField.label(
					.stringValue -- .captionText,
					.maximumNumberOfLines -- 0,
					.textColor -- .white,
					.alignment -- .center,
					.horizontalContentCompressionResistancePriority -- .layoutLow
				)
			)
		)
	)
}

func drawIcon(context: CGContext, canvas: CGRect) {
	let unit = min(canvas.width, canvas.height)
	let bounds = CGRect(x: 0, y: 0, width: unit, height: unit).insetBy(dx: unit * 0.03125, dy: unit * 0.03125)
	let graySpace = CGColorSpaceCreateDeviceGray()
	let colorSpace = CGColorSpaceCreateDeviceRGB()
	
	// Background shadow
	#if os(macOS)
		context.setShadow(offset: CGSize(width: 0, height: -unit * 0.015625), blur: unit * 0.0234375, color: CGColor(colorSpace: graySpace, components: [0.0, 0.75]))
	#else
		context.setShadow(offset: CGSize(width: 0, height: unit * 0.015625), blur: unit * 0.0234375, color: CGColor(colorSpace: graySpace, components: [0.0, 0.75]))
	#endif
	context.setFillColor(gray: 0.9, alpha: 1.0)
	context.fillEllipse(in: bounds)
	context.setShadow(offset: .zero, blur: 0)
	
	// Gradient vertical gradient
	context.saveGState()
	context.addEllipse(in: bounds)
	context.clip()
	context.drawLinearGradient(CGGradient(colorSpace: graySpace, colorComponents: [1.0, 1.0, 0.82, 1.0], locations: nil, count: 2)!, start: .zero, end: CGPoint(x: 0, y: unit), options: [])
	context.restoreGState()
	
	// Black center, inset within larger circle
	let ellipseCenter = bounds.insetBy(dx: unit * 0.03125, dy: unit * 0.03125)
	context.setFillColor(gray: 0, alpha: 1)
	context.fillEllipse(in: ellipseCenter)
	
	// Three glows drawn over top of each other to create the amorphous blue glowing backdrop
	context.saveGState()
	context.addEllipse(in: ellipseCenter)
	context.clip()
	let bottomGlow = CGGradient(
		colorSpace: colorSpace,
		colorComponents: [
			0.0, 0.94, 0.82, 1.0,
			0.0, 0.62, 0.56, 1.0,
			0.0, 0.05, 0.35, 1.0,
			0.0, 0.00, 0.00, 1.0
		],
		locations: [0.0, 0.35, 0.60, 0.7],
		count: 4
		)!
	let bottomCenter = CGPoint(x: ellipseCenter.midX, y: ellipseCenter.midY + ellipseCenter.height * 0.1)
	context.drawRadialGradient(bottomGlow, startCenter: bottomCenter, startRadius: 0, endCenter: bottomCenter, endRadius: ellipseCenter.height * 0.8, options: [])
	let topGlow = CGGradient(
		colorSpace: colorSpace,
		colorComponents: [
			0.0, 0.68, 1.00, 0.75,
			0.0, 0.45, 0.62, 0.55,
			0.0, 0.45, 0.62, 0.00
		],
		locations: [0.0, 0.25, 0.40],
		count: 3
		)!
	let topCenter = CGPoint(x: ellipseCenter.midX, y: ellipseCenter.midY - ellipseCenter.height * 0.2)
	context.drawRadialGradient(topGlow, startCenter: topCenter, startRadius: 0, endCenter: topCenter, endRadius: ellipseCenter.height * 0.8, options: [])
	let centerGlow = CGGradient(colorSpace: colorSpace, colorComponents: [
		0.0, 0.90, 0.90, 0.90,
		0.0, 0.49, 1.00, 0.00
		], locations: [0.0, 0.85], count: 2)!
	let center = CGPoint(x: ellipseCenter.midX, y: ellipseCenter.midY)
	context.drawRadialGradient(centerGlow, startCenter: center, startRadius: 0, endCenter: center, endRadius: ellipseCenter.height * 0.8, options: [])
	context.restoreGState()
	
	// Draw the floral heart glyph
	context.setShadow(offset: .zero, blur: unit * 0.0234375, color: CGColor(colorSpace: graySpace, components: [0, 1]))
	#if os(macOS)
		let floralHeart = CTLineCreateWithAttributedString(NSAttributedString(string: "\u{2766}", attributes: [.foregroundColor: NSColor(white: 0.9, alpha: 1)]))
		let floralHeartBounds = CTLineGetBoundsWithOptions(floralHeart, [])
		let scale = 0.75 * unit / floralHeartBounds.height
	#else
		let floralHeart = CTLineCreateWithAttributedString(NSAttributedString(string: "\u{2766}", attributes: [.foregroundColor: UIColor(white: 0.9, alpha: 1)]))
		let floralHeartBounds = CTLineGetBoundsWithOptions(floralHeart, [])
		let scale = unit / floralHeartBounds.height
	#endif
	context.saveGState()
	context.scaleBy(x: scale, y: -scale)
	#if os(macOS)
		let offset = CGPoint(x: ellipseCenter.midX / scale - floralHeartBounds.midX, y: -1.07 * ellipseCenter.midY / scale - floralHeartBounds.midY)
	#else
		let offset = CGPoint(x: ellipseCenter.midX / scale - floralHeartBounds.midX, y: -ellipseCenter.midY / scale - floralHeartBounds.midY)
	#endif
	context.textPosition = offset
	CTLineDraw(floralHeart, context)
	context.restoreGState()
	context.setShadow(offset: .zero, blur: 0)
	
	// Gloss gradient
	context.saveGState()
	let glossInset: CGFloat = unit * 0.015625
	let glossRadius: CGFloat = ellipseCenter.width * 0.5 - glossInset
	let arcFraction: CGFloat = 2 * .pi * 0.01
	let bottomDistance: CGFloat = unit * 0.13671875
	let arcStart = CGPoint(x: ellipseCenter.midX - glossRadius * cos(arcFraction), y: ellipseCenter.midY - glossRadius * sin(arcFraction))
	let arcEnd = CGPoint(x: ellipseCenter.midX + glossRadius * cos(arcFraction), y: ellipseCenter.midY - glossRadius * sin(arcFraction))
	context.move(to: arcStart)
	context.addArc(center: CGPoint(x: ellipseCenter.midX, y: ellipseCenter.midY), radius: glossRadius, startAngle: .pi - arcFraction, endAngle: -arcFraction, clockwise: false)
	context.move(to: arcEnd)
	context.addQuadCurve(to: arcStart, control: CGPoint(x: ellipseCenter.midX, y: ellipseCenter.midY + bottomDistance))
	context.clip()
	let glossGradient = CGGradient(colorSpace: graySpace, colorComponents: [1.0, 0.85, 1.0, 0.50, 1.0, 0.0], locations: [0.0, 0.5, 0.95], count: 3)!
	let clippedRect = context.boundingBoxOfClipPath
	context.drawLinearGradient(glossGradient, start: CGPoint(x: ellipseCenter.midX, y: clippedRect.minY), end: CGPoint(x: ellipseCenter.midX, y: clippedRect.maxY), options: [])
	context.restoreGState()
}

private extension String {
	static let captionText = NSLocalizedString("This image is drawn in code, rendered to an NSImage and then displayed in an NSImageView.", comment: "")
}

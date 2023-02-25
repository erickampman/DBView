//
//  ResponseView.swift
//  DBView
//
//  Created by Eric Kampman on 2/19/23.
//

import Cocoa

let gMRCSampleCount = Int(64)

class ResponseView: NSView {
	static let frequencyMin = Float(12.0)
	static let frequencyMax = Float(20000.0)
	static let resonanceMin = Float(0.1)
	static let resonanceMax = Float(25.0)
	static let dbMin 		= Float(-20.0)
	static let dbMax 		= Float(30.0)	// actually 25 -> 28db, roughly

	static var k = Float(0); // init once, should be const
	
	let mrc = MagnitudeResponseCalculator(sampleCount: gMRCSampleCount)
	
	override init(frame frameRect: NSRect) {
		coefficients = BiquadCoefficientCalculator.passthroughCoefficients
		
		super.init(frame: frameRect)
	}
	
	required init?(coder: NSCoder) {
		coefficients = BiquadCoefficientCalculator.passthroughCoefficients
		
		super.init(coder: coder)
	}
	
	var coefficients: BiquadCoefficientCalculator.SectionCoefficients {
		didSet {
			needsDisplay = true
		}
	}
	
	class func setK() {
		k = log2f(ResponseView.frequencyMax/ResponseView.frequencyMin)
	}
		
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

		let rpath = NSBezierPath(rect: bounds)
		NSColor.lightGray.setFill()
		rpath.fill()
		
		let responseVals = mrc.response(for: coefficients)
		let rampVals = mrc.ramp
		
		var points = [NSPoint]()
		for (ramp, resp) in zip(rampVals, responseVals) {
			let pt = pointFromNorm(ramp, resonance: resp)
			points.append(pt)
			print("\(ramp) \(resp) -- \(pt)")
		}
		
		let linePath = NSBezierPath()
		linePath.move(to: points[0])
		for point in points {
			linePath.line(to: point)
		}
		NSColor.black.setStroke()
		linePath.stroke()
    }
    
	func verticalFromResonance(_ db: Float) -> CGFloat
	{
		let h = self.frame.height
		// 50 is 30 - -20;  .4 is 20 / 50
		return h * CGFloat(db) / 50.0 + 0.4 * h
	}
	
	func horizontalFromNorm(_ norm: Float) -> CGFloat
	{
		let w = self.frame.width
		let a = Float(w) - ResponseView.frequencyMin
		
		return CGFloat(a * norm + ResponseView.frequencyMin)
	}
	
	func pointFromNorm(_ norm: Float, resonance: Float) -> NSPoint
	{
		let h = horizontalFromNorm(norm)
		if (0 >= resonance) {
			return NSPoint(x: h,y: 0)
		}
		let db = 20.0 * log10(resonance)
		let v = verticalFromResonance(db)
		return NSPoint(x: h,y: v)
	}
}

//
//  ViewController.swift
//  DBView
//
//  Created by Eric Kampman on 2/19/23.
//

import Cocoa

/*
	This project is strictly to work out the graph UI.
	No intention to process audio, so hard-coding the sample rate.
 */
let gSampleRate = Int32(44100.0)

let defaultFilterType = BiquadCoefficientCalculator.FilterType.passthrough
let defaultFrequency = Float(2500.0)
let defaultResonance = Float(1.0)

enum UITag : Int {
	case frequencyUITag = 1
	case resonanceUITag
}

class ViewController: NSViewController {
	var bcParameters = BCParameters(filterType: defaultFilterType, frequency: defaultFrequency, resonance: defaultResonance)
	
	override func viewDidLoad() {
		super.viewDidLoad()

		updateControlsWithCurrentParameters()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	func updateControlsWithCurrentParameters() {
		let filterType = Int(bcParameters.filterType.rawValue)
		filterTypePopup.selectItem(withTag: filterType)
		
		resonanceSlider.floatValue = bcParameters.resonance
		frequencySilder.floatValue = bcParameters.frequency
	}
	
	func generateCoefficients(from parameters: BCParameters) -> BiquadCoefficientCalculator.SectionCoefficients
	{
		let ret = BiquadCoefficientCalculator.coefficients(for: bcParameters,
								 sampleRate: gSampleRate)
		return ret
	}

	@IBAction func controlChanged(_ sender: Any) {
		if let ctl = sender as? NSPopUpButton {
			guard let value = ctl.selectedItem?.tag else {
				return
			}
			guard let filterType = BiquadCoefficientCalculator.FilterType(rawValue: value) else { return }
			bcParameters.filterType = filterType
		} else if let ctl = sender as? NSSlider {
			switch ctl.tag {
			case UITag.frequencyUITag.rawValue:
				bcParameters.frequency = ctl.floatValue
			case UITag.resonanceUITag.rawValue:
				bcParameters.resonance = ctl.floatValue
			default:
				break
			}
		}
		let coefficients = BiquadCoefficientCalculator.coefficients(for: bcParameters,
								 sampleRate: gSampleRate)
		
		responseView.coefficients = coefficients
		responseView.needsDisplay = true
/*
		let responseVals = mrc.response(for: coefficients)
		let rampVals = mrc.ramp
		
		var points = [NSPoint]()
		for (ramp, resp) in zip(rampVals, responseVals) {
			let pt = responseView.PointFromNorm(ramp, resonance: resp)
			points.append(pt)
			print("\(pt)")
		}
 */
	}
	
	@IBOutlet weak var filterTypePopup: NSPopUpButton!
	@IBOutlet weak var resonanceSlider: NSSlider!
	@IBOutlet weak var frequencySilder: NSSlider!
	
	@IBOutlet weak var responseView: ResponseView!

}


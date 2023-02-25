//
//  ResponseMath.swift
//  DBView
//
//  Created by Eric Kampman on 2/19/23.
//

import Foundation

struct ResponseMath {
	
	static func normalizedFrequencyToFrequency(_ normFreq: Float) -> Float
	{
		return ResponseView.frequencyMin * log2(ResponseView.k * normFreq)
	}
	
	static func responseToDecibels(_ response: Float) -> Float
	{
		return 20.0 * log10(response);
	}
	
	static func normalizedFrequenciesToFrequencies(_ normFreqs: [Float]) -> [Float]
	{
		return normFreqs.map { ResponseMath.responseToDecibels($0) }
	}

	static func responsesToDecibels(_ responses: [Float]) -> [Float]
	{
		return responses.map { ResponseMath.responseToDecibels($0) }
	}
	
}

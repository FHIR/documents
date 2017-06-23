/*
 rule.summary=FHIR Connectathon 12 - Track 08 FHIR Genomics - Scenario 08 Sequence Quality in Search
 rule.description=Verify that the Bundle contains Sequence resources where at least on instance defines a quality score value
*/
assert contentType=='JSON' || contentType=='XML': "Expected JSON or XML in message body"

if (contentType=='JSON') {
	assert !body.resourceType.is(null) && !body.resourceType.isEmpty(): "Could not find resourceType in message body"
	assert body.resourceType.equals('Bundle'): "Expected Bundle resource in response but found '"+body.resourceType+"'"

	def sequenceEntries = body.entry.findAll { node ->
		node.resourceType=='Sequence'
	}

	def sequenceQualityEntries = body.entry.findAll { node ->
		node.resourceType=='Sequence' && node.quality && node.quality.score && node.quality.score.value
	}

	assert sequenceEntries.size() > 0: "No Sequence resources found in searchset Bundle entries"
	assert sequenceQualityEntries.size() > 0: "No Sequence resources found in searchset Bundle entries with defined quality score values"
} else {
	assert !body.name().is(null) && !body.name().isEmpty(): "Could not find resource in message body"
	assert body.name().equals('Bundle'): "Expected Bundle resource in response but found '"+body.name()+"'"

	def sequenceEntries = body.entry.resource.'*'.findAll { node ->
		node.name()=='Sequence'
	}

	def sequenceQualityEntries = body.entry.resource.'*'.findAll { node ->
		node.name()=='Sequence' && !node.quality.isEmpty() && !node.quality.score.isEmpty() && !node.quality.score.value.isEmpty()
	}

	assert sequenceEntries.size() > 0: "No Sequence resources found in searchset Bundle entries"
	assert sequenceQualityEntries.size() > 0: "No Sequence resources found in searchset Bundle entries with defined quality score values"
}
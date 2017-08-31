/*
 rule.summary=FHIR Connectathon 12 - Track 08 FHIR Genomics - Scenario 04 DNAVariationId Observation in Search
 rule.description=Verify that the Bundle contains at least one Observation containing Variant Id extension and code value = 'rs587778247'
*/
assert contentType=='JSON' || contentType=='XML': "Expected JSON or XML in message body"

if (contentType=='JSON') {
	assert !body.resourceType.is(null) && !body.resourceType.isEmpty(): "Could not find resourceType in message body"
	assert body.resourceType.equals('Bundle'): "Expected Bundle resource in response but found '"+body.resourceType+"'"

	def variantIdEntries = body.'**'.findAll { node ->
		node.name()=='extension' && node.@url=='http://hl7.org/fhir/StructureDefinition/observation-geneticsDNAVariationId' &&
		!node.valueCodeableConcept.isEmpty() && !node.valueCodeableConcept.coding.isEmpty() &&
		!node.valueCodeableConcept.coding.code.isEmpty() && node.valueCodeableConcept.coding.code.@value == 'rs587778247'
	}
	assert variantIdEntries.size() > 0: "Could not find Observation in searchset Bundle entries with Variant Id extension and code value = 'rs587778247'"
} else {
	assert !body.name().is(null) && !body.name().isEmpty(): "Could not find resource in message body"
	assert body.name().equals('Bundle'): "Expected Bundle resource in response but found '"+body.name()+"'"

	def variantIdEntries = body.'**'.findAll { node ->
		node.name()=='extension' && node.@url=='http://hl7.org/fhir/StructureDefinition/observation-geneticsDNAVariationId' &&
		!node.valueCodeableConcept.isEmpty() && !node.valueCodeableConcept.coding.isEmpty() &&
		!node.valueCodeableConcept.coding.code.isEmpty() && node.valueCodeableConcept.coding.code.@value == 'rs587778247'
	}
	assert variantIdEntries.size() > 0: "Could not find Observation in searchset Bundle entries with Variant Id extension and code value = 'rs587778247'"
}
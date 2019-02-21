/*
	rule.summary=FHIR Connectathon - Terminology-Formal Track - Lookup Code System Verify Display Value
	rule.description=Verify the returned Parameters resource parameter display valueString contains either the expected long name or the rarely used short name
	rule.param.codeSystem.required=true
	rule.param.codeValue.required=true
	rule.param.expectedLongName.required=true
	rule.param.expectedShortName.required=true
*/
assert !param.codeSystem.is(null): "The parameter 'codeSystem' was not supplied"
assert !param.codeValue.is(null): "The parameter 'codeValue' was not supplied"
assert !param.expectedLongName.is(null): "The parameter 'expectedLongName' was not supplied"
assert !param.expectedShortName.is(null): "The parameter 'expectedShortName' was not supplied"

// Lowercase the long and short name values for case-insensitive comparison
String compareLongName = param.expectedLongName.toLowerCase()
String compareShortName = param.expectedShortName.toLowerCase()

boolean isWarningOnly = false
boolean hasVerifiedDisplayValue = false
String verificationMessage = ""

assert contentType=='JSON' || contentType=='XML': "Expected JSON or XML in message body"

if (contentType=='JSON') {
	assert !body.resourceType.is(null) && !body.resourceType.isEmpty(): "Could not find resourceType in message body"
	assert body.resourceType.equals('Parameters'): "Expected Parameters resource in response but found '"+body.resourceType+"'"
} else {
	assert !body.name().is(null) && !body.name().isEmpty(): "Could not find resource in message body"
	assert body.name().equals('Parameters'): "Expected Parameters resource in response but found '"+body.name()+"'"
}

// Attempt to find and verify Parameters.parameter.name='display' exists with corresponding Parameters.parameter.valueString='EXPECTED_VALUE', where EXPECTED_VALUE is either the code system code value long name or optionally the short name.

def displayValue = message.nonFhirPath('Parameters/parameter[name/@value=\'display\']/valueString','.parameter[?(@.name==\'display\')].valueString').val()
def compareValue = message.nonFhirPath('Parameters/parameter[name/@value=\'display\']/valueString','.parameter[?(@.name==\'display\')].valueString').val().toLowerCase()

// 1st check for returned display equal to or contains long name
if (displayValue == null) {
	hasVerifiedDisplayValue = false; verificationMessage += verificationMessage ? ", " : ""; verificationMessage += "Single display parameter with long name value '" + param.expectedLongName + "' not found"
}
else if (compareValue.contains(compareLongName)) {
	hasVerifiedDisplayValue = true
}
else {
	hasVerifiedDisplayValue = false; verificationMessage += verificationMessage ? ", " : ""; verificationMessage += "Display parameter value '" + displayValue + "' does not match expected long name value '" + param.expectedLongName + "'"
}

if (hasVerifiedDisplayValue == false) {
	// 2nd check for returned display equal to or contains short name
	if (compareValue.contains(compareShortName)) {
		hasVerifiedDisplayValue = false; isWarningOnly = true; verificationMessage += verificationMessage ? ", " : ""; verificationMessage += "Short name '" + param.expectedShortName + "' while acceptable is rarely used, consider using the Long name '" + param.expectedLongName + "'"
	}
	else {
		hasVerifiedDisplayValue = false; verificationMessage += verificationMessage ? ", " : ""; verificationMessage += "Display parameter value '" + displayValue + "' does not match expected short name value '" + param.expectedShortName + "'"
	}
}

verificationMessage = "Invalid display string found for " + param.codeSystem + " code " + param.codeValue + "! [" + verificationMessage + "]"

if (!hasVerifiedDisplayValue) {
	if (isWarningOnly) {
		warn(verificationMessage);
	} else {
		fail(verificationMessage);
	}
}

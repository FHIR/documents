/*
	rule.summary=Da Vinci CRD Discovery - Verify CDS Hooks service and optional davinci-crd.configuration-options extension
	rule.description=Conditionally verify the returned cds-services of a specific hook contains a valid davinci-crd.configuration-options extension
	rule.param.hook.required=true
*/
assert !param.hook.is(null): "The parameter 'hook' was not supplied"

// Assert response body is present
response.assertBodyNotEmpty()

// Assert response content-type is of type 'json'
response.assertContentTypeContains("json")

// Use groovy slurper for direct access to non-FHIR json contents
def bodySlurp = response.body.slurp();

// Get all param.hook services
def daVinciServices = bodySlurp.services.findAll { node ->
	node.hook==param.hook
}

if (daVinciServices.size() > 0) {

	// Get all param.hook services containing the Da Vinci CRD extension
	def daVinciExtensionServices = bodySlurp.services.findAll { node ->
		node.hook==param.hook && node.extension && node.extension['davinci-crd.configuration-options']
	}

	if (daVinciExtensionServices.size() > 0) {
		// Initialize message string
		String message = daVinciExtensionServices.size() + " "
		if (daVinciExtensionServices.size() == 1) {
			message += param.hook + " service found;"
		}
		else {
			message += param.hook + " services found;"
		}

		// Get all param.hook services Da Vinci CRD extension code values - the returned structure will be a list of nested lists of code values
		def invalidCodes = bodySlurp.services.findAll { node ->
			node.hook==param.hook && node.extension && node.extension['davinci-crd.configuration-options']
		}
		.extension['davinci-crd.configuration-options']['code'].findAll { !it.isEmpty() }

		int invalidCount = 0
		String invalidList = ""

		// Count the number of invalid code values
		if (invalidCodes.size() > 0) {
			for (option in invalidCodes) {
				if (!option.isEmpty()) {
					option.each { code ->
						if (code != 'priorauth' && code != 'prior-auth-form' && code != 'alt-drug' && code != 'first-line' && code != 'max-cards') {
							invalidCount++
							invalidList += code + "; "
						}
					}
				}
			}
			if (invalidCount > 0) {
				String invalidPlurality = ""
				if (invalidCount > 1) {
					invalidPlurality = "s"
				}
				message += invalidCount + " invalid code" + invalidPlurality + " found --> " + invalidList
				warn(message)
			}
		}
	}
	else {
		// Not found, skip assert
		skip("No " + param.hook + " services found containing the davinci-crd.configuration-options extension.")
	}

}
else {
	// Not found, skip assert
	skip("No " + param.hook + " services found.")
}

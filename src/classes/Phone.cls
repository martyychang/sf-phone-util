/**
 * Phone number following conventions established by E.164
 *
 * @see https://en.wikipedia.org/wiki/E.164
 */
global class Phone {

    private String countryCode;
    private String extension;
    private String subscriberNumber;

    global Phone(String countryCode, String subscriberNumber) {
        this(countryCode, subscriberNumber, null);
    }

	global Phone(String countryCode, String subscriberNumber, String extension) {
		this.countryCode = countryCode;
        this.subscriberNumber = subscriberNumber;
        this.extension = extension;
	}

    global String getCountryCode() {
        return this.countryCode;
    }

    global String getExtension() {
        return this.extension;
    }

    global String getSubscriberNumber() {
        return this.subscriberNumber;
    }

    global Boolean hasCountryCode() {
        return !String.isEmpty(this.countryCode);
    }

    global Boolean hasExtension() {
        return !String.isEmpty(this.extension);
    }

    global Boolean hasSubscriberNumber() {
        return !String.isEmpty(this.subscriberNumber);
    }

    global Boolean isValid() {
        
        // Assume invalid unless proven otherwise
        Boolean valid = false;

        // Don't bother checking if we don't have a global subscriber number
        if (this.hasCountryCode() && this.hasSubscriberNumber()) {

            // Check country code 1 (e.g., United States, Canada)
            if (countryCode == PhoneUtil.UNITED_STATES_COUNTRY_CODE) {
                valid = subscriberNumber.length() ==
                        PhoneUtil.UNITED_STATES_SUBSCRIBER_NUMBER_LENGTH;
            }
            else {
                valid = true;  // Assume valid since it's not empty
            }
        }

        // Return validity
        return valid;
    }

    global static Phone valueOf(String value) {
        return new Phone('x', 'x', 'x');
    }
}
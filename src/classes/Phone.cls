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

    global String format() {
        String formatted = null;

        if (this.isValid()) {
            PhoneService ps = PhoneService.getInstance(this.countryCode);
            formatted = ps.format(subscriberNumber, extension);
        }
        else {
            formatted = (this.countryCode == null ? '' : ('+' + this.countryCode))
                    + (this.subscriberNumber == null ? '' : this.subscriberNumber)
                    + (this.extension == null ? '' : this.extension);
        }

        return formatted;
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
            PhoneService ps = PhoneService.getInstance(this.getCountryCode());
            valid = ps.validateSubscriberNumber(this.getSubscriberNumber());
        }

        // Return validity
        return valid;
    }

    global static Phone valueOf(String value) {
        
        // TODO: Handle international call prefixes

        // Handle the country code by looking for known country codes
        // at the beginning of the number
        String countryCodeRegex = PhoneUtil.getCountryCodeRegex();
        
        Matcher countryCodeMatcher =
                Pattern.compile(countryCodeRegex).matcher(value);

        String countryCode = countryCodeMatcher.find()
                ? countryCodeMatcher.group(1)
                : PhoneSetting__c.getInstance().DefaultCountryCode__c;

        // Handle the subscriber number and the possible extension
        String subscriberNumber = null;
        String extension = null;

        // Remove the country code and
        // strip all remaining non-digit characters
        value = value.replaceAll(countryCodeRegex, '');
        value = value.replaceAll('[^\\d]', '');

        // If the remaining string has more characters than the
        // max length, assume the extra is the extension.
        PhoneService ps = PhoneService.getInstance(countryCode);

        if (value.length() > ps.getMaxSubscriberNumberLength()) {
            subscriberNumber = value.left(ps.getMaxSubscriberNumberLength());
            extension = value.right(
                    value.length() - ps.getMaxSubscriberNumberLength());
        }
        else {
            subscriberNumber = value;
        }

        // Return the phone!
        return new Phone(countryCode, subscriberNumber, extension);
    }
}
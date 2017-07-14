global class PhoneService {
    
    global static Integer DEFAULT_MAX_SUBSCRIBER_NUMBER_LENGTH = 12;

    global static Integer DEFAULT_MIN_SUBSCRIBER_NUMBER_LENGTH = 0;

    global static String DEFAULT_SUBSCRIBER_NUMBER_REGEX = '(.*)';

    global static String DEFAULT_SUBSCRIBER_NUMBER_FORMAT = '\\1';

    private PhoneCountryCode__c countryCodeSetting;

    private static Map<String, PhoneService> serviceMap =
            new Map<String, PhoneService>();

    global PhoneService(PhoneCountryCode__c countryCodeSetting) {
        this.countryCodeSetting = countryCodeSetting;
    }

    global String format(String subscriberNumber, String extension) {

        // Get the matcher
        Matcher formatMatcher = Pattern.compile(
                this.countryCodeSetting.SubscriberNumberRegex__c).matcher(
                        subscriberNumber);
        
        // Set the subscriber number to the target format with placeholders
        subscriberNumber = this.countryCodeSetting.SubscriberNumberFormat__c;

        // Make sure the matcher has found something
        if (formatMatcher.find()) {

            // For every capture group, replace the value in the extension
            for (Integer i = 1; i <= formatMatcher.groupCount(); i++) {
                subscriberNumber = subscriberNumber.replaceAll(
                        '\\\\' + i, formatMatcher.group(i));
            }
        }

        // For every group, do the appropriate replacement
        return '+' + this.getCountryCode() + subscriberNumber + (
                extension == null ? '' : (' x' + extension));
    }

    global String getCountryCode() {
        return this.countryCodeSetting.Name;
    }

    global static PhoneService getInstance() {
        PhoneSetting__c setting = PhoneSetting__c.getInstance();
        return getInstance(setting.DefaultCountryCode__c);
    }

    global static PhoneService getInstance(String countryCode) {
        if (!serviceMap.containsKey(countryCode)) {

            // Remember the min and max lengths, using default values
            // if we don't have any data on the country code
            PhoneCountryCode__c countryCodeSetting =
                    PhoneCountryCode__c.getInstance(countryCode);

            // If no country code entry is found, create a default one
            // for the given country code
            if (countryCodeSetting == null) {
                countryCodeSetting = new PhoneCountryCode__c(
                        Name = countryCode,
                        MinSubscriberNumberLength__c = DEFAULT_MIN_SUBSCRIBER_NUMBER_LENGTH,
                        MaxSubscriberNumberLength__c = DEFAULT_MAX_SUBSCRIBER_NUMBER_LENGTH,
                        SubscriberNumberRegex__c = DEFAULT_SUBSCRIBER_NUMBER_REGEX,
                        SubscriberNumberFormat__c = DEFAULT_SUBSCRIBER_NUMBER_FORMAT);
            }

            // Remember the new service instance
            serviceMap.put(countryCode, new PhoneService(countryCodeSetting));
        }

        return serviceMap.get(countryCode);
    }

    global Integer getMaxSubscriberNumberLength() {
        return this.countryCodeSetting.MaxSubscriberNumberLength__c.intValue();
    }

    global Integer getMinSubscriberNumberLength() {
        return this.countryCodeSetting.MinSubscriberNumberLength__c.intValue();
    }

    global Boolean validateSubscriberNumber(String value) {
        return value.length() >= this.countryCodeSetting.MinSubscriberNumberLength__c
                && value.length() <= this.countryCodeSetting.MaxSubscriberNumberLength__c;
    }
}
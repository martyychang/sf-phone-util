global class PhoneService {
    
    global static Integer DEFAULT_MAX_SUBSCRIBER_NUMBER_LENGTH = 12;

    global static Integer DEFAULT_MIN_SUBSCRIBER_NUMBER_LENGTH = 0;

    private String countryCode;

    private Integer maxSubscriberNumberLength;

    private Integer minSubscriberNumberLength;

    private static Map<String, PhoneService> serviceMap =
            new Map<String, PhoneService>();

    global PhoneService(String countryCode,
            Integer minSubscriberNumberLength,
            Integer maxSubscriberNumberLength) {
        this.countryCode = countryCode;
        this.minSubscriberNumberLength = minSubscriberNumberLength;
        this.maxSubscriberNumberLength = maxSubscriberNumberLength;
    }

    global String getCountryCode() {
        return this.countryCode;
    }

    global static PhoneService getInstance() {
        PhoneSetting__c setting = PhoneSetting__c.getInstance();
        return getInstance(setting.DefaultCountryCode__c);
    }

    global static PhoneService getInstance(String countryCode) {
        if (!serviceMap.containsKey(countryCode)) {

            // Remember the min and max lengths, using default values
            // if we don't have any data on the country code
            PhoneCountryCode__c codeEntry =
                    PhoneCountryCode__c.getInstance(countryCode);

            Integer minLength = codeEntry == null
                    ? DEFAULT_MIN_SUBSCRIBER_NUMBER_LENGTH
                    : codeEntry.MinSubscriberNumberLength__c.intValue();

            Integer maxLength = codeEntry == null
                    ? DEFAULT_MAX_SUBSCRIBER_NUMBER_LENGTH
                    : codeEntry.MaxSubscriberNumberLength__c.intValue();

            // Remember the new service instance
            serviceMap.put(countryCode,
                    new PhoneService(countryCode, minLength, maxLength));
        }

        return serviceMap.get(countryCode);
    }

    global Integer getMaxSubscriberNumberLength() {
        return this.maxSubscriberNumberLength;
    }

    global Integer getMinSubscriberNumberLength() {
        return this.minSubscriberNumberLength;
    }

    global Boolean validateSubscriberNumber(String value) {
        return value.length() >= this.minSubscriberNumberLength
                && value.length() <= this.maxSubscriberNumberLength;
    }
}
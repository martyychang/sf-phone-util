global class PhoneService {

    private String countryCode;

    private Integer minSubscriberNumberLength;

    private Integer maxSubscriberNumberLength;

    private static Map<String, PhoneService> serviceMap =
            new Map<String, PhoneService>();

    global PhoneService(String countryCode) {
        this.countryCode = countryCode;

        // Remember the min and max lengths
        PhoneCountryCode__c codeEntry =
                PhoneCountryCode__c.getInstance(this.countryCode);

        this.minSubscriberNumberLength =
                codeEntry.MinSubscriberNumberLength__c.intValue();
        this.maxSubscriberNumberLength =
                codeEntry.MaxSubscriberNumberLength__c.intValue();
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
            serviceMap.put(countryCode, new PhoneService(countryCode));
        }

        return serviceMap.get(countryCode);
    }
}
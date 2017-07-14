@isTest
private class PhoneServiceTest {

    @testSetup
    private static void setup() {

        // Create Phone Country Code records
        insert new List<PhoneCountryCode__c> {
            new PhoneCountryCode__c(Name = '1',
                    MinSubscriberNumberLength__c = 10,
                    MaxSubscriberNumberLength__c = 10,
                    SubscriberNumberRegex__c = '(\\d{3})(\\d{3})(\\d{4})',
                    SubscriberNumberFormat__c = '(\\1)\\2-\\3'),
            new PhoneCountryCode__c(Name = '886',
                    MinSubscriberNumberLength__c = 9,
                    MaxSubscriberNumberLength__c = 9,
                    SubscriberNumberRegex__c = '(\\d{1})(\\d{4})(\\d{4})',
                    SubscriberNumberFormat__c = '(\\1)\\2-\\3')
        };

        // Create Phone Setting records
        insert new List<PhoneSetting__c> {
            new PhoneSetting__c(DefaultCountryCode__c = '1')
        };
    }

    /**
     * The following results are expected from various numbers. This assumes
     * the default country code is 1.
     *
     * The following subscriber formatting considerations exist.
     *
     * cc  | Subscriber Number Regex    | Subscriber Number Format
     * --- | -------------------------- | ------------------------
     * 1   | (\\d{3})(\\d{3})(\\d{4})   | (\\1)\\2-\\3
     * 886 | (\\d{1})(\\2{4}){\\d{4})   | \\1-\\2-\\3
     *
     * Country Code | Subscriber Number | Extension | Formatted
     * 1            | 8006676389        | null      | +1(800)667-6389
     * 1            | 6173165400        | null      | +1(617)316-5400
     * 1            | 6177272200        | 2         | +1(617)727-2200 x2
     * 886          | 223214311         | null      | +886-2-2321-4311
     */
    @isTest
    private static void format() {

        // Given
        System.assertEquals('1', PhoneService.getInstance().getCountryCode(),
                'PhoneService.getInstance().getCountryCode()');

        Map<Phone, String> expectedMap = new Map<Phone, String> {
            new Phone('1', '8006676389') => '+1(800)667-6389',
            new Phone('1', '6173165400') => '+1(617)316-5400',
            new Phone('1', '6177272200', '2') => '+1(617)727-2200 x2',
            new Phone('886', '223214311') => '+886(2)2321-4311'
        };

        // When
        Test.startTest();

        Map<Phone, String> actualMap = new Map<Phone, String>();

        for (Phone eachPhone : expectedMap.keySet()) {
            PhoneService ps = PhoneService.getInstance(eachPhone.getCountryCode());
            actualMap.put(eachPhone, ps.format(
                    eachPhone.getSubscriberNumber(), eachPhone.getExtension()));
        }

        // Then
        Test.stopTest();

        for (Phone eachPhone : expectedMap.keySet()) {
            System.assertEquals(
                    expectedMap.get(eachPhone), actualMap.get(eachPhone), 'format');
        }
    }
}
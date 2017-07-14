@isTest
private class PhoneTest {

    @testSetup
    private static void setup() {

        // Create Phone Country Code records
        insert new List<PhoneCountryCode__c> {
            new PhoneCountryCode__c(Name = '1',
                    MaxSubscriberNumberLength__c = 10,
                    MinSubscriberNumberLength__c = 10)
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
     * Given                | cc   | Subscriber Number | Extension
     * -------------------- | ---- | ----------------- | ---------
     * 1-800-NO-SOFTWARE    | 1    | 8006676389        | null
     * +1 (617) 316-5400    | 1    | 6173165400        | null
     * +1(617)316-5400      | 1    | 6173165400        | null
     * 1 (617) 316-5400     | 1    | 6173165400        | null
     * 1(617)316-5400       | 1    | 6173165400        | null
     * 1-617-316-5400       | 1    | 6173165400        | null
     * 16173165400          | 1    | 6173165400        | null
     * (617) 316-5400       | 1    | 6173165400        | null
     * (617) 316-540        | 1    | 617316540         | null
     * (617)316-5400        | 1    | 6173165400        | null
     * 617-316-5400         | 1    | 6173165400        | null
     * 6173165400           | 1    | 6173165400        | null
     * +1 (617) 727-2200 x2 | 1    | 6177272200        | 2
     * 1 (617) 727-2200 x2  | 1    | 6177272200        | 2
     * (617) 727-2200 x2    | 1    | 6177272200        | 2
     * (617) 727-2200 ext 2 | 1    | 6177272200        | 2
     * 617-727-2200 ext. 2  | 1    | 6177272200        | 2
     * 6177272200x2         | 1    | 6177272200        | 2
     * +886-2-2321-4311     | 886  | 23214311          | null
     * null                 | null | null              | null
     */
    @isTest
    private static void valueOf() {

        // Given
        System.assertEquals('1', PhoneService.getInstance().getCountryCode(),
                'PhoneService.getInstance().getCountryCode()');

        Map<String, Phone> expectedMap = new Map<String, Phone> {
            // TODO: '1-800-NO-SOFTWARE'
            '+1 (617) 316-5400' => new Phone('1', '6173165400'),
            '+1(617)316-5400' => new Phone('1', '6173165400'),
            '1 (617) 316-5400' => new Phone('1', '6173165400'),
            '1(617)316-5400' => new Phone('1', '6173165400'),
            '1-617-316-5400' => new Phone('1', '6173165400'),
            '1617316-5400' => new Phone('1', '6173165400'),
            '(617) 316-5400' => new Phone('1', '6173165400'),
            '(617) 316-540' => new Phone('1', '617316540'),
            '(617)316-5400' => new Phone('1', '6173165400'),
            '617-316-5400' => new Phone('1', '6173165400'),
            '6173165400' => new Phone('1', '6173165400'),
            '+1 (617) 727-2200 x2' => new Phone('1', '6177272200', '2'),
            '1 (617) 727-2200 x2' => new Phone('1', '6177272200', '2'),
            '(617) 727-2200 x2' => new Phone('1', '6177272200', '2'),
            '(617) 727-2200 ext 2' => new Phone('1', '6177272200', '2'),
            '617-727-2200 ext. 2' => new Phone('1', '6177272200', '2'),
            '6177272200x2' => new Phone('1', '6177272200', '2'),
            '+886-2-2321-4311' => new Phone('886', '223214311'),
            null => new Phone(null, null, null)
        };

        // When
        Test.startTest();

        Map<String, Phone> actualMap = new Map<String, Phone>();

        for (String eachValue : expectedMap.keySet()) {
            actualMap.put(eachValue, Phone.valueOf(eachValue));
        }

        // Then
        Test.stopTest();

        for (String eachValue : expectedMap.keySet()) {
            Phone expected = expectedMap.get(eachValue);
            Phone actual = actualMap.get(eachValue);

            System.assertEquals(
                    expected.getCountryCode(), actual.getCountryCode(),
                    'country code: ' + eachValue);

            System.assertEquals(
                    expected.getSubscriberNumber(), actual.getSubscriberNumber(),
                    'subscriber number: ' + eachValue);

            System.assertEquals(
                    expected.getExtension(), actual.getExtension(),
                    'extension: ' + eachValue);
        }
    }
}
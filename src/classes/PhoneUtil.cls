global class PhoneUtil {

    /**
     * @return a really long regex based on all of the known country codes
     */
    global static String getCountryCodeRegex() {

        // Compile a list of the country codes
        List<String> countryCodes = new List<String>();

        for (PhoneCountryCode__c eachEntry : PhoneCountryCode__c.getAll().values()) {
            countryCodes.add(eachEntry.Name);
        }

        return '^\\+*(' + String.join(countryCodes, '|') + ')';
    }
}
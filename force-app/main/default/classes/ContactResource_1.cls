@RestResource(urlMapping='/ContactAPI_1/')
Global with sharing class ContactResource_1 {
    
    // Creating a response wrapper class
    global class ResponseWrapper {
        String success;
        String message;
    }
    @HttpGet
    Global static List<contact> getContact(){
        RestRequest contactRequest=RestContext.request;
        map<string,string> contactRequestParameter=contactRequest.params;
        system.debug('contactRequestParameter --> '+contactRequestParameter);
        system.debug('contactRequestParameter with jSon Stringfy --> '+JSON.serialize(contactRequestParameter));
        system.debug('limit --> '+contactRequestParameter.get('limit'));
        system.debug('leadSource --> '+contactRequestParameter.get('leadSource'));
        integer contactLimit=Integer.valueOf(contactRequestParameter.get('limit'));
        string leadSource=contactRequestParameter.get('leadSource');
        List<contact> contactList=[SELECT LastName, Id, AccountId, FirstName, Salutation, Name, MailingCountry, MailingCity, 
                                   MailingState, Phone FROM Contact limit:contactLimit];
        return contactList;
    }
    
    /*@HttpPost
Global static contact createContact(string firstName, string lastName, string birthDate){
contact objcontact=New contact();
objcontact.FirstName=firstName;
objcontact.LastName=lastName;
objcontact.Birthdate=date.parse(birthDate);
insert objcontact;
return objcontact;
}*/
    
    @HttpPost
    Global static contact createContact(){
        RestRequest contactRequest=RestContext.request;
        string requestBody=contactRequest.requestBody.toString();
        Contact contact=(Contact) JSON.deserialize(requestBody, Contact.class);
        
        insert contact;
        return contact;
    }
    
    @HTTPDeLete
    Global static Map<string,string> deleteContact(){
        Map<string,string> responseMap=New Map<string,string>();
        
        RestRequest ContactRequest=RestContext.request;
        string contactRequestUrl=ContactRequest.requestURI;
        system.debug('contactRequestUrl --> '+contactRequestUrl);
        Id contactId=id.valueof(contactRequestUrl.substring(contactRequestUrl.lastIndexOf('/')+1));
        Contact contact=New Contact(id=contactId);
        try{
            delete contact;
            responseMap.put('Success','1');
            responseMap.put('Message','Record Deleted Successfully');
        }
        catch(exception e){
            
        }
        return responseMap;
    }
    // PATCH Method
    @HTTPPatch
    global static List<ResponseWrapper> updateContacts() {
        // Initializing the response wrapper list
        List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
        // Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the request body from the request
        String requestBody = contactRequest.requestBody.toString();
        // Deserializing the JSON request body and initializing the list of contacts to update
        List<Contact> contactsToUpdate = (List<Contact>) JSON.deserialize(requestBody, List<Contact>.class);
        // Updating contacts with partial success enabled
        Database.SaveResult[] updateResults = Database.update(contactsToUpdate, false);
        // Checking the result of update operation for each contact
        for(Database.SaveResult updateResult : updateResults) {
            // Initializing the response wrapper
            ResponseWrapper wrapper = new ResponseWrapper();
            // Initializing the response wrapper
            if (updateResult.isSuccess()) {
                // Update successful, setting up the appropriate message in response wrapper
                wrapper.success = '1';
                wrapper.message = 'Successfully updated contact with Id: ' + updateResult.getId();
            }
            else {
                // Update failed, getting errors and setting up the error message in response wrapper
                wrapper.success = '0';
                for(Database.Error error : updateResult.getErrors()) {
                    wrapper.message = 'The following error has occurred for contact with Id: ' + updateResult.getId() + '. ';
                    wrapper.message += error.getStatusCode() + ': ' + error.getMessage() + '. ';
                    wrapper.message += 'Contact fields that affected this error: ' + error.getFields();
                }
            }
            // Adding response wrapper instance to the response wrapper list
            responseWrapperList.add(wrapper);
        }
        // Returning the response wrapper list in the response
        return responseWrapperList;
    }
}
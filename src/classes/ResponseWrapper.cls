/**
 * Created by Lolly on 2019-02-22.
 */

public with sharing class ResponseWrapper {

    @AuraEnabled public List<BookmarkWrapper> bookmarks{get;set;}
    @AuraEnabled public Boolean success{get;set;}
    @AuraEnabled public List<String> exceptionMessages {get;set;}

}
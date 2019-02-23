/**
 * Created by Lolly on 2019-02-22.
 */

public with sharing class BookmarkWrapper {

    @AuraEnabled public Bookmark__c bookmark{get;set;}
    @AuraEnabled public Boolean isFavorite{get;set;}

}
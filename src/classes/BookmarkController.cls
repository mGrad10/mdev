/**
 * Created by Melinda Grad on 2019-02-22.
 */

public with sharing class BookmarkController {

    @AuraEnabled
    public static ResponseWrapper getBookmarks(){

        ResponseWrapper response = new ResponseWrapper();

        try{

            //Get the current running User, we need this to get their ContactId
            List<User> currentUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];


            //Query all the User's Favorite Bookmarks and add their Bookmark Ids to a list
            List<Favorite_Bookmark__c> favoriteBookmarkList = [SELECT Id, Bookmark__c, Contact__c
                                                            FROM Favorite_Bookmark__c
                                                            WHERE Contact__c =: currentUser[0].ContactId];

            List<String> favoriteBookmarkIds = new List<String>();
            for(Favorite_Bookmark__c theFav : favoriteBookmarkList){
                favoriteBookmarkIds.add(theFav.Bookmark__c);
            }

            //Get all bookmarks and create wrappers
            List<Bookmark__c> allBookmarks = [SELECT Id, Name, URL__c FROM Bookmark__c];

            for(Bookmark__c theBookmark : allBookmarks){

                BookmarkWrapper bookmarkWrapper = new BookmarkWrapper();
                bookmarkWrapper.bookmark = theBookmark;

                if(favoriteBookmarkIds.contains(theBookmark.Id)){
                    bookmarkWrapper.isFavorite = TRUE;
                }else{
                    bookmarkWrapper.isFavorite = FALSE;
                }
                response.bookmarks.add(bookmarkWrapper);
            }

            response.success = TRUE;

        }catch(Exception e){
            response.success = FALSE;
            response.exceptionMessages.add(e.getMessage());
        }

        System.debug('RESPONSE ====' + response);
        return response;
    }

    @AuraEnabled
    public static ResponseWrapper createUserFavoriteBookmark(Bookmark__c theBookmark){

        ResponseWrapper response = new ResponseWrapper();

        try{

            //Get the current running User, we need this to get their ContactId
            List<User> currentUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];

            //If the Bookmark is not NULL, create a bookmark favorite for the User
            if((theBookmark != NULL)
                    && (currentUser[0].ContactId != NULL && currentUser[0].ContactId != '')){

                response.success = TRUE;
                Favorite_Bookmark__c favoriteBookmark = new Favorite_Bookmark__c();
                favoriteBookmark.Bookmark__c = theBookmark.Id;
                favoriteBookmark.Name = theBookmark.Name;
                favoriteBookmark.Contact__c = currentUser[0].ContactId;
                insert favoriteBookmark;

            }
            else{
                response.success = FALSE;
                response.exceptionMessages.add('Could not create bookmark');
            }

        }catch(Exception e){
            response.success = FALSE;
            response.exceptionMessages.add(e.getMessage());
        }
        System.debug('RESPONSE ====' + response);
        return response;
    }

    @AuraEnabled
    public static ResponseWrapper deleteUserFavoriteBookmark(Bookmark__c theBookmark){

        ResponseWrapper response = new ResponseWrapper();

        try{

            //Get the current running User, we need this to get their ContactId
            List<User> currentUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];

            //If the Bookmark is not NULL, create a bookmark favorite for the User
            if((theBookmark != NULL && (currentUser[0].ContactId != NULL && currentUser[0].ContactId != ''))
                    && (currentUser[0].ContactId != NULL && currentUser[0].ContactId != '')){

                //Query all the User's Favorite Bookmarks and add their Bookmark Ids to a list
                List<Favorite_Bookmark__c> favoriteBookmarkList = [SELECT Id, Bookmark__c, Contact__c
                                                                    FROM Favorite_Bookmark__c
                                                                    WHERE Contact__c =: currentUser[0].ContactId
                                                                    AND Bookmark__c =: theBookmark.Id];

                delete favoriteBookmarkList[0];
                response.success = TRUE;
            }else{
                response.success = FALSE;
                response.exceptionMessages.add('Could not delete bookmark');
            }

        }catch(Exception e){
            response.success = FALSE;
            response.exceptionMessages.add(e.getMessage());
        }
        System.debug('RESPONSE ====' + response);
        return response;
    }
}
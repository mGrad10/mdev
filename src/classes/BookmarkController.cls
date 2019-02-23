/**
 * Created by Melinda Grad on 2019-02-22.
 */

public with sharing class BookmarkController {

    @AuraEnabled
    public static ResponseWrapper getBookmarks(){

        ResponseWrapper response = new ResponseWrapper();

        try{

            //Get the current running User, we need this to get they're ContactId
            List<User> currentUser = [SELECT Id, ContactId FROM User WHERE Id =: UserInfo.getUserId()];

            System.debug('CURRENT USER ==' + currentUser);


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

            System.debug('ALL BOOKMARK QUERy ==' + allBookmarks);
            for(Bookmark__c theBookmark : allBookmarks){

                System.debug('bookmark id' + theBookmark.Id);
                BookmarkWrapper bookmarkWrapper = new BookmarkWrapper();
                bookmarkWrapper.bookmark = theBookmark;

                if(favoriteBookmarkIds.contains(theBookmark.Id)){
                    bookmarkWrapper.isFavorite = TRUE;
                }else{
                    bookmarkWrapper.isFavorite = FALSE;
                }
                response.bookmarks = new List<BookmarkWrapper>();
                response.bookmarks.add(bookmarkWrapper);
            }

            response.success = TRUE;

        }catch(Exception e){
            response.success = FALSE;
            response.exceptionMessages.add(e.getMessage());
            System.debug('RESPONSE ====' + response);
        }


        return response;
    }
}
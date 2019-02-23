/**
 * Created by Lolly on 2019-02-22.
 */

@isTest
public with sharing class BookmarkControllerTest {

    @isTest(seeAllData=TRUE)
    public static void testGetBookmarks(){

        List<User> userList = [SELECT Id FROM User WHERE Id = '0052J0000082v10'];

        System.runAs(userList[0]){

            ResponseWrapper responseWrapper = BookmarkController.getBookmarks();

            System.debug('RESPONSE WRAPPER =====+++' + responseWrapper);
        }

    }

}
/**
 * Created by Lolly on 2019-02-22.
 */
({
    doInit: function (component,event,helper) {
        helper.getBookmarkList(component,event,helper);
    },

    doCreateFavorite: function (component, event, helper) {

        var bookmarkToFavorite = event.getSource().get('v.value').bookmark;

        //If the bookmark is not a favorite, create a favorite record
        if(!bookmarkToFavorite.isFavorite__c){
            helper.createFavorite(component,event,helper,bookmarkToFavorite);
        }else{
            helper.deleteFavorite(component,event,helper,bookmarkToFavorite);
        }
    }
})
/**
 * Created by Lolly on 2019-02-22.
 */
({
    getBookmarkList: function (component,event,helper) {

        console.log('INSIDE GET BOOKMARKS');

        //Call Apex controller to get Bookmarks
        var action = component.get("c.getBookmarks");

        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("Response results: ");
                console.log(response.getReturnValue().bookmarks);
                component.set('v.bookmarkList', response.getReturnValue().bookmarks);
            }
            else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast(component,event,helper,'Error', errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    createFavorite: function (component,event,helper,bookmarkToFavorite) {

        console.log('INSIDE CREATE FAVS');

        //Call Apex controller to get Bookmarks
        var action = component.get("c.createUserFavoriteBookmark");

        action.setParam('theBookmark', bookmarkToFavorite);

        action.setCallback(this,function(response) {
            if (response.getReturnValue().success) {
                console.log('SUCCESS');
                helper.showToast(component,event,helper,'Success', 'Favorites Updated');
            }
            else {

                helper.showToast(component,event,helper,'Error', response.getReturnValue().exceptionMessages[0]);

            }
        });
        $A.enqueueAction(action);
    },

    showToast : function(component, event, helper, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})
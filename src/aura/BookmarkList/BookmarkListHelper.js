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
            console.log('STATE ==');
            if (state === "SUCCESS") {
                console.log("Response results: " + response.getReturnValue().bookmarks[0].bookmark.URL__c);
                component.set('v.bookmarkList', response.getReturnValue());
            }
            else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})
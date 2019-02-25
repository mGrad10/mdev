/**
 * Created by Lolly on 2019-02-22.
 */
({
    doInit: function (component,event,helper) {
        helper.getBookmarkList(component,event,helper);
    },

    doCreateFavorite: function (component, event, helper) {

        var bookmarkToFavorite = event.getSource().get('v.value');

        helper.createFavorite(component,event,helper,bookmarkToFavorite);

    }
})
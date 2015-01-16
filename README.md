# MeditationHelper

### TODO

<pre><code>
PFUser.enableAutomaticUser()
var defaultACL = PFACL.ACL()
// Optionally enable public read access while disabling public write access.
// defaultACL.setPublicReadAccess(true)
PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser:true)
</code></pre>

- merge Username, email when sign up
- Style Login/Signup screen, remove Parse logo
- Style Login/Signup screen, trying to apply metal style from demo
- pinInBackground Local first or saveEventually, save to cloud when need, need test offline case, app close case
- load fromLocalDatastore or network?
- link with user, ACL or not?
- cachePolicy choose?
- avoid too much counting objects, use redundant field for statistic
- use PFFile for avatar
- complete analytics
- PFGeoPoint to geo code
- How to cache, automatically? need verify
- when need Anonymous? what if not logged in
- use PFQueryTableViewController for summary?

- Do I need Cloud Functions here?
- In-App Purchases for donations or even outside link for donation?
- use https://github.com/Ramotion/animated-tab-bar for tab animation and sync finish animation
- use https://github.com/dekatotoro/GoogleMaterialDesignIcons for images

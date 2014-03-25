package com.parse.onetomanytutorial;

import android.app.Application;
import android.util.Log;
import android.widget.Toast;

import com.parse.LogInCallback;
import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseAnonymousUtils;
import com.parse.ParseException;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

public class OneToManyApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();

		/*
		 * Fill in this section with your Parse credentials
		 */
		Parse.initialize(this, "YOUR_APP_ID", "YOUR_CLIENT_KEY");

		/*
		 * This app lets an anonymous user create and save blog posts.
		 * An anonymous user is a user that can be created without a 
		 * username and password but still has all of the same capabilities 
		 * as any other ParseUser.
		 * 
		 * After logging out, an anonymous user is abandoned, and its 
		 * data is no longer accessible. In your own app, you can convert
		 * anonymous users to regular users so that data persists.
		 * 
		 * Learn more about the ParseUser class:
		 * https://www.parse.com/docs/android_guide#users
		 */
		
	        ParseUser.enableAutomaticUser();	
		

		/*
		 * For more information on app security and Parse ACL:
		 * https://www.parse.com/docs/android_guide#security-recommendations
		 */
		ParseACL defaultACL = new ParseACL();

		// If you would like all objects to be private by default, remove this
		// line.
		defaultACL.setPublicReadAccess(true);

		ParseACL.setDefaultACL(defaultACL, true);
	}

}

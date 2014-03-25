package com.parse.onetomanytutorial;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ArrayAdapter;

import com.parse.FindCallback;
import com.parse.ParseAnalytics;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

public class PostListActivity extends ListActivity {

	private ArrayList<String> posts;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ParseAnalytics.trackAppOpened(getIntent());
		posts = new ArrayList<String>();
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1, posts);
		setListAdapter(adapter);
		updatePostList();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.activity_post_list, menu);
		return true;
	}

	/*
	 * Creating posts and refreshing the list will be controlled from the Action
	 * Bar.
	 */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {

		case R.id.action_refresh: {
			updatePostList();
			break;
		}

		case R.id.action_new: {
			newPost();
			break;
		}
		}
		return super.onOptionsItemSelected(item);
	}

	private void updatePostList() {
		// Create query for objects of type "Post"
		ParseQuery<ParseObject> query = ParseQuery.getQuery("Post");

		// Restrict to cases where the author is the current user.
		// Note that you should pass in a ParseUser and not the
		// String reperesentation of that user
		query.whereEqualTo("author", ParseUser.getCurrentUser());
		// Run the query
		query.findInBackground(new FindCallback<ParseObject>() {

			@Override
			public void done(List<ParseObject> postList, ParseException e) {
				if (e == null) {
					// If there are results, update the list of posts
					// and notify the adapter
					posts.clear();
					for (ParseObject post : postList) {
						posts.add(post.getString("textContent"));
					}
					((ArrayAdapter<String>) getListAdapter())
							.notifyDataSetChanged();
				} else {
					Log.d("Post retrieval", "Error: " + e.getMessage());
				}

			}

		});

	}

	private void newPost() {
		Intent i = new Intent(this, WritePostActivity.class);
		startActivityForResult(i, 0);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (resultCode == Activity.RESULT_OK) {
			// If a new post has been added, update
			// the list of posts
			updatePostList();
		}
	}

}

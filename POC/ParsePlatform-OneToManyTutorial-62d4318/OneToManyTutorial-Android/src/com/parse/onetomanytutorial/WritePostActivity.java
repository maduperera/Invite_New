package com.parse.onetomanytutorial;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SaveCallback;

public class WritePostActivity extends Activity {
	
	private Button saveButton;
	private Button cancelButton;
	private TextView postContent;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_write_post);

		postContent = ((EditText) findViewById(R.id.blog_post_content));

		saveButton = ((Button) findViewById(R.id.save_button));
		saveButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				// When the user clicks "Save," upload the post to Parse
				// Create the Post object
				ParseObject post = new ParseObject("Post");
				post.put("textContent", postContent.getText().toString());

				// Create an author relationship with the current user
				post.put("author", ParseUser.getCurrentUser());

				// Save the post and return
				post.saveInBackground(new SaveCallback () {

					@Override
					public void done(ParseException e) {
						if (e == null) {
							setResult(RESULT_OK);
							finish();
						} else {
							Toast.makeText(getApplicationContext(), 
									"Error saving: " + e.getMessage(), 
									Toast.LENGTH_SHORT)
									.show();
						}
					}
					
				});

			}
		});

		cancelButton = ((Button) findViewById(R.id.cancel_button));
		cancelButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				setResult(RESULT_CANCELED);
				finish();
			}
		});
	}

}

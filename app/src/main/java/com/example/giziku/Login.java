package com.example.giziku;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;

public class Login extends AppCompatActivity {

    EditText editTextEmail, editTextPassword;
    Button buttonLogin;
    FirebaseAuth mAuth;
    TextView textView, textWhatsapp;
    ProgressBar progressBar;
    String whatsappUser  = "+6285227521616";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this); // Ensure EdgeToEdge is properly configured in your app theme
        setContentView(R.layout.activity_login);

        mAuth = FirebaseAuth.getInstance();
        editTextEmail = findViewById(R.id.email);
        progressBar = findViewById(R.id.progressBar);
        editTextPassword = findViewById(R.id.password);
        buttonLogin = findViewById(R.id.btn_login);
        textWhatsapp = findViewById(R.id.whatsapp);
        textView = findViewById(R.id.daftar_disini);

        // Redirect to Registrasi activity
        textView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(getApplicationContext(), Registrasi.class);
                startActivity(intent);
                finish();
            }
        });

        // Handle login button click
        buttonLogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                progressBar.setVisibility(View.VISIBLE);
                String email = editTextEmail.getText().toString().trim();
                String password = editTextPassword.getText().toString().trim();

                // Validate inputs
                if (TextUtils.isEmpty(email)) {
                    Toast.makeText(Login.this, "Enter email", Toast.LENGTH_SHORT).show();
                    progressBar.setVisibility(View.GONE);
                    return;
                }

                if (TextUtils.isEmpty(password)) {
                    Toast.makeText(Login.this, "Enter password", Toast.LENGTH_SHORT).show();
                    progressBar.setVisibility(View.GONE);
                    return;
                }

                // Sign in with Firebase
                mAuth.signInWithEmailAndPassword(email, password)
                        .addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                            @Override
                            public void onComplete(@NonNull Task<AuthResult> task) {
                                progressBar.setVisibility(View.GONE);
                                if (task.isSuccessful()) {
                                    SharedPreferences sharedPreferences = getSharedPreferences("User Preferences", Context.MODE_PRIVATE);
                                    SharedPreferences.Editor editor = sharedPreferences.edit();
                                    editor.putBoolean("isLoggedIn", true);
                                    editor.apply();
                                    Toast.makeText(getApplicationContext(), "Login successful", Toast.LENGTH_SHORT).show();
                                    Intent intent = new Intent(getApplicationContext(), MainActivity.class); // Make sure MainActivity is defined
                                    startActivity(intent);
                                    finish(); // Finish the Login activity so the user can't go back to it
                                } else {
                                    Toast.makeText(Login.this, "Authentication failed.", Toast.LENGTH_SHORT).show();
                                }
                            }
                        });
            }
        });

        // Handle WhatsApp button click
        textWhatsapp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String url = "https://api.whatsapp.com/send?phone=" + whatsappUser ;
                try {
                    PackageManager pm = getApplicationContext().getPackageManager();
                    pm.getPackageInfo("com.whatsapp", PackageManager.GET_ACTIVITIES);
                    Intent i = new Intent(Intent.ACTION_VIEW);
                    i.setData(Uri.parse(url));
                    startActivity(i);
                } catch (PackageManager.NameNotFoundException e) {
                    // If WhatsApp is not installed, open the URL in a browser
                    startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                }
            }
        });
    }

}
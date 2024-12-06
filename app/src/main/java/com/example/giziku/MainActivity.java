package com.example.giziku;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

import com.example.giziku.Dashboard;  // Pastikan fragment ini di-import

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);  // Layout utama yang telah dibuat

        // Cek status login
        SharedPreferences sharedPreferences = getSharedPreferences("UserPreferences", MODE_PRIVATE);
        boolean isLoggedIn = sharedPreferences.getBoolean("isLoggedIn", false);

        if (!isLoggedIn) {
            // Jika tidak login, buka MainActivity (layar login atau splash screen)
            setContentView(R.layout.activity_main);  // Menampilkan layout utama
        } else {
            // Jika sudah login, buka Dashboard
            Intent intent = new Intent(MainActivity.this, Dashboard.class);
            startActivity(intent);
            finish();  // Menutup MainActivity
        }

        // Tombol-tombol untuk menavigasi ke halaman lain
        Button btnDaftar = findViewById(R.id.btnDaftar);
        btnDaftar.setOnClickListener(v -> {
            Intent intent = new Intent(MainActivity.this, Registrasi.class);
            startActivity(intent);
        });

        Button btnDashboard = findViewById(R.id.btnDashboard);
        btnDashboard.setOnClickListener(v -> {
            // Memulai Fragment Dashboard di dalam FrameLayout
            Dashboard dashboardFragment = new Dashboard();

            // Memulai FragmentTransaction
            getSupportFragmentManager().beginTransaction()
                    .replace(R.id.fragment_container, dashboardFragment)  // Ganti R.id.fragment_container dengan ID container yang sesuai
                    .addToBackStack(null) // Jika ingin menambahkan ke back stack
                    .commit();
        });
        if (savedInstanceState == null) {
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.replace(R.id.framelinear, new Dashboard()); // Make sure 'frame' is the ID of your FrameLayout in activity_main.xml
            transaction.commit();
        }
    }
    public interface ResponseCallback {
        void onResponse(String response);

        void onError(Throwable throwable);
    }
}

package com.example.giziku;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentTransaction;
import androidx.viewpager2.widget.ViewPager2;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Dashboard extends Fragment {

    private long backPressedTime;
    private Toast backToast;

    private TextView tvUserName, tvProgram, tvWeight, tvCalorieTarget;
    private LinearLayout planningLayout, pelacakanLayout, konsultasiLayout, rekomendasiLayout, beritaLayout, lainnyaLayout;
    private HeaderPagerAdapter headerPagerAdapter;
    private ViewPager2 headerViewPager;
    private LinearLayout indicatorLayout;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.activity_dashboard, container, false);

        // Inisialisasi views
        initializeViews(view);

        // Setup logout
        setupLogoutButton(view);

        // Setup header ViewPager
        setupHeaderViewPager(view);

        // Setup user data
        setupUserData();

        // Setup bottom navigation
        setupBottomNavigation(view);

        // Setup menu click listeners
        setupMenuClickListeners(view);

        // Setup edit profile button
        setupEditProfileButton(view);

        return view;
    }

    private void setupLogoutButton(View view) {
        ImageView logoutButton = view.findViewById(R.id.btnLogout);
        logoutButton.setOnClickListener(v -> {
            // Membuat dialog konfirmasi logout
            new AlertDialog.Builder(requireContext())
                    .setMessage("Apakah Anda ingin logout akun?")
                    .setCancelable(false)
                    .setPositiveButton("Ya", (dialog, id) -> {
                        // Jika Ya, lakukan logout
                        SharedPreferences sharedPreferences = requireContext().getSharedPreferences("UserPreferences", Context.MODE_PRIVATE);
                        SharedPreferences.Editor editor = sharedPreferences.edit();
                        editor.putBoolean("isLoggedIn", false);
                        editor.apply();

                        Intent intent = new Intent(requireContext(), Login.class);
                        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                        requireActivity().finish();
                    })
                    .setNegativeButton("Tidak", (dialog, id) -> {
                        // Jika Tidak, hanya menutup dialog tanpa melakukan apa-apa
                        dialog.dismiss();
                    })
                    .create()
                    .show();
        });
    }

    private void setupHeaderViewPager(View view) {
        // Daftar gambar untuk ViewPager
        List<Integer> images = Arrays.asList(
                R.drawable.header_bg1,
                R.drawable.header_bg2
        );

        // Inisialisasi ViewPager dan Indikator
        headerViewPager = view.findViewById(R.id.headerViewPager);
        indicatorLayout = view.findViewById(R.id.indicatorLayout);
        ImageView indicatorLeft = indicatorLayout.findViewById(R.id.indicatorLeft);
        ImageView indicatorRight = indicatorLayout.findViewById(R.id.indicatorRight);

        // Buat adapter
        headerPagerAdapter = new HeaderPagerAdapter(requireContext(), images, indicatorLayout, headerViewPager);
        headerViewPager.setAdapter(headerPagerAdapter);

        // Tambahkan callback untuk mengupdate indikator
        headerViewPager.registerOnPageChangeCallback(new ViewPager2.OnPageChangeCallback() {
            @Override
            public void onPageSelected(int position) {
                super.onPageSelected(position);

                // Update indikator
                if (position == 0) {
                    indicatorLeft.setImageResource(R.drawable.indicator_active);
                    indicatorRight.setImageResource(R.drawable.indicator_inactive);
                } else {
                    indicatorLeft.setImageResource(R.drawable.indicator_inactive);
                    indicatorRight.setImageResource(R.drawable.indicator_active);
                }
            }
        });

        // Mulai auto slide
        headerPagerAdapter.startAutoSlide();
    }

    @Override
    public void onResume() {
        super.onResume();
        // Mulai ulang auto slide saat fragment di-resume
        if (headerPagerAdapter != null) {
            headerPagerAdapter.startAutoSlide();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        // Hentikan auto slide saat fragment tidak aktif
        if (headerPagerAdapter != null) {
            headerPagerAdapter.stopAutoSlide();
        }
    }

    private void initializeViews(View view) {
        tvUserName = view.findViewById(R.id.tvUserName);
        tvProgram = view.findViewById(R.id.tvProgram);
        tvWeight = view.findViewById(R.id.tvWeight);
        tvCalorieTarget = view.findViewById(R.id.tvCalorieTarget);

        // Inisialisasi layout menu
        planningLayout = view.findViewById(R.id.planningLayout);
        pelacakanLayout = view.findViewById(R.id.pelacakanLayout);
        konsultasiLayout = view.findViewById(R.id.konsultasiLayout);
        rekomendasiLayout = view.findViewById(R.id.rekomendasiLayout);
        beritaLayout = view.findViewById(R.id.beritaLayout);
        lainnyaLayout = view.findViewById(R.id.lainnyaLayout);
    }

    private void setupUserData() {
        // Ambil user ID dari FirebaseAuth
        String userId = FirebaseAuth.getInstance().getCurrentUser ().getUid();

        // Ambil data dari Firestore
        FirebaseFirestore db = FirebaseFirestore.getInstance();
        db.collection("users").document(userId).get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        DocumentSnapshot document = task.getResult();
                        if (document.exists()) {
                            // Ambil data dari document
                            String namaLengkap = document.getString("namaLengkap");
                            String tujuanKesehatan = document.getString("tujuanKesehatan");
                            String beratBadan = document.getString("beratBadan");
                            String kaloriTarget = "350"; // Anda bisa mengganti ini dengan logika yang sesuai

                            // Tampilkan data di TextView
                            tvUserName.setText(namaLengkap);
                            tvProgram.setText(tujuanKesehatan);
                            tvWeight.setText("Berat Sekarang " + beratBadan + " • ");
                            tvCalorieTarget.setText("Target Kalori Hari Ini " + kaloriTarget + " kcal");
                        } else {
                            Log.d("Dashboard", "No such document");
                        }
                    } else {
                        Log.d("Dashboard", "Get failed with ", task.getException());
                    }
                });
    }

    private void setupBottomNavigation(View view) {
        try {
            BottomNavigationView bottomNav = view.findViewById(R.id.bottom_navigation);
            if (bottomNav == null) {
                Log.e("BottomNavigation", "BottomNavigationView is null");
                return;
            }

            bottomNav.setOnNavigationItemSelectedListener(item -> {
                try {
                    int itemId = item.getItemId();

                    if (itemId == R.id.nav_home) {
                        // Current fragment, do nothing
                        FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
                        fr.replace(R.id.frame, new Dashboard());
                        fr.commit();
                        return true;
                    } else if (itemId == R.id.nav_rekomendasi) {
                        Log.d("BottomNavigation", "Rekomendasi selected");
                        FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
                        fr.replace(R.id.frame, new HomeActivity());
                        fr.commit();
                        return true;
                    } else if (itemId == R.id.nav_konsultasi) {
                        Log.d("BottomNavigation", "Konsultasi selected");
                        FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
                        fr.replace(R.id.frame, new chatbot());
                        fr.commit();
                        return true;
                    } else if (itemId == R.id.nav_progress) {
                        Log.d("BottomNavigation", "Progress selected");
                        // Handle Pelacakan dan Progres click
                        FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
                        fr.replace(R.id.frame, new WeightProgressChartFragment());
                        fr.commit();
                        return true;
                    }
                } catch (Exception e) {
                    Log.e("BottomNavigation", "Error in item selection", e);
                }
                return false;
            });
        } catch (Exception e) {
            Log.e("BottomNavigation", "Setup error", e);
        }
    }


    private void setupMenuClickListeners(View view) {
        planningLayout.setOnClickListener(v -> {
            // Handle Planning Kegiatan Kita click
        });

        pelacakanLayout.setOnClickListener(v -> {
            // Handle Pelacakan dan Progres click
            FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
            fr.replace(R.id.frame, new WeightProgressChartFragment());
            fr.commit();
        });

        konsultasiLayout.setOnClickListener(v -> {
            // Handle KonsultasiKu click
            FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
            fr.replace(R.id.frame, new chatbot());
            fr.commit();
        });

        rekomendasiLayout.setOnClickListener(v -> {
            // Handle Rekomendasi Pengguna click
            FragmentTransaction fr = requireActivity().getSupportFragmentManager().beginTransaction();
            fr.replace(R.id.frame, new HomeActivity());
            fr.commit();
        });

        beritaLayout.setOnClickListener(v -> {
            // Handle Berita Kesehatan click
        });

        lainnyaLayout.setOnClickListener(v -> {
            // Handle Berita Kesehatan click
        });
    }

    private void updateUserData(String name, String healthGoal, String weight, String calorieTarget) {
        // Ambil user ID dari FirebaseAuth
        String userId = FirebaseAuth.getInstance().getCurrentUser ().getUid();

        // Ambil instance Firestore
        FirebaseFirestore db = FirebaseFirestore.getInstance();

        // Buat map untuk data yang akan diperbarui
        Map<String, Object> userData = new HashMap<>();
        userData.put("namaLengkap", name);
        userData.put("tujuanKesehatan", healthGoal);
        userData.put("beratBadan", weight);
        // Anda bisa menambahkan kalori target jika ingin menyimpannya di Firestore

        // Update data di Firestore
        db.collection("users").document(userId)
                .update(userData)
                .addOnSuccessListener(aVoid -> {
                    Toast.makeText(requireContext(), "Data berhasil diperbarui", Toast.LENGTH_SHORT).show();
                })
                .addOnFailureListener(e -> {
                    Toast.makeText(requireContext(), "Gagal memperbarui data: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                });
    }

    private void setupEditProfileButton(View view) {
        ImageView editProfileButton = view.findViewById(R.id.btnEditProfile);
        editProfileButton.setOnClickListener(v -> {
            // Buat dialog custom
            AlertDialog.Builder builder = new AlertDialog.Builder(requireContext());
            View dialogView = getLayoutInflater().inflate(R.layout.dialog_edit_profile, null);
            builder.setView(dialogView);

            // Ambil referensi dari layout dialog
            EditText etName = dialogView.findViewById(R.id.etName);
            Spinner spHealthGoal = dialogView.findViewById(R.id.spHealthGoal);
            EditText etWeight = dialogView.findViewById(R.id.etWeight);
            EditText etCalorieTarget = dialogView.findViewById(R.id.etCalorieTarget);

            // Data awal untuk user
            etName.setText(tvUserName.getText());
            etWeight.setText(tvWeight.getText().toString().split(" ")[2]); // Extract weight value
            etCalorieTarget.setText(tvCalorieTarget.getText().toString().split(" ")[4]);

            // Setup tombol dialog
            builder.setPositiveButton("Simpan", (dialog, which) -> {
                // Ambil data baru dari EditText
                String name = etName.getText().toString();
                String healthGoal = spHealthGoal.getSelectedItem().toString();
                String weight = etWeight.getText().toString();
                String calorieTarget = etCalorieTarget.getText().toString();

                // Update UI
                if (!name.isEmpty()) tvUserName.setText("Halo, " + name);
                tvProgram.setText(healthGoal); // Update tujuan kesehatan
                if (!weight.isEmpty()) tvWeight.setText("Berat Sekarang " + weight + " • ");
                if (!calorieTarget.isEmpty()) tvCalorieTarget.setText("Target Kalori Hari Ini " + calorieTarget + " kcal");

                // Simpan data baru ke Firestore
                updateUserData(name, healthGoal, weight, calorieTarget);
            });

            builder.setNegativeButton("Batal", (dialog, which) -> dialog.dismiss());

            // Tampilkan dialog
            builder.create().show();
        });
    }
}
package com.example.giziku;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;
import android.app.DatePickerDialog;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.AuthResult;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

public class Registrasi extends AppCompatActivity {

    // Variabel untuk menyimpan data
    private String namaLengkap, emailPhone, password, tanggalLahir, jenisKelamin, tinggiBadan, beratBadan, aktivitasFisik, tujuanKesehatan;

    // FirebaseAuth instance
    private FirebaseAuth mAuth;
    private FirebaseFirestore db;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registrasi);

        // Initialize FirebaseAuth and Firestore
        mAuth = FirebaseAuth.getInstance();
        db = FirebaseFirestore.getInstance();

        // Mendapatkan referensi tombol kembali
        ImageButton backButton = findViewById(R.id.backButton);
        // Mendapatkan referensi TextView
        TextView registrasiText = findViewById(R.id.registrasiText);

        // Menambahkan listener untuk tombol kembali
        backButton.setOnClickListener(v -> {
            Intent intent = new Intent(Registrasi.this, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            finish();
        });

        // Menambahkan listener untuk TextView "Registrasi GiziKu"
        registrasiText.setOnClickListener(v -> {
            Intent intent = new Intent(Registrasi.this, MainActivity.class);
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            finish();
        });

        // Menambahkan fitur DatePickerDialog
        setupDatePicker();
        setupActivityLevelPicker();
        setupHealthGoalPicker();

        // Tombol Daftar
        findViewById(R.id.btnDaftar).setOnClickListener(v -> {
            ambilDataForm();

            if (semuaDataTerisi()) {
                // Simpan data ke Firebase Authentication
                mAuth.createUserWithEmailAndPassword(emailPhone, password)
                        .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            // Get the user ID
                            String userId = mAuth.getCurrentUser ().getUid();
                            // Save user data to Firestore
                            simpanKeDatabase(userId); // Call the new method to save data
                        } else {
                            Toast.makeText(Registrasi.this, "Registrasi gagal: " + task.getException().getMessage(), Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            } else {
                Toast.makeText(this, "Harap lengkapi semua data dengan benar", Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void setupDatePicker() {
        EditText edtTanggalLahir = findViewById(R.id.edtTanggalLahir);
        edtTanggalLahir.setOnClickListener(v -> {
            final Calendar calendar = Calendar.getInstance();
            int year = calendar.get(Calendar.YEAR);
            int month = calendar.get(Calendar.MONTH);
            int day = calendar.get(Calendar.DAY_OF_MONTH);

            DatePickerDialog datePickerDialog = new DatePickerDialog(this,
                    (view, selectedYear, selectedMonth, selectedDay) -> {
                        String selectedDate = selectedDay + "/" + (selectedMonth + 1) + "/" + selectedYear;
                        edtTanggalLahir.setText(selectedDate);
                    }, year, month, day);

            datePickerDialog.show();
        });
    }

    private void setupActivityLevelPicker() {
        EditText edtAktivitasFisik = findViewById(R.id.edtAktivitasFisik);
        edtAktivitasFisik.setOnClickListener(v -> {
            String[] activityLevels = {"Sedentary", "Aktivitas Ringan", "Aktivitas Berat"};
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle("Pilih Aktivitas Fisik Harian")
                    .setItems(activityLevels, (dialog, which) -> edtAktivitasFisik.setText(activityLevels[which]))
                    .show();
        });
    }

    private void setupHealthGoalPicker() {
        EditText edtTujuanKesehatan = findViewById(R.id.edtTujuanKesehatan);
        edtTujuanKesehatan.setOnClickListener(v -> {
            String[] healthGoals = {"Menaikkan Berat Badan", "Menurunkan Berat Badan", "Membentuk Massa Otot"};
            AlertDialog.Builder builder = new AlertDialog.Builder(this);
            builder.setTitle("Pilih Tujuan Kesehatan")
                    .setItems(healthGoals, (dialog, which) -> edtTujuanKesehatan.setText(healthGoals[which]))
                    .show();
        });
    }

    private void ambilDataForm() {
        namaLengkap = ((EditText) findViewById(R.id.edtNamaLengkap)).getText().toString();
        emailPhone = ((EditText) findViewById(R.id.edtEmailPhone)).getText().toString();
        password = ((EditText) findViewById(R.id.edtPassword)).getText().toString();
        tanggalLahir = ((EditText) findViewById(R.id.edtTanggalLahir)).getText().toString();

        RadioGroup radioGroup = findViewById(R.id.radioGroupGender);
        int selectedGenderId = radioGroup.getCheckedRadioButtonId();
        RadioButton selectedGenderButton = findViewById(selectedGenderId);
        jenisKelamin = selectedGenderButton != null ? selectedGenderButton.getText().toString() : "";

        tinggiBadan = ((EditText) findViewById(R.id.edtTinggiBadan)).getText().toString();
        beratBadan = ((EditText) findViewById(R.id.edtBeratBadan)).getText().toString();
        aktivitasFisik = ((EditText) findViewById(R.id.edtAktivitasFisik)).getText().toString();
        tujuanKesehatan = ((EditText) findViewById(R.id.edtTujuanKesehatan)).getText().toString();

        CheckBox checkBoxPersetujuan = findViewById(R.id.checkboxTerms);
        boolean isPersetujuanChecked = checkBoxPersetujuan.isChecked();

        if (!isPersetujuanChecked) {
            Toast.makeText(this, "Anda harus menyetujui syarat dan ketentuan", Toast.LENGTH_SHORT).show();
        }
    }

    private boolean semuaDataTerisi() {
        if (namaLengkap.isEmpty()) {
            Toast.makeText(this, "Nama lengkap tidak boleh kosong", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (emailPhone.isEmpty() || !emailPhone.contains("@")) {
            Toast.makeText(this, "Email tidak valid, harus mengandung '@'", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (password.isEmpty() || password.length() < 8) {
            Toast.makeText(this, "Password harus berisi minimal 8 karakter", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (tanggalLahir.isEmpty()) {
            Toast.makeText(this, "Tanggal lahir tidak boleh kosong", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (jenisKelamin.isEmpty()) {
            Toast.makeText(this, "Jenis kelamin harus dipilih", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (tinggiBadan.isEmpty()) {
            Toast.makeText(this, "Tinggi badan tidak boleh kosong", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (beratBadan.isEmpty()) {
            Toast.makeText(this, "Berat badan tidak boleh kosong", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (aktivitasFisik.isEmpty()) {
            Toast.makeText(this, "Aktivitas fisik harus dipilih", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (tujuanKesehatan.isEmpty()) {
            Toast.makeText(this, "Tujuan kesehatan harus dipilih", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (!((CheckBox) findViewById(R.id.checkboxTerms)).isChecked()) {
            Toast.makeText(this, "Anda harus menyetujui syarat dan ketentuan", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    private void simpanKeDatabase(String userId) {
        // Create a map to hold user data
        Map<String, Object> userData = new HashMap<>();
        userData.put("namaLengkap", namaLengkap);
        userData.put("emailPhone", emailPhone);
        userData.put("tanggalLahir", tanggalLahir);
        userData.put("jenisKelamin", jenisKelamin);
        userData.put("tinggiBadan", tinggiBadan);
        userData.put("beratBadan", beratBadan);
        userData.put("aktivitasFisik", aktivitasFisik);
        userData.put("tujuanKesehatan", tujuanKesehatan);

        // Save the data to Firestore
        db.collection("users").document(userId) // Use userId as document ID
                .set(userData)
                .addOnSuccessListener(aVoid -> {
                    Toast.makeText(Registrasi.this, "Data berhasil disimpan", Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(Registrasi.this, Login.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                    startActivity(intent);
                    finish();
                })
                .addOnFailureListener(e -> {
                    Toast.makeText(Registrasi.this, "Gagal menyimpan data: " + e.getMessage(), Toast.LENGTH_SHORT).show();
                });
    }
}
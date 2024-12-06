package com.example.giziku;

import android.content.Intent;
import android.content.SharedPreferences;
import android.app.DatePickerDialog;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

import java.util.HashSet;
import java.util.Set;

import androidx.appcompat.app.AppCompatActivity;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.Calendar;

public class LaporanProgresActivity extends AppCompatActivity {

    private static final String TAG = "LaporanProgresActivity";

    private EditText edtBeratBadan, edtTanggalPengisian, edtNotes;
    private RadioGroup rgPernahSakit, rgMood;
    private RadioButton rbBahagia, rbSedih;
    private Button btnUploadFoto, btnSelesai;
    private ImageView imgPreview;
    private FirebaseFirestore db;

    private SharedPreferences sharedPreferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.laporan_progres);
        db = FirebaseFirestore.getInstance();
        // Inisialisasi elemen UI
        initializeViews();

        // Initialize SharedPreferences untuk menyimpan data
        sharedPreferences = getSharedPreferences("LaporanProgres", MODE_PRIVATE);

        // Set up listeners
        setupListeners();
    }

    private void initializeViews() {
        edtBeratBadan = findViewById(R.id.edtBeratBadan);
        rgPernahSakit = findViewById(R.id.rgPernahSakit);
        edtTanggalPengisian = findViewById(R.id.edtTanggalPengisian);
        edtNotes = findViewById(R.id.edtNotes);
        rgMood = findViewById(R.id.rgMood);
        rbBahagia = findViewById(R.id.rbBahagia);
        rbSedih = findViewById(R.id.rbSedih);
        btnUploadFoto = findViewById(R.id.btnUploadFoto);
        imgPreview = findViewById(R.id.imgPreview);
        btnSelesai = findViewById(R.id.btnSelesai);
    }

    private void setupListeners() {
        // Tanggal Picker untuk EditText Tanggal Pengisian
        edtTanggalPengisian.setOnClickListener(v -> showDatePicker());

        // Tombol Upload Foto
        btnUploadFoto.setOnClickListener(v -> {
            // Logika untuk upload foto (placeholder)
            Toast.makeText(this, "Fitur Upload Foto dalam pengembangan!", Toast.LENGTH_SHORT).show();
        });

        // Tombol Selesai
        btnSelesai.setOnClickListener(v -> {
            try {
                submitForm();
            } catch (Exception e) {
                Log.e(TAG, "Error submitting form", e);
                Toast.makeText(this, "Terjadi kesalahan saat menyimpan data", Toast.LENGTH_SHORT).show();
            }
        });

        // Tombol Back di Toolbar
        ImageView btnBack = findViewById(R.id.btnBack);
        btnBack.setOnClickListener(v -> finish());
    }

    // Fungsi untuk menampilkan DatePicker
    private void showDatePicker() {
        final Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog datePickerDialog = new DatePickerDialog(
                this,
                (view, year1, month1, dayOfMonth) -> {
                    String selectedDate = dayOfMonth + "/" + (month1 + 1) + "/" + year1;
                    edtTanggalPengisian.setText(selectedDate);
                },
                year, month, day
        );
        datePickerDialog.show();
    }

    // Fungsi untuk validasi dan submit form
    private void submitForm() {
        // Ambil data dari input
        String beratBadan = edtBeratBadan.getText().toString();
        String tanggalPengisian = edtTanggalPengisian.getText().toString();
        String notes = edtNotes.getText().toString();

        // Validasi input dasar
        if (beratBadan.isEmpty() || tanggalPengisian.isEmpty()) {
            Toast.makeText(this, "Harap isi semua data dengan lengkap!", Toast.LENGTH_SHORT).show();
            return;
        }

        // Ambil data Pernah Sakit dari RadioGroup
        int selectedPernahSakitId = rgPernahSakit.getCheckedRadioButtonId();
        if (selectedPernahSakitId == -1) {
            Toast.makeText(this, "Harap pilih apakah Anda pernah sakit!", Toast.LENGTH_SHORT).show();
            return;
        }
        RadioButton rbPernahSakit = findViewById(selectedPernahSakitId);
        String pernahSakit = rbPernahSakit.getText().toString();

        // Ambil mood yang dipilih
        int selectedMoodId = rgMood.getCheckedRadioButtonId();
        if (selectedMoodId == -1) {
            Toast.makeText(this, "Harap pilih mood Anda!", Toast.LENGTH_SHORT).show();
            return;
        }
        RadioButton rbMood = findViewById(selectedMoodId);
        String mood = rbMood.getText().toString();

        // Log data sebelum penyimpanan
        Log.d(TAG, "Preparing to save data: " +
                "Weight: " + beratBadan +
                ", Date: " + tanggalPengisian +
                ", Mood: " + mood +
                ", Ever Sick: " + pernahSakit);

        // Retrieve the user ID
        String userId = FirebaseAuth.getInstance().getCurrentUser ().getUid();

        // Buat objek data untuk disimpan
        LaporanProgres laporanProgres = new LaporanProgres(userId, beratBadan, tanggalPengisian, mood, pernahSakit, notes);

        // Simpan data ke Firestore
        db.collection("laporan_progres")
                .add(laporanProgres)
                .addOnSuccessListener(documentReference -> {
                    Log.d(TAG, "DocumentSnapshot added with ID: " + documentReference.getId());
                    Toast.makeText(this, "Data berhasil disimpan!", Toast.LENGTH_SHORT).show();
                    resetForm();
                    finish();
                })
                .addOnFailureListener(e -> {
                    Log.e(TAG, "Error adding document", e);
                    Toast.makeText(this, "Gagal menyimpan data!", Toast.LENGTH_SHORT).show();
                });
    }

    // Fungsi untuk mereset form
    private void resetForm() {
        edtBeratBadan.setText("");
        edtTanggalPengisian.setText("");
        edtNotes.setText("");
        rgPernahSakit.clearCheck();
        rgMood.clearCheck();
    }
}
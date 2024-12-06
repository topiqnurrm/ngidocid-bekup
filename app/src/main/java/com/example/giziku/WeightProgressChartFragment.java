package com.example.giziku;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;

import com.github.mikephil.charting.charts.LineChart;
import com.github.mikephil.charting.components.Description;
import com.github.mikephil.charting.components.XAxis;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.LineData;
import com.github.mikephil.charting.data.LineDataSet;
import com.github.mikephil.charting.formatter.IndexAxisValueFormatter;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.QueryDocumentSnapshot;
import com.google.firebase.firestore.QuerySnapshot;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import android.app.AlertDialog;

public class WeightProgressChartFragment extends Fragment {

    private static final String TAG = "WeightProgressChartFragment";
    private View rootView;
    private LineChart weightChart;
    private FirebaseFirestore db;
    private SimpleDateFormat dateFormat;

    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        rootView = inflater.inflate(R.layout.grafik_progres, container, false);

        // Initialize Firestore
        db = FirebaseFirestore.getInstance();

        // Initialize date formatter
        dateFormat = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());

        // Initialize views
        weightChart = rootView.findViewById(R.id.weightProgressChart);

        // Find buttons
        Button btnLaporkanProgress = rootView.findViewById(R.id.btnLaporkanProgress);
        Button btnRefreshGrafik = rootView.findViewById(R.id.btnRefreshGrafik);
        Button btnResetGrafik = rootView.findViewById(R.id.btnResetGrafik);

        // Set OnClickListener for buttons
        btnLaporkanProgress.setOnClickListener(v -> {
            Intent intent = new Intent(getActivity(), LaporanProgresActivity.class);
            startActivity(intent);
        });

        btnRefreshGrafik.setOnClickListener(v -> refreshWeightChart());
        btnResetGrafik.setOnClickListener(v -> resetWeightChart());

        // Load and display chart
        setupWeightChart();

        return rootView; // Return the root view of the fragment
    }

    private void refreshWeightChart() {
        setupWeightChart();
        Log.d(TAG, "Grafik berhasil di-refresh");
    }

    private void resetWeightChart() {
        new AlertDialog.Builder(requireContext())
                .setTitle("Reset Grafik")
                .setMessage("Apakah Anda yakin ingin mereset grafik? Semua data progress berat badan akan dihapus.")
                .setPositiveButton("Ya", (dialog, which) -> {
                    // Hapus semua entri berat badan dari Firestore
                    String userId = FirebaseAuth.getInstance().getCurrentUser ().getUid();
                    db.collection("laporan_progres").document(userId).delete()
                            .addOnSuccessListener(aVoid -> {
                                weightChart.clear();
                                weightChart.invalidate();
                                Log.d(TAG, "Grafik berhasil di-reset");
                            })
                            .addOnFailureListener(e -> Log.e(TAG, "Error resetting chart", e));
                })
                .setNegativeButton("Tidak", (dialog, which) -> dialog.dismiss())
                .setCancelable(true)
                .show();
    }

    private void setupWeightChart() {
        // Retrieve the user ID
        String userId = FirebaseAuth.getInstance().getCurrentUser ().getUid();

        // Fetch weight entries from Firestore for the current user
        db.collection("laporan_progres")
                .whereEqualTo("userId", userId)
                .get()
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        List<WeightEntry> sortedEntries = new ArrayList<>();
                        for (QueryDocumentSnapshot document : task.getResult()) {
                            String beratBadan = document.getString("beratBadan");
                            String tanggalPengisian = document.getString("tanggalPengisian");
                            try {
                                float weight = Float.parseFloat(beratBadan);
                                Date date = dateFormat.parse(tanggalPengisian);
                                sortedEntries.add(new WeightEntry(weight, date, tanggalPengisian));
                            } catch (NumberFormatException | ParseException e) {
                                Log.e(TAG, "Error parsing entry: " + document.getId(), e);
                            }
                        }

                        // Sort entries by date in ascending order (oldest to newest)
                        Collections.sort(sortedEntries, (e1, e2) -> e1.date.compareTo(e2.date));

                        // Prepare chart data
                        ArrayList<Entry> entries = new ArrayList<>();
                        ArrayList<String> dateLabels = new ArrayList<>();

                        for (int index = 0; index < sortedEntries.size(); index++) {
                            WeightEntry entry = sortedEntries.get(index);
                            entries.add(new Entry(index, entry.weight));
                            dateLabels.add(entry.dateString);
                        }

                        // Create dataset
                        LineDataSet dataSet = new LineDataSet(entries, "Berat Badan");
                        dataSet.setColor(Color.BLUE);
                        dataSet.setValueTextColor(Color.BLACK);
                        dataSet.setLineWidth(2f);
                        dataSet.setCircleColor(Color.BLUE);
                        dataSet.setCircleRadius(4f);
                        dataSet.setDrawValues(true); // Show weight values on chart

                        // Create line data
                        LineData lineData = new LineData(dataSet);
                        weightChart.setData(lineData);

                        // Customize X-axis
                        XAxis xAxis = weightChart.getXAxis();
                        xAxis.setPosition(XAxis.XAxisPosition.BOTTOM);
                        xAxis.setValueFormatter(new IndexAxisValueFormatter(dateLabels));
                        xAxis.setGranularity(1f);
                        xAxis.setLabelRotationAngle(45f);
                        xAxis.setAxisMaximum(sortedEntries.size() - 1 + 0.5f); // Add some padding on the right
                        xAxis.setAxisMinimum(-0.5f); // Add some padding on the left

                        // Customize description
                        Description description = new Description();
                        description.setText("Progres Berat Badan");
                        description.setTextSize(12f);
                        weightChart.setDescription(description);

                        // Additional chart customizations
                        weightChart.setTouchEnabled(true);
                        weightChart.setDragEnabled(true);
                        weightChart.setScaleEnabled(true);
                        weightChart.setPinchZoom(true);

                        // Refresh chart
                        weightChart.invalidate();
                    } else {
                        Log.e(TAG, "Error getting documents: ", task.getException());
                    }
                });
    }

    // Inner class to represent a weight entry with date
    private static class WeightEntry {
        float weight;
        Date date;
        String dateString;

        WeightEntry(float weight, Date date, String dateString) {
            this.weight = weight;
            this.date = date;
            this.dateString = dateString;
        }
    }
}
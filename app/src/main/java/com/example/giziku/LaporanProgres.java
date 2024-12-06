package com.example.giziku;

public class LaporanProgres {
    private String userId; // Add userId field
    private String beratBadan;
    private String tanggalPengisian;
    private String mood;
    private String pernahSakit;
    private String notes;

    public LaporanProgres() {
        // Firestore requires a public no-argument constructor
    }

    public LaporanProgres(String userId, String beratBadan, String tanggalPengisian, String mood, String pernahSakit, String notes) {
        this.userId = userId; // Initialize userId
        this.beratBadan = beratBadan;
        this.tanggalPengisian = tanggalPengisian;
        this.mood = mood;
        this.pernahSakit = pernahSakit;
        this.notes = notes;
    }

    public String getUserId() {
        return userId;
    }

    public String getBeratBadan() {
        return beratBadan;
    }

    public String getTanggalPengisian() {
        return tanggalPengisian;
    }

    public String getMood() {
        return mood;
    }

    public String getPernahSakit() {
        return pernahSakit;
    }

    public String getNotes() {
        return notes;
    }
}
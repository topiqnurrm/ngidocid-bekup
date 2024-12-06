package com.example.giziku.models;

import android.os.Parcel;
import android.os.Parcelable;

public class Chapter implements Parcelable {
    public int id;
    public String chapterName;
    public String imageUrl;
    public String chapterDescription;

    // Constructor default
    public Chapter() {}

    // Constructor yang digunakan untuk membaca data dari Parcel
    protected Chapter(Parcel in) {
        id = in.readInt(); // Membaca id
        chapterName = in.readString(); // Membaca nama chapter
        imageUrl = in.readString(); // Membaca URL gambar
        chapterDescription = in.readString(); // Membaca deskripsi chapter
    }

    // Creator untuk Parcelable
    public static final Creator<Chapter> CREATOR = new Creator<Chapter>() {
        @Override
        public Chapter createFromParcel(Parcel in) {
            return new Chapter(in); // Mengembalikan objek Chapter
        }

        @Override
        public Chapter[] newArray(int size) {
            return new Chapter[size]; // Mengembalikan array Chapter
        }
    };

    // Metode untuk mendeskripsikan konten
    @Override
    public int describeContents() {
        return 0; // Tidak ada konten khusus yang perlu dideskripsikan
    }

    // Metode untuk menulis data ke Parcel
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id); // Menulis id ke Parcel
        dest.writeString(chapterName); // Menulis nama chapter ke Parcel
        dest.writeString(imageUrl); // Menulis URL gambar ke Parcel
        dest.writeString(chapterDescription); // Menulis deskripsi chapter ke Parcel)
    }
}
package com.example.giziku;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager2.widget.ViewPager2;

import java.util.List;

public class HeaderPagerAdapter extends RecyclerView.Adapter<HeaderPagerAdapter.ViewHolder> {
    private final List<Integer> images;
    private final Context context;
    private final LinearLayout indicatorLayout;
    private final ViewPager2 viewPager;

    // Handler untuk auto sliding
    private final Handler autoSlideHandler = new Handler(Looper.getMainLooper());
    private Runnable autoSlideRunnable;

    public HeaderPagerAdapter(Context context, List<Integer> images, LinearLayout indicatorLayout, ViewPager2 viewPager) {
        this.context = context;
        this.images = images;
        this.indicatorLayout = indicatorLayout;
        this.viewPager = viewPager;

        // Inisialisasi auto slide runnable
        initAutoSlideRunnable();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_header_image, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        // Set gambar untuk setiap halaman
        holder.imageView.setImageResource(images.get(position));
    }

    @Override
    public int getItemCount() {
        return images.size();
    }

    // Metode untuk memulai auto slide
    public void startAutoSlide() {
        // Hentikan terlebih dahulu callback sebelumnya untuk menghindari multiple callbacks
        stopAutoSlide();
        autoSlideHandler.postDelayed(autoSlideRunnable, 3000);
    }

    // Metode untuk menghentikan auto slide
    public void stopAutoSlide() {
        autoSlideHandler.removeCallbacks(autoSlideRunnable);
    }

    // Inisialisasi auto slide runnable
    private void initAutoSlideRunnable() {
        autoSlideRunnable = new Runnable() {
            @Override
            public void run() {
                int currentItem = viewPager.getCurrentItem();
                int nextItem = (currentItem + 1) % images.size();
                viewPager.setCurrentItem(nextItem, true);

                // Jadwalkan ulang auto slide
                autoSlideHandler.postDelayed(this, 3000);
            }
        };
    }

    // ViewHolder untuk menampung ImageView
    static class ViewHolder extends RecyclerView.ViewHolder {
        ImageView imageView;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.imageView);
        }
    }

    // Metode tambahan untuk mendapatkan jumlah gambar
    public int getImageCount() {
        return images.size();
    }
}
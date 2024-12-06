package com.example.giziku;

import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.example.giziku.models.Chapter;
import com.squareup.picasso.Picasso;

public class ChapterDetailActivity extends AppCompatActivity {
    private TextView tvChapterName;
    private ImageView ivChapterImage;
    private TextView tvChapterDescription;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chapter_detail);

        tvChapterName = findViewById(R.id.tvChapterName);
        ivChapterImage = findViewById(R.id.ivChapterImage);
        tvChapterDescription = findViewById(R.id.tvChapterDescription);

        Chapter chapter = getIntent().getParcelableExtra("chapter");
        if (chapter != null) {
            tvChapterName.setText(chapter.chapterName);
            Picasso.get().load(chapter.imageUrl).into(ivChapterImage);
            tvChapterDescription.setText(chapter.chapterDescription);
        }
    }
}
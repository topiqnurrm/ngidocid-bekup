package com.example.giziku.adapters;

import android.content.Context;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.example.giziku.OnChapterClickListener;
import com.example.giziku.R;
import com.example.giziku.models.Subject;

import java.util.ArrayList;


public class SubjectAdapter extends RecyclerView.Adapter<SubjectAdapter.ViewHolder> {

    public ArrayList<Subject> subjects;
    private Context context;
    private LayoutInflater layoutInflater;
    private OnChapterClickListener listener;

    public SubjectAdapter(ArrayList<Subject> subjects, Context context, OnChapterClickListener listener) {
        this.subjects = subjects;
        this.context = context;
        this.layoutInflater = LayoutInflater.from(context);
        this.listener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = layoutInflater.inflate(R.layout.single_subject, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        holder.recyclerView.setAdapter(new ChapterAdapter(context, subjects.get(position).chapters, listener));
        holder.recyclerView.setLayoutManager(new LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false));
        holder.recyclerView.setHasFixedSize(true);
        holder.tvHeading.setText(subjects.get(position).subjectName);
    }

    @Override
    public int getItemCount() {
        return subjects.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {

        RecyclerView recyclerView;
        TextView tvHeading;

        public ViewHolder(View itemView) {
            super(itemView);

            recyclerView = (RecyclerView) itemView.findViewById(R.id.rvChapters);
            tvHeading = (TextView) itemView.findViewById(R.id.tvSubjectName);
        }
    }
}
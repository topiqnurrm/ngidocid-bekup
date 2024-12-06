package com.example.giziku;

import static androidx.appcompat.content.res.AppCompatResources.getDrawable;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;

import com.google.ai.client.generativeai.java.ChatFutures;
import com.google.ai.client.generativeai.java.GenerativeModelFutures;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.textfield.TextInputEditText;

public class chatbot extends Fragment {
    FloatingActionButton btnShowDialog;
    Dialog dialog;
    private TextInputEditText queryEditText;
    private ImageView sendQuery, appIcon;
    private ProgressBar progressBar;
    private LinearLayout chatResponse;
    private ChatFutures chatModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.activity_chatbot, container, false);

        dialog = new Dialog(requireContext());
        dialog.setContentView(R.layout.message_dialog);

        if (dialog.getWindow() != null) {
            dialog.getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            dialog.setCancelable(false);
        }

        sendQuery = dialog.findViewById(R.id.sendMessage);
        queryEditText = dialog.findViewById(R.id.queryEditText);

        btnShowDialog = view.findViewById(R.id.showMessageDialog);
        progressBar = view.findViewById(R.id.progressBar);
        chatResponse = view.findViewById(R.id.chatResponse);
        appIcon = view.findViewById(R.id.appIcon);
        chatModel = getChatModel();

        btnShowDialog.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.show();
            }
        });

        sendQuery.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.dismiss();
                progressBar.setVisibility(View.VISIBLE);
                appIcon.setVisibility(View.GONE);
                String query = queryEditText.getText().toString();
                queryEditText.setText("");
                chatBody("You", query, ContextCompat.getDrawable(requireContext(), R.drawable.ic_launcher_foreground));

                GeminiResp.getResponse(chatModel, query, new MainActivity.ResponseCallback() {
                    @Override
                    public void onResponse(String response) {
                        progressBar.setVisibility(View.GONE);
                        chatBody("AI", response, ContextCompat.getDrawable(requireContext(), R.drawable.ic_launcher_foreground));
                    }

                    @Override
                    public void onError(Throwable throwable) {
                        chatBody("AI", "Please try again later", ContextCompat.getDrawable(requireContext(), R.drawable.ic_launcher_foreground));
                        progressBar.setVisibility(View.GONE);
                    }
                });
            }
        });

        return view;
    }

    private ChatFutures getChatModel() {
        GeminiResp model = new GeminiResp();
        GenerativeModelFutures modelFutures = model.getModel();
        return modelFutures.startChat();
    }

    private void chatBody(String userName, String query, Drawable image) {
        LayoutInflater inflater = (LayoutInflater) requireContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflater.inflate(R.layout.chat_message, null);

        TextView name = view.findViewById(R.id.name);
        TextView message = view.findViewById(R.id.message);
        ImageView logo = view.findViewById(R.id.logo);

        name.setText(userName);
        message.setText(query);
        logo.setImageDrawable(image);

        chatResponse.addView(view);

        ScrollView scrollView = requireView().findViewById(R.id.scrollView);
        scrollView.post(() -> scrollView.fullScroll(ScrollView.FOCUS_DOWN));
    }
}
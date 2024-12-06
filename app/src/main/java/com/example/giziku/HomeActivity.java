package com.example.giziku;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.example.giziku.adapters.SubjectAdapter;
import com.example.giziku.models.Chapter;
import com.example.giziku.models.Subject;

import java.util.ArrayList;

public class HomeActivity extends Fragment {

    private RecyclerView rvSubject;
    private SubjectAdapter subjectAdapter;
    private ArrayList<Subject> subjects;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_home_activity, container, false);

        // Initialize components
        rvSubject = view.findViewById(R.id.rvSubject);
        subjects = prepareData();

        subjectAdapter = new SubjectAdapter(subjects, getContext(), this::onChapterClick);
        LinearLayoutManager manager = new LinearLayoutManager(getContext());
        rvSubject.setLayoutManager(manager);
        rvSubject.setAdapter(subjectAdapter);

        return view;
    }

    private void onChapterClick(Chapter chapter) {
        // Navigate to ChapterDetailActivity with the selected chapter
        Intent intent = new Intent(getContext(), ChapterDetailActivity.class);
        intent.putExtra("chapter", chapter); // Ensure Chapter implements Parcelable
        startActivity(intent);
    }

    private ArrayList<Subject> prepareData() {
        ArrayList<Subject> subjects = new ArrayList<>();

        Subject physics = new Subject();
        physics.id = 1;
        physics.subjectName = "Sarapan";
        physics.chapters = new ArrayList<Chapter>();

        Chapter chapter1 = new Chapter();
        chapter1.id = 1;
        chapter1.chapterName = "Bubur Ayam";
        chapter1.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/a/a8/Bubur_ayam_chicken_porridge.JPG";
        chapter1.chapterDescription = "Bubur ayam adalah hidangan khas Indonesia yang terdiri dari bubur nasi yang lembut dengan taburan ayam suwir, bawang goreng, daun seledri, dan berbagai pelengkap seperti kerupuk, sambal, dan kecap. Secara gizi, bubur ayam kaya akan karbohidrat dari nasi, protein dari ayam dan telur (jika ditambahkan), serta lemak dari minyak goreng dan kerupuk. Hidangan ini juga mengandung vitamin dan mineral dari sayuran pelengkap seperti seledri dan daun bawang, meskipun kandungan seratnya relatif rendah.\n" +
                "\n" +
                "Bubur ayam sering dianggap makanan yang mudah dicerna, cocok untuk orang yang sedang sakit atau membutuhkan makanan ringan. Namun, tingginya kandungan natrium dari kecap dan kaldu instan bisa menjadi perhatian, terutama bagi penderita tekanan darah tinggi. Dengan sedikit modifikasi, seperti menggunakan nasi merah, menambahkan lebih banyak sayuran, dan mengurangi bumbu instan, bubur ayam dapat menjadi pilihan makanan yang lebih sehat.\n"+"\n"+"Resep Bubur Ayam\n" +
                "Bahan Bubur:\n" +
                "\n" +
                "    1 cup beras (cuci bersih)\n" +
                "    6 cup air (untuk memasak nasi)\n" +
                "    1 batang serai, memarkan\n" +
                "    2 lembar daun salam\n" +
                "    1 sdt garam\n" +
                "\n" +
                "Bahan Ayam:\n" +
                "\n" +
                "    2 potong dada ayam (atau bagian ayam lain sesuai selera)\n" +
                "    1 batang serai, memarkan\n" +
                "    2 lembar daun salam\n" +
                "    1 sdt garam\n" +
                "    1/2 sdt merica bubuk\n" +
                "    2 sdm minyak goreng (untuk menumis)\n" +
                "\n" +
                "Bumbu Halus (untuk ayam):\n" +
                "\n" +
                "    4 siung bawang merah\n" +
                "    3 siung bawang putih\n" +
                "    1 cm jahe\n" +
                "    1/2 sdt ketumbar\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Kacang kedelai goreng\n" +
                "    Bawang goreng\n" +
                "    Kerupuk\n" +
                "    Sambal (opsional)\n" +
                "    Daun bawang, iris halus\n" +
                "    Kecap manis\n" +
                "\n" +
                "Cara Membuat Bubur Ayam:\n" +
                "\n" +
                "    Memasak Bubur:\n" +
                "        Rebus beras dengan air, serai, daun salam, dan garam dalam panci hingga menjadi bubur lembut. Aduk sesekali agar nasi tidak menggumpal. Jika terlalu kental, tambahkan sedikit air. Masak hingga nasi menjadi bubur dan semua bahan tercampur rata.\n" +
                "\n" +
                "    Membuat Ayam Suwir:\n" +
                "        Rebus dada ayam dengan serai, daun salam, garam, dan merica hingga ayam matang. Angkat ayam, tiriskan, dan suwir-suwir daging ayamnya.\n" +
                "        Haluskan bawang merah, bawang putih, jahe, dan ketumbar. Tumis bumbu halus dengan minyak goreng hingga harum, lalu masukkan ayam suwir. Aduk rata dan masak sebentar agar bumbu meresap ke ayam.\n" +
                "\n" +
                "    Menyajikan Bubur Ayam:\n" +
                "        Siapkan mangkuk, lalu tuangkan bubur nasi ke dalamnya.\n" +
                "        Tambahkan ayam suwir bumbu di atas bubur.\n" +
                "        Taburi dengan bawang goreng, daun bawang iris, kacang kedelai goreng, dan kerupuk.\n" +
                "        Sajikan dengan sambal dan kecap manis sesuai selera.\n" +
                "\n" +
                "Bubur ayam siap dinikmati! Nikmati hidangan yang hangat dan gurih ini, cocok untuk sarapan atau makan siang. ";

        Chapter chapter2 = new Chapter();
        chapter2.id = 2;
        chapter2.chapterName = "Nasi Uduk";
        chapter2.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/a/a6/Nasi_uduk_netherlands.jpg";
        chapter2.chapterDescription = "Nasi uduk adalah hidangan khas Indonesia yang dibuat dari nasi yang dimasak dengan santan, daun pandan, daun salam, dan serai, menciptakan rasa gurih dan aroma harum. Hidangan ini biasanya disajikan dengan berbagai lauk-pauk seperti ayam goreng, telur balado, tempe atau tahu goreng, sambal, kerupuk, dan irisan mentimun, serta taburan bawang goreng yang menambah cita rasa dan tekstur.\n" +
                "\n" +
                "Secara gizi, nasi uduk mengandung karbohidrat sebagai sumber energi dari nasi, protein dari lauk-pauk seperti ayam, telur, tahu, atau tempe, dan lemak yang berasal dari santan serta minyak goreng. Hidangan ini juga menyediakan vitamin dan mineral dari pelengkap seperti mentimun dan sambal, meskipun kandungan seratnya cenderung rendah. Namun, tingginya kadar lemak jenuh dari santan dan minyak, serta natrium dari sambal dan kerupuk, dapat menjadi perhatian jika dikonsumsi secara berlebihan.\n" +
                "\n" +
                "Untuk membuat nasi uduk lebih sehat, santan dapat diganti dengan santan rendah lemak, lauk goreng dapat diolah dengan cara panggang atau kukus, dan tambahan sayuran segar seperti lalapan dapat meningkatkan kandungan seratnya. Dengan modifikasi ini, nasi uduk tetap lezat dan lebih seimbang secara nutrisi.\n"+"\n"+"Resep Nasi Uduk\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    2 cup beras (cuci bersih)\n" +
                "    400 ml santan kental (dari 1 kelapa atau santan kotak)\n" +
                "    2 lembar daun pandan, simpulkan\n" +
                "    2 lembar daun salam\n" +
                "    1 batang serai, memarkan\n" +
                "    1 sdt garam\n" +
                "    1 sdm minyak kelapa atau minyak goreng (untuk menumis)\n" +
                "    500 ml air (untuk memasak nasi)\n" +
                "\n" +
                "Bumbu Halus:\n" +
                "\n" +
                "    4 siung bawang merah\n" +
                "    3 siung bawang putih\n" +
                "    1 cm jahe\n" +
                "    1/2 sdt ketumbar\n" +
                "    1/2 sdt merica bubuk\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Ayam goreng (atau ayam panggang)\n" +
                "    Telur rebus, belah dua\n" +
                "    Tempe goreng\n" +
                "    Sambal (opsional)\n" +
                "    Kerupuk\n" +
                "    Timun, iris tipis\n" +
                "\n" +
                "Cara Membuat Nasi Uduk:\n" +
                "\n" +
                "    Menyiapkan Bumbu:\n" +
                "        Haluskan bawang merah, bawang putih, jahe, ketumbar, dan merica menggunakan blender atau ulekan hingga halus.\n" +
                "\n" +
                "    Membuat Nasi Uduk:\n" +
                "        Panaskan minyak dalam wajan, tumis bumbu halus hingga harum dan matang.\n" +
                "        Masukkan daun pandan, daun salam, dan serai. Aduk sebentar hingga harum.\n" +
                "        Tambahkan santan dan garam. Aduk rata dan biarkan mendidih sebentar.\n" +
                "        Masukkan beras yang sudah dicuci bersih ke dalam rice cooker atau panci.\n" +
                "        Tuangkan air santan dan bumbu tumisan ke dalam beras. Aduk rata.\n" +
                "        Masak nasi seperti biasa menggunakan rice cooker atau panci, pastikan nasi matang dengan sempurna dan harum.\n" +
                "\n" +
                "    Menyajikan Nasi Uduk:\n" +
                "        Setelah nasi matang, aduk perlahan agar bumbu tercampur rata.\n" +
                "        Sajikan nasi uduk hangat di atas piring atau nampan.\n" +
                "        Tambahkan lauk pelengkap seperti ayam goreng, telur rebus, tempe goreng, sambal, kerupuk, dan irisan timun di atasnya.\n" +
                "\n" +
                "Nasi uduk siap dinikmati! Nikmati rasanya yang gurih dan aromanya yang menggoda, cocok untuk sarapan atau makan siang. ";

        Chapter chapter3 = new Chapter();
        chapter3.id = 3;
        chapter3.chapterName = "Lontong Sayur";
        chapter3.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Lontong_sayur_without_spoon.JPG/800px-Lontong_sayur_without_spoon.JPG";
        chapter3.chapterDescription = "Lontong sayur adalah hidangan tradisional Indonesia yang terdiri dari lontong, yaitu nasi yang dimasak dalam daun pisang hingga berbentuk padat dan kenyal, disajikan dengan kuah santan yang gurih dan berisi aneka sayuran seperti labu siam, kacang panjang, atau nangka muda. Hidangan ini biasanya dilengkapi dengan telur rebus, tahu, tempe, kerupuk, sambal, dan taburan bawang goreng untuk menambah cita rasa.\n" +
                "\n" +
                "Secara gizi, lontong sayur mengandung karbohidrat dari lontong sebagai sumber energi utama, protein dari telur, tahu, atau tempe, dan lemak dari kuah santan serta minyak yang digunakan untuk menumis bumbu. Sayuran dalam kuah menyumbang vitamin, mineral, dan serat, meskipun jumlahnya sering tidak terlalu banyak. Hidangan ini memiliki rasa gurih yang khas, namun santan dan pelengkap seperti kerupuk dapat meningkatkan kadar lemak dan natrium, sehingga konsumsi dalam jumlah sedang lebih disarankan.\n" +
                "\n" +
                "Lontong sayur adalah pilihan makanan yang cocok untuk sarapan atau makan siang, dengan rasa kaya rempah dan tekstur yang beragam, mencerminkan kekayaan kuliner Indonesia.\n"+"\n"+"Resep Lontong Sayur\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    1 buah lontong (bisa beli jadi atau membuat sendiri)\n" +
                "    1 lembar daun salam\n" +
                "    2 batang serai, memarkan\n" +
                "    2 cm lengkuas, memarkan\n" +
                "    1 sdt garam\n" +
                "    1 sdt gula pasir\n" +
                "    500 ml santan kelapa (dari 1 kelapa)\n" +
                "    1 liter air\n" +
                "    1 sdm minyak untuk menumis\n" +
                "\n" +
                "Bumbu Halus:\n" +
                "\n" +
                "    5 siung bawang merah\n" +
                "    3 siung bawang putih\n" +
                "    2 cm kunyit\n" +
                "    2 cm jahe\n" +
                "    3 butir kemiri, sangrai\n" +
                "    1 sdt ketumbar\n" +
                "    1/2 sdt jintan (opsional)\n" +
                "\n" +
                "Bahan Pelengkap:\n" +
                "\n" +
                "    2 butir telur rebus, belah dua\n" +
                "    Kerupuk (untuk pelengkap)\n" +
                "    Sambal (optional)\n" +
                "    Seledri dan daun bawang, iris halus (untuk taburan)\n" +
                "\n" +
                "Cara Membuat Lontong Sayur:\n" +
                "\n" +
                "    Membuat Kuah Sayur:\n" +
                "        Panaskan minyak dalam wajan, tumis bumbu halus (bawang merah, bawang putih, kunyit, jahe, kemiri, ketumbar, dan jintan) hingga harum dan matang.\n" +
                "        Tambahkan daun salam, serai, dan lengkuas. Tumis hingga semua bahan tercampur merata dan wangi.\n" +
                "        Masukkan air dan biarkan mendidih selama beberapa menit, agar bumbu meresap.\n" +
                "        Setelah itu, masukkan santan kelapa sedikit-sedikit sambil diaduk agar santan tidak pecah.\n" +
                "        Tambahkan garam dan gula, koreksi rasa, masak dengan api kecil hingga kuah sedikit mengental dan rasa santan meresap.\n" +
                "\n" +
                "    Menyajikan Lontong Sayur:\n" +
                "        Potong-potong lontong sesuai selera dan letakkan dalam mangkuk.\n" +
                "        Siram dengan kuah sayur yang telah siap. Pastikan sayur dan kuahnya tercampur rata di atas lontong.\n" +
                "        Tambahkan telur rebus, seledri, daun bawang, dan kerupuk sebagai pelengkap.\n" +
                "\n" +
                "    Variasi:\n" +
                "        Jika suka pedas, tambahkan sambal di samping untuk menambah cita rasa.\n" +
                "        Lontong sayur juga bisa ditambah dengan tempe atau tahu goreng sebagai protein tambahan.\n" +
                "\n" +
                "Nikmati lontong sayur yang gurih, segar, dan mengenyangkan ini!";

        Chapter chapter4 = new Chapter();
        chapter4.id = 4;
        chapter4.chapterName = "Soto Ayam";
        chapter4.imageUrl = "https://d1vbn70lmn1nqe.cloudfront.net/prod/wp-content/uploads/2023/08/03063114/Ini-Resep-Bumbu-Soto-Ayam-Tanpa-Santan-yang-Gurih-dan-Lezat-.jpg";
        chapter4.chapterDescription = "Soto ayam adalah hidangan sup khas Indonesia yang berisi potongan ayam suwir, bihun atau soun, irisan kol, dan kentang, disajikan dalam kuah bening atau bersantan yang kaya akan rempah seperti kunyit, serai, daun salam, dan lengkuas. Hidangan ini biasanya dilengkapi dengan telur rebus, perkedel, emping, bawang goreng, irisan daun bawang, jeruk nipis, dan sambal untuk memberikan rasa segar, gurih, dan sedikit pedas.\n" +
                "\n" +
                "Secara gizi, soto ayam mengandung karbohidrat dari bihun atau kentang, protein dari ayam dan telur, serta vitamin dan mineral dari sayuran seperti kol dan daun bawang. Kuah rempahnya yang hangat dan aromatik memberikan rasa yang khas sekaligus membantu pencernaan. Namun, jika menggunakan santan, kandungan lemaknya bisa meningkat.\n" +
                "\n" +
                "Soto ayam adalah hidangan yang ringan tetapi mengenyangkan, sering disantap sebagai sarapan atau makan siang. Dengan rasanya yang kaya dan berlapis, soto ayam mencerminkan kehangatan dan keragaman cita rasa kuliner Indonesia.\n"+"\n"+"Resep Soto Ayam\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    1 ekor ayam (biasanya ayam kampung, potong menjadi beberapa bagian)\n" +
                "    2 liter air\n" +
                "    2 batang serai, memarkan\n" +
                "    3 lembar daun salam\n" +
                "    4 cm lengkuas, memarkan\n" +
                "    2 sdt garam\n" +
                "    1 sdt merica bubuk\n" +
                "    1 sdt gula pasir\n" +
                "    1 sdm minyak untuk menumis\n" +
                "    2 butir telur rebus, belah dua\n" +
                "    Daun bawang dan seledri, iris halus (untuk taburan)\n" +
                "    Kerupuk (opsional, untuk pelengkap)\n" +
                "    Nasi atau lontong (untuk penyajian)\n" +
                "\n" +
                "Bumbu Halus:\n" +
                "\n" +
                "    8 siung bawang merah\n" +
                "    5 siung bawang putih\n" +
                "    3 cm kunyit\n" +
                "    2 cm jahe\n" +
                "    3 butir kemiri, sangrai\n" +
                "    1 sdt ketumbar\n" +
                "    1/2 sdt jintan (opsional)\n" +
                "\n" +
                "Cara Membuat Soto Ayam:\n" +
                "\n" +
                "    Merebus Ayam:\n" +
                "        Rebus ayam dengan 2 liter air hingga ayam empuk dan kaldu keluar, sekitar 30-40 menit. Angkat ayam dan saring kaldu.\n" +
                "        Suwir-suwir daging ayam setelah dingin dan sisihkan.\n" +
                "\n" +
                "    Menyiapkan Kuah Soto:\n" +
                "        Panaskan minyak dalam wajan, tumis bumbu halus (bawang merah, bawang putih, kunyit, jahe, kemiri, ketumbar, dan jintan) hingga harum.\n" +
                "        Masukkan bumbu yang sudah ditumis ke dalam kaldu ayam, tambahkan daun salam, serai, lengkuas, garam, merica, dan gula pasir. Masak dengan api kecil selama 10-15 menit agar bumbu meresap.\n" +
                "\n" +
                "    Penyelesaian Soto:\n" +
                "        Koreksi rasa, tambahkan garam atau gula jika diperlukan. Jika kuah terlalu keruh, bisa disaring kembali.\n" +
                "        Masukkan daging ayam yang sudah disuwir ke dalam kuah soto. Aduk rata.\n" +
                "\n" +
                "    Penyajian:\n" +
                "        Siapkan mangkuk, masukkan nasi atau lontong. Siram dengan kuah soto dan ayam suwir.\n" +
                "        Tambahkan telur rebus, daun bawang, seledri, dan kerupuk sebagai pelengkap.\n" +
                "\n" +
                "Pelengkap dan Variasi:\n" +
                "\n" +
                "    Sambal: Soto ayam biasanya disajikan dengan sambal untuk menambah rasa pedas.\n" +
                "    Kecap manis: Bisa ditambahkan untuk memberikan rasa manis yang gurih.\n" +
                "    Perasan jeruk nipis: Memberikan sensasi segar pada soto ayam.\n" +
                "\n" +
                "Nikmati soto ayam yang segar, gurih, dan kaya akan rasa rempah!";

        Chapter chapter5 = new Chapter();
        chapter5.id = 5;
        chapter5.chapterName = "Gudeg Jogja";
        chapter5.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/3/31/Nasi_Gudeg.jpg";
        chapter5.chapterDescription = "Gudeg Jogja adalah hidangan tradisional khas Yogyakarta yang terkenal dengan cita rasanya yang manis dan kaya rempah. Terbuat dari nangka muda yang dimasak dengan santan dan bumbu seperti gula jawa, bawang merah, bawang putih, lengkuas, dan daun salam, gudeg memiliki tekstur yang lembut dan warna cokelat khas. Proses memasaknya yang lama memberikan rasa yang mendalam pada setiap suapan.\n" +
                "\n" +
                "Gudeg biasanya disajikan dengan nasi putih hangat dan berbagai pelengkap seperti ayam kampung opor, telur pindang, tahu atau tempe bacem, sambal krecek (kulit sapi dengan cabai), dan kerupuk. Hidangan ini menciptakan keseimbangan antara rasa manis, gurih, dan sedikit pedas dari sambal.\n" +
                "\n" +
                "Secara gizi, gudeg mengandung karbohidrat dari nasi, protein dari ayam dan telur, serta lemak dari santan. Kandungan seratnya berasal dari nangka muda, menjadikannya hidangan yang tidak hanya lezat tetapi juga bernilai gizi.\n" +
                "\n" +
                "Resep Gudeg Jogja\n" +
                "Bahan Utama\n" +
                "\n" +
                "    1 kg nangka muda, potong kecil-kecil\n" +
                "    1 liter santan kental\n" +
                "    2 liter santan encer\n" +
                "    3 lembar daun salam\n" +
                "    3 cm lengkuas, memarkan\n" +
                "    5 butir telur rebus (opsional)\n" +
                "    100 gram gula merah, iris halus\n" +
                "    1 sdt garam\n" +
                "\n" +
                "Bumbu Halus\n" +
                "\n" +
                "    8 siung bawang merah\n" +
                "    5 siung bawang putih\n" +
                "    3 butir kemiri, sangrai\n" +
                "    2 cm kencur\n" +
                "    1 sdt ketumbar bubuk\n" +
                "\n" +
                "Cara Membuat Gudeg\n" +
                "\n" +
                "    Persiapan Nangka:\n" +
                "        Rebus nangka muda dengan air hingga setengah matang, tiriskan.\n" +
                "        Pastikan nangka lunak agar bumbu meresap dengan baik.\n" +
                "\n" +
                "    Memasak Gudeg:\n" +
                "        Susun daun salam dan lengkuas di dasar panci.\n" +
                "        Masukkan nangka muda, telur rebus (jika menggunakan), gula merah, dan bumbu halus ke dalam panci.\n" +
                "        Tuangkan santan encer hingga semua bahan terendam.\n" +
                "\n" +
                "    Proses Pemasakan:\n" +
                "        Masak dengan api kecil, tutup panci, dan biarkan mendidih perlahan.\n" +
                "        Aduk sesekali agar santan tidak pecah.\n" +
                "        Setelah air mulai surut, tambahkan santan kental dan garam.\n" +
                "\n" +
                "    Memasak Hingga Matang:\n" +
                "        Masak hingga santan meresap sepenuhnya dan gudeg berwarna cokelat tua.\n" +
                "        Proses ini biasanya memakan waktu 4-6 jam untuk mendapatkan rasa autentik gudeg Jogja.\n" +
                "\n" +
                "Pelengkap Gudeg\n" +
                "\n" +
                "    Sambal Goreng Krecek:\n" +
                "        100 gram krecek (kerupuk kulit), rendam air hangat.\n" +
                "        Tumis bumbu halus (cabai merah, bawang merah, bawang putih), tambahkan santan, daun salam, dan gula merah.\n" +
                "        Masukkan krecek, masak hingga santan meresap.\n" +
                "\n" +
                "    Ayam Opor:\n" +
                "        Ayam dipotong, dimasak dengan santan, daun salam, serai, dan bumbu opor.\n" +
                "\n" +
                "    Nasi Putih Hangat dan Kerupuk Udang:\n" +
                "\n" +
                "Penyajian Gudeg Jogja\n" +
                "\n" +
                "    Sajikan gudeg di piring dengan nasi putih.\n" +
                "    Tambahkan sambal goreng krecek, ayam opor, telur rebus, dan kerupuk.\n" +
                "    Tambahkan sambal bajak jika suka pedas.\n" +
                "\n" +
                "Nikmati gudeg Jogja yang manis, gurih, dan lezat!";

        physics.chapters.add(chapter1);
        physics.chapters.add(chapter2);
        physics.chapters.add(chapter3);
        physics.chapters.add(chapter4);
        physics.chapters.add(chapter5);

        Subject chem = new Subject();
        chem.id = 2;
        chem.subjectName = "Makan Siang";
        chem.chapters = new ArrayList<Chapter>();

        Chapter chapter6 = new Chapter();
        chapter6.id = 6;
        chapter6.chapterName = "Nasi Padang";
        chapter6.imageUrl = "https://img.harianjogja.com/posts/2022/02/17/1095486/nai-rumah-makan-padang.jpg";
        chapter6.chapterDescription = "Nasi Padang adalah hidangan khas Sumatera Barat yang terkenal dengan cita rasa rempah-rempahnya yang kaya dan beragam. Nasi putih pulen menjadi komponen utama, disajikan dengan aneka lauk-pauk seperti rendang, ayam pop, gulai ayam, dendeng balado, ikan bakar, atau ayam bakar. Hidangan ini juga dilengkapi dengan sayur seperti daun singkong rebus, gulai nangka, dan sambal ijo yang pedas, memberikan perpaduan rasa gurih, pedas, dan segar.\n" +
                "\n" +
                "Secara gizi, Nasi Padang kaya akan energi dari nasi, protein dari lauk-pauk seperti daging sapi, ayam, atau ikan, serta lemak dari kuah santan dan minyak yang digunakan dalam pengolahannya. Sayur-sayuran memberikan tambahan serat, vitamin, dan mineral. Namun, penggunaan santan kental dan bumbu berminyak dapat meningkatkan kandungan lemak jenuh, sehingga perlu dikonsumsi dengan bijak.\n" +
                "\n" +
                "Berikut resep sederhana untuk membuat nasi Padang lengkap:\n" +
                "Resep Nasi Padang Lengkap\n" +
                "Bahan Utama\n" +
                "\n" +
                "    500 gram daging sapi (untuk rendang)\n" +
                "    300 gram ikan tongkol (untuk gulai ikan)\n" +
                "    200 gram daun singkong, rebus\n" +
                "    500 gram nasi putih hangat\n" +
                "\n" +
                "Resep Rendang Daging\n" +
                "Bahan Rendang\n" +
                "\n" +
                "    500 gram daging sapi, potong sesuai selera\n" +
                "    1 liter santan dari 2 butir kelapa\n" +
                "    3 lembar daun salam\n" +
                "    2 batang serai, memarkan\n" +
                "    3 lembar daun jeruk\n" +
                "    1 ruas lengkuas, memarkan\n" +
                "\n" +
                "Bumbu Halus Rendang\n" +
                "\n" +
                "    8 siung bawang merah\n" +
                "    5 siung bawang putih\n" +
                "    4 buah cabai merah besar\n" +
                "    5 buah cabai merah keriting\n" +
                "    3 butir kemiri, sangrai\n" +
                "    2 cm kunyit, bakar\n" +
                "    2 cm jahe\n" +
                "    1 sdm ketumbar\n" +
                "    Garam dan gula secukupnya\n" +
                "\n" +
                "Cara Membuat Rendang\n" +
                "\n" +
                "    Tumis bumbu halus dengan daun salam, daun jeruk, serai, dan lengkuas hingga harum.\n" +
                "    Masukkan daging sapi, aduk hingga berubah warna.\n" +
                "    Tambahkan santan, masak dengan api kecil sambil terus diaduk.\n" +
                "    Masak hingga santan mengental dan bumbu meresap, aduk sesekali agar tidak gosong.\n" +
                "    Masak hingga daging empuk dan berwarna cokelat kehitaman.\n" +
                "\n" +
                "Resep Gulai Ikan Tongkol\n" +
                "Bahan Gulai\n" +
                "\n" +
                "    300 gram ikan tongkol, potong-potong\n" +
                "    500 ml santan sedang\n" +
                "    2 lembar daun salam\n" +
                "    2 batang serai, memarkan\n" +
                "    2 lembar daun jeruk\n" +
                "    1 cm asam kandis\n" +
                "\n" +
                "Bumbu Halus Gulai\n" +
                "\n" +
                "    4 siung bawang merah\n" +
                "    3 siung bawang putih\n" +
                "    3 buah cabai merah besar\n" +
                "    2 buah cabai rawit (opsional)\n" +
                "    1 cm kunyit\n" +
                "    Garam dan gula secukupnya\n" +
                "\n" +
                "Cara Membuat Gulai\n" +
                "\n" +
                "    Tumis bumbu halus dengan daun salam, daun jeruk, serai, dan asam kandis hingga harum.\n" +
                "    Masukkan santan, aduk hingga mendidih.\n" +
                "    Masukkan potongan ikan tongkol, masak dengan api kecil hingga ikan matang dan bumbu meresap.\n" +
                "\n" +
                "Pelengkap\n" +
                "Sambal Ijo\n" +
                "\n" +
                "    10 buah cabai hijau besar\n" +
                "    5 buah cabai rawit hijau\n" +
                "    6 siung bawang merah\n" +
                "    2 siung bawang putih\n" +
                "    1 buah tomat hijau\n" +
                "    Garam dan gula secukupnya\n" +
                "    Minyak untuk menumis\n" +
                "\n" +
                "Cara Membuat Sambal Ijo:\n" +
                "\n" +
                "    Kukus semua bahan kecuali garam dan gula hingga layu, kemudian haluskan kasar.\n" +
                "    Tumis sambal dengan minyak hingga harum. Tambahkan garam dan gula, aduk rata.\n" +
                "\n" +
                "Sayur Daun Singkong\n" +
                "\n" +
                "    Rebus daun singkong hingga empuk, tiriskan.\n" +
                "    Sajikan sebagai pendamping.\n" +
                "\n" +
                "Penyajian Nasi Padang\n" +
                "\n" +
                "    Siapkan nasi putih hangat di piring.\n" +
                "    Tambahkan rendang, gulai ikan tongkol, dan sayur daun singkong di sampingnya.\n" +
                "    Siram sedikit kuah rendang atau gulai ke atas nasi.\n" +
                "    Tambahkan sambal ijo di atas nasi atau lauk.\n" +
                "\n" +
                "Selamat menikmati nasi Padang yang autentik dan lezat!";

        Chapter chapter7 = new Chapter();
        chapter7.id = 7;
        chapter7.chapterName = "Rawon";
        chapter7.imageUrl = "https://sanex.co.id/wp-content/uploads/2024/06/resep-rawon-daging-surabaya_43.jpg";
        chapter7.chapterDescription = "Rawon adalah hidangan sup khas Jawa Timur yang memiliki kuah hitam pekat dengan rasa gurih dan aroma khas. Warna hitamnya berasal dari penggunaan kluwek, bahan unik yang memberikan rasa sedikit manis dan earthy. Rawon biasanya berisi potongan daging sapi yang empuk, disajikan dengan nasi putih hangat, tauge pendek, irisan daun bawang, sambal, kerupuk, dan telur asin sebagai pelengkap.\n" +
                "\n" +
                "Secara gizi, rawon mengandung protein tinggi dari daging sapi, karbohidrat dari nasi, serta vitamin dan mineral dari tauge dan pelengkap lainnya. Kandungan lemak berasal dari daging sapi dan minyak yang digunakan untuk menumis bumbu. Meskipun kaya rasa, rawon termasuk makanan yang ringan karena kuahnya tidak bersantan.\n" +
                "\n" +
                "Dengan perpaduan rasa gurih, manis, dan sedikit pedas, rawon adalah hidangan yang kaya akan tradisi dan budaya, menjadikannya salah satu kuliner ikonik Indonesia yang banyak digemari.\n"+"\n"+"Rawon adalah masakan khas Jawa Timur yang terkenal dengan kuah hitamnya yang kaya rempah. Warna hitam kuah berasal dari kluwek yang menjadi bahan utama. Berikut resep lengkapnya:\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    500 gram daging sapi (pilih bagian sandung lamur atau brisket), potong dadu\n" +
                "    2 liter air\n" +
                "    2 batang serai, memarkan\n" +
                "    3 lembar daun jeruk\n" +
                "    2 lembar daun salam\n" +
                "    3 cm lengkuas, memarkan\n" +
                "    3 sdm minyak untuk menumis\n" +
                "\n" +
                "Bumbu Halus:\n" +
                "\n" +
                "    5 buah kluwek, ambil dagingnya\n" +
                "    6 siung bawang merah\n" +
                "    4 siung bawang putih\n" +
                "    5 butir kemiri, sangrai\n" +
                "    2 cm kunyit, bakar\n" +
                "    2 cm jahe\n" +
                "    1 sdt ketumbar\n" +
                "    1/2 sdt merica\n" +
                "    1/2 sdt jinten\n" +
                "    2 buah cabai merah besar (opsional)\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Tauge pendek, siram air panas\n" +
                "    Sambal terasi\n" +
                "    Telur asin\n" +
                "    Kerupuk udang\n" +
                "    Nasi putih\n" +
                "\n" +
                "Cara Membuat:\n" +
                "1. Rebus Daging:\n" +
                "\n" +
                "    Rebus daging sapi hingga empuk, angkat, lalu potong-potong dadu.\n" +
                "    Saring air rebusan daging untuk digunakan sebagai kaldu.\n" +
                "\n" +
                "2. Tumis Bumbu:\n" +
                "\n" +
                "    Panaskan minyak, tumis bumbu halus hingga harum.\n" +
                "    Masukkan serai, daun jeruk, daun salam, dan lengkuas. Aduk hingga bumbu matang.\n" +
                "\n" +
                "3. Masak Rawon:\n" +
                "\n" +
                "    Masukkan bumbu yang sudah ditumis ke dalam kaldu daging.\n" +
                "    Tambahkan potongan daging sapi.\n" +
                "    Masak dengan api kecil hingga bumbu meresap, sekitar 30 menit.\n" +
                "    Koreksi rasa dengan garam dan gula sesuai selera.\n" +
                "\n" +
                "4. Penyajian:\n" +
                "\n" +
                "    Sajikan rawon dengan nasi putih hangat.\n" +
                "    Tambahkan tauge, telur asin, sambal terasi, dan kerupuk sebagai pelengkap.\n" +
                "\n" +
                "Tips:\n" +
                "\n" +
                "    Pilih kluwek yang baik (berwarna hitam pekat dan tidak berbau tengik).\n" +
                "    Jika kurang yakin dengan kluwek, coba cicipi sedikit untuk memastikan rasanya tidak pahit.\n" +
                "\n" +
                "Selamat mencoba memasak rawon yang autentik dan lezat!";

        Chapter chapter8 = new Chapter();
        chapter8.id = 8;
        chapter8.chapterName = "Gado-Gado";
        chapter8.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/a/a2/Gado_gado.jpg";
        chapter8.chapterDescription = "Gado-gado adalah salah satu hidangan khas Indonesia berupa salad sayur yang disajikan dengan saus kacang yang gurih dan kaya rasa. Hidangan ini terdiri dari campuran berbagai sayuran rebus seperti kacang panjang, tauge, kubis, dan bayam, serta bahan tambahan seperti tahu, tempe, irisan kentang, telur rebus, dan lontong. Kerupuk dan bawang goreng sering ditambahkan sebagai pelengkap untuk memberikan tekstur renyah.\n" +
                "\n" +
                "Secara gizi, gado-gado adalah makanan yang seimbang. Sayuran rebus memberikan vitamin, mineral, dan serat yang tinggi, sedangkan tahu, tempe, dan telur menyediakan protein. Saus kacang yang menjadi ciri khas hidangan ini mengandung lemak nabati, yang bermanfaat jika dikonsumsi dalam jumlah wajar. Karbohidrat diperoleh dari lontong atau kentang, menjadikan gado-gado sebagai hidangan yang mengenyangkan.\n" +
                "\n" +
                "Gado-gado sering disebut sebagai \"saladnya orang Indonesia\" karena perpaduan sayur-sayuran segarnya. Dengan rasa saus kacang yang manis, gurih, dan sedikit pedas, hidangan ini menjadi favorit bagi banyak orang, baik sebagai makanan utama maupun camilan sehat.\n"+"\n"+"Gado-gado adalah salah satu makanan khas Indonesia yang terdiri dari campuran sayuran rebus, tahu, tempe, dan bumbu kacang yang lezat. Berikut adalah resep untuk membuat gado-gado:\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    100 gram bayam, siangi\n" +
                "    100 gram kacang panjang, potong-potong\n" +
                "    100 gram kol, iris kasar\n" +
                "    100 gram tauge, bersihkan\n" +
                "    2 buah kentang, rebus, kupas, potong-potong\n" +
                "    2 buah tahu, goreng\n" +
                "    2 potong tempe, goreng\n" +
                "    2 butir telur ayam, rebus, kupas, belah dua\n" +
                "    1 buah mentimun, iris tipis\n" +
                "    100 gram lontong, potong-potong\n" +
                "\n" +
                "Bumbu Kacang:\n" +
                "\n" +
                "    150 gram kacang tanah, goreng atau sangrai, lalu haluskan\n" +
                "    3 siung bawang putih, goreng\n" +
                "    3 buah cabai merah besar, goreng (sesuaikan dengan tingkat kepedasan)\n" +
                "    2 sdt gula merah, serut\n" +
                "    1 sdt garam\n" +
                "    2 sdm air asam jawa (campuran 1 sdm asam jawa dan 3 sdm air hangat)\n" +
                "    200 ml santan atau air matang\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Kerupuk udang atau emping\n" +
                "    Bawang goreng\n" +
                "\n" +
                "Cara Membuat:\n" +
                "1. Rebus dan Siapkan Sayuran:\n" +
                "\n" +
                "    Didihkan air dalam panci.\n" +
                "    Rebus bayam, kacang panjang, kol, dan tauge secara terpisah hingga matang. Tiriskan.\n" +
                "\n" +
                "2. Buat Bumbu Kacang:\n" +
                "\n" +
                "    Haluskan bawang putih, cabai merah, dan kacang tanah.\n" +
                "    Campurkan gula merah, garam, dan air asam jawa.\n" +
                "    Tambahkan santan atau air matang sedikit demi sedikit sambil diaduk hingga mencapai kekentalan yang diinginkan.\n" +
                "    Masak bumbu di atas api kecil hingga mendidih, lalu angkat.\n" +
                "\n" +
                "3. Penyajian:\n" +
                "\n" +
                "    Tata lontong, sayuran rebus, tahu, tempe, kentang, telur rebus, dan mentimun di piring saji.\n" +
                "    Siram dengan bumbu kacang yang sudah matang.\n" +
                "    Taburi dengan bawang goreng dan kerupuk.\n" +
                "\n" +
                "Tips:\n" +
                "\n" +
                "    Agar lebih nikmat, gunakan cobek (ulekan) untuk membuat bumbu kacang secara manual.\n" +
                "    Bumbu kacang bisa disimpan di kulkas untuk digunakan nanti.\n" +
                "\n" +
                "Selamat menikmati gado-gado, hidangan sehat khas Indonesia!";

        Chapter chapter9 = new Chapter();
        chapter9.id = 9;
        chapter9.chapterName = "Lotek";
        chapter9.imageUrl = "https://asset.kompas.com/crops/G7N1w1V8GnH8t_axBjsMcIOSVVE=/0x0:1000x667/1200x800/data/photo/2021/09/09/613992c80e500.jpg";
        chapter9.chapterDescription = "Lotek adalah hidangan tradisional Indonesia yang mirip dengan gado-gado, tetapi memiliki cita rasa khas karena bumbu kacangnya yang lebih segar dan beraroma, biasanya diulek langsung bersama kencur. Hidangan ini terdiri dari campuran berbagai sayuran rebus seperti kangkung, bayam, kacang panjang, tauge, dan kol, yang kemudian dilumuri dengan saus kacang yang manis, gurih, dan sedikit pedas. Lotek sering disajikan dengan lontong atau nasi, serta pelengkap seperti kerupuk dan bawang goreng.\n" +
                "\n" +
                "Secara gizi, lotek adalah makanan yang kaya akan serat, vitamin, dan mineral dari sayurannya. Protein berasal dari tahu, tempe, atau tambahan kacang dalam sausnya, sementara karbohidrat bisa didapat dari lontong atau nasi. Saus kacang memberikan asupan lemak nabati, yang sehat bila dikonsumsi dalam jumlah wajar.\n" +
                "\n" +
                "Lotek memiliki cita rasa khas yang memadukan manis, pedas, dan aroma rempah dari kencur. Hidangan ini sering dianggap sebagai makanan ringan yang sehat dan menyegarkan, mencerminkan kekayaan kuliner tradisional Indonesia.\n"+"\n"+"Lotek adalah hidangan khas Indonesia yang mirip dengan gado-gado, namun memiliki ciri khas bumbu kacang dengan aroma kencur yang kuat. Berikut resep mudah untuk membuat lotek:\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    100 gram bayam, siangi\n" +
                "    100 gram kacang panjang, potong-potong\n" +
                "    100 gram kol, iris kasar\n" +
                "    100 gram tauge, bersihkan\n" +
                "    1 buah mentimun, potong dadu\n" +
                "    1 buah tempe goreng, potong-potong\n" +
                "\n" +
                "Bumbu Kacang:\n" +
                "\n" +
                "    150 gram kacang tanah, goreng atau sangrai, lalu haluskan\n" +
                "    3 siung bawang putih, goreng\n" +
                "    3 buah cabai merah keriting (sesuaikan selera pedasnya)\n" +
                "    1 cm kencur\n" +
                "    1 sdt terasi bakar\n" +
                "    50 gram gula merah, serut\n" +
                "    1 sdt garam\n" +
                "    2 sdm air asam jawa (campuran 1 sdm asam jawa dan 3 sdm air hangat)\n" +
                "    150 ml air matang\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Kerupuk\n" +
                "    Lontong atau nasi putih\n" +
                "\n" +
                "Cara Membuat:\n" +
                "1. Rebus Sayuran:\n" +
                "\n" +
                "    Didihkan air dalam panci.\n" +
                "    Rebus bayam, kacang panjang, kol, dan tauge secara terpisah hingga matang. Tiriskan.\n" +
                "\n" +
                "2. Siapkan Bumbu Kacang:\n" +
                "\n" +
                "    Haluskan bawang putih, cabai merah, kencur, dan terasi bakar.\n" +
                "    Campurkan dengan kacang tanah halus, gula merah, dan garam.\n" +
                "    Tambahkan air asam jawa dan air matang sedikit demi sedikit hingga mencapai kekentalan yang diinginkan. Aduk rata.\n" +
                "\n" +
                "3. Campurkan Sayuran dan Bumbu:\n" +
                "\n" +
                "    Dalam wadah besar, campurkan sayuran rebus, potongan tempe goreng, dan mentimun.\n" +
                "    Siram dengan bumbu kacang, aduk rata hingga semua bahan terbalut bumbu.\n" +
                "\n" +
                "4. Penyajian:\n" +
                "\n" +
                "    Sajikan lotek di piring, tambahkan kerupuk di atasnya.\n" +
                "    Hidangkan dengan lontong atau nasi sesuai selera.\n" +
                "\n" +
                "Tips:\n" +
                "\n" +
                "    Untuk rasa yang lebih otentik, gunakan cobek (ulekan) saat membuat bumbu kacang.\n" +
                "    Tambahkan perasan jeruk limau sebelum disajikan untuk aroma segar.\n" +
                "\n" +
                "Selamat menikmati lotek segar dan sehat!";

        chem.chapters.add(chapter6);
        chem.chapters.add(chapter7);
        chem.chapters.add(chapter8);
        chem.chapters.add(chapter9);

        Subject bio = new Subject();
        bio.id = 3;
        bio.subjectName = "Makan Malam";
        bio.chapters = new ArrayList<Chapter>();

        Chapter chapter10 = new Chapter();
        chapter10.id = 10;
        chapter10.chapterName = "Nasi Goreng";
        chapter10.imageUrl = "https://d1vbn70lmn1nqe.cloudfront.net/prod/wp-content/uploads/2023/07/12003447/X-Resep-Nasi-Goreng-Sederhana-hingga-Spesial-Mudah-dan-Praktis-.jpg";
        chapter10.chapterDescription = "Nasi goreng adalah salah satu hidangan khas Indonesia yang terkenal di seluruh dunia. Terbuat dari nasi putih yang digoreng bersama bumbu-bumbu seperti bawang putih, bawang merah, kecap manis, dan cabai, nasi goreng memiliki rasa gurih yang khas dan aroma yang menggugah selera. Hidangan ini sering dilengkapi dengan tambahan seperti potongan ayam, udang, telur orak-arik, atau sosis, serta sayuran seperti wortel dan kacang polong.\n" +
                "\n" +
                "Sebagai pelengkap, nasi goreng biasanya disajikan dengan telur mata sapi, acar, kerupuk, dan taburan bawang goreng. Secara gizi, nasi goreng mengandung karbohidrat sebagai sumber energi utama dari nasi, protein dari lauk-pauk, serta sedikit serat dan vitamin dari sayuran. Kandungan lemak dapat berasal dari minyak goreng dan kecap manis yang digunakan.\n" +
                "\n" +
                "Nasi goreng adalah hidangan yang fleksibel karena dapat disesuaikan dengan berbagai bahan sesuai selera, menjadikannya makanan yang mudah dibuat namun tetap lezat. Kombinasi rasa manis, gurih, dan sedikit pedas membuat nasi goreng menjadi salah satu ikon kuliner Indonesia yang digemari semua kalangan.\n"+"\n"+"Berikut adalah resep sederhana untuk membuat nasi goreng yang lezat dan mudah:\n" +
                "Bahan-bahan:\n" +
                "\n" +
                "    2 piring nasi putih (sebaiknya nasi dingin atau nasi sisa semalam)\n" +
                "    2 siung bawang putih, cincang halus\n" +
                "    3 butir bawang merah, cincang halus\n" +
                "    2 sdm kecap manis\n" +
                "    1 sdm saus tiram (opsional)\n" +
                "    1 sdm kecap asin\n" +
                "    1 butir telur\n" +
                "    50 gram ayam suwir (opsional)\n" +
                "    2 batang daun bawang, iris tipis\n" +
                "    Garam dan merica secukupnya\n" +
                "    Minyak goreng secukupnya\n" +
                "    Pelengkap: kerupuk, irisan tomat, mentimun, dan bawang goreng\n" +
                "\n" +
                "Langkah-langkah:\n" +
                "\n" +
                "    Panaskan Minyak:\n" +
                "    Panaskan 2–3 sdm minyak goreng di wajan dengan api sedang.\n" +
                "\n" +
                "    Tumis Bumbu:\n" +
                "    Masukkan bawang putih dan bawang merah yang sudah dicincang, tumis hingga harum.\n" +
                "\n" +
                "    Masak Telur:\n" +
                "    Geser bumbu ke sisi wajan, pecahkan telur, lalu orak-arik hingga matang.\n" +
                "\n" +
                "    Tambahkan Ayam (Opsional):\n" +
                "    Masukkan ayam suwir atau protein lain seperti udang, sosis, atau bakso, dan tumis hingga merata.\n" +
                "\n" +
                "    Masukkan Nasi:\n" +
                "    Masukkan nasi putih dingin, lalu aduk hingga tercampur rata dengan bumbu dan bahan lainnya.\n" +
                "\n" +
                "    Tambahkan Kecap dan Bumbu:\n" +
                "    Tuang kecap manis, saus tiram, kecap asin, garam, dan merica. Aduk hingga warna dan rasa nasi merata.\n" +
                "\n" +
                "    Tambahkan Daun Bawang:\n" +
                "    Masukkan daun bawang yang sudah diiris, aduk sebentar hingga layu.\n" +
                "\n" +
                "    Sajikan:\n" +
                "    Pindahkan nasi goreng ke piring saji. Tambahkan pelengkap seperti kerupuk, irisan tomat, mentimun, dan taburan bawang goreng.\n" +
                "\n" +
                "Tips Tambahan:\n" +
                "\n" +
                "    Gunakan nasi yang agak kering agar tekstur nasi goreng tidak lembek.\n" +
                "    Variasikan isiannya dengan sayuran (wortel, kacang polong, atau jagung) atau seafood (udang dan cumi).\n" +
                "    Untuk rasa pedas, tambahkan cabai rawit yang diiris atau sambal saat menumis bumbu.\n" +
                "\n" +
                "Nasi goreng siap dinikmati sebagai hidangan praktis dan penuh rasa!";;

        Chapter chapter11 = new Chapter();
        chapter11.id = 11;
        chapter11.chapterName = "Mie Aceh";
        chapter11.imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Mie_Aceh_with_beef.jpg/250px-Mie_Aceh_with_beef.jpg";
        chapter11.chapterDescription = "Mie Aceh adalah hidangan khas dari Provinsi Aceh yang terkenal dengan cita rasa rempahnya yang kaya dan bumbu yang kuat. Hidangan ini menggunakan mie kuning tebal yang dimasak bersama bumbu halus berbahan dasar bawang putih, bawang merah, cabai, kunyit, jintan, dan kari, menciptakan rasa gurih, pedas, dan aromatik. \n" +
                "\n" +
                "Mie Aceh dapat disajikan dalam tiga varian: goreng (kering), tumis (setengah basah), atau kuah (berkuah). Pilihan protein seperti daging sapi, ayam, udang, atau cumi menjadi pelengkap utama yang memberikan rasa yang lebih kaya. Hidangan ini biasanya disajikan dengan acar bawang, emping, irisan mentimun, dan jeruk nipis untuk menambah kesegaran.\n" +
                "\n" +
                "Secara gizi, Mie Aceh mengandung karbohidrat dari mie, protein dari lauk-pauk, dan lemak dari minyak serta bumbu. Hidangan ini juga dilengkapi vitamin dan mineral dari sayuran pelengkapnya.\n" +
                "\n" +
                "Dengan rasa yang kuat dan rempah yang khas, Mie Aceh adalah salah satu kuliner Nusantara yang menggugah selera dan mencerminkan kekayaan tradisi masakan Aceh. Cocok dinikmati kapan saja, terutama bagi pecinta makanan pedas dan berbumbu.\n" +"\n"+"Mie Aceh adalah hidangan khas Aceh dengan cita rasa gurih, pedas, dan kaya rempah. Berikut resep sederhana untuk membuatnya di rumah:\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    300 gram mie kuning basah (bilas dengan air panas, tiriskan)\n" +
                "    150 gram daging sapi/ayam/cumi/udang (pilih sesuai selera, potong kecil-kecil)\n" +
                "    2 batang daun bawang, iris tipis\n" +
                "    100 gram tauge, bersihkan\n" +
                "    2 buah tomat, potong-potong\n" +
                "    2 sdm kecap manis\n" +
                "    1 sdt garam\n" +
                "    1 sdt merica bubuk\n" +
                "    750 ml air\n" +
                "\n" +
                "Bumbu Halus:\n" +
                "\n" +
                "    5 siung bawang putih\n" +
                "    6 butir bawang merah\n" +
                "    4 buah cabai merah keriting (sesuaikan tingkat pedas sesuai selera)\n" +
                "    2 cm kunyit, bakar sebentar\n" +
                "    1 cm jahe\n" +
                "    1/2 sdt jintan\n" +
                "\n" +
                "Bumbu Rempah Tambahan:\n" +
                "\n" +
                "    2 butir kapulaga\n" +
                "    1 batang serai, memarkan\n" +
                "    2 lembar daun salam\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Bawang goreng\n" +
                "    Acar mentimun\n" +
                "    Kerupuk atau emping\n" +
                "    Jeruk nipis\n" +
                "\n" +
                "Langkah-langkah:\n" +
                "\n" +
                "    Tumis Bumbu Halus:\n" +
                "    Panaskan 3 sdm minyak goreng dalam wajan. Tumis bumbu halus bersama kapulaga, serai, dan daun salam hingga harum.\n" +
                "\n" +
                "    Masak Daging:\n" +
                "    Masukkan potongan daging, tumis hingga berubah warna. Tambahkan air dan masak hingga daging empuk.\n" +
                "\n" +
                "    Tambahkan Bahan:\n" +
                "    Masukkan tomat, kecap manis, garam, dan merica. Aduk rata.\n" +
                "\n" +
                "    Masak Mie:\n" +
                "    Tambahkan mie kuning dan tauge ke dalam wajan. Aduk hingga bumbu merata dan mie matang. Koreksi rasa.\n" +
                "\n" +
                "    Sajikan:\n" +
                "    Angkat mie Aceh dan sajikan panas-panas. Tambahkan bawang goreng, emping, dan jeruk nipis sebagai pelengkap.\n" +
                "\n" +
                "Tips:\n" +
                "\n" +
                "    Gunakan udang atau cumi jika ingin rasa laut lebih terasa.\n" +
                "    Untuk rasa lebih pedas, tambahkan cabai rawit sesuai selera saat menghaluskan bumbu.\n" +
                "\n" +
                "Selamat mencoba!";

        Chapter chapter12 = new Chapter();
        chapter12.id = 12;
        chapter12.chapterName = "Sate Ayam";
        chapter12.imageUrl = "https://img-global.cpcdn.com/recipes/a6ca9f36b02b089b/400x400cq70/photo.jpg";
        chapter12.chapterDescription = "Sate ayam adalah salah satu hidangan ikonik Indonesia berupa potongan daging ayam yang ditusuk menggunakan tusukan bambu, lalu dibakar di atas arang hingga matang dengan aroma khas yang menggugah selera. Sate ayam biasanya disajikan dengan bumbu kacang yang gurih dan sedikit manis, serta pelengkap seperti lontong, irisan bawang merah, cabai, dan perasan jeruk limau untuk menambah kesegaran.\n" +
                "\n" +
                "Secara gizi, sate ayam mengandung protein tinggi dari daging ayam, lemak dari bumbu kacang dan proses pemanggangan, serta karbohidrat jika disantap dengan lontong. Bumbu kacang yang kaya rasa juga memberikan lemak nabati dan tambahan kalori. Dengan perpaduan rasa manis, gurih, dan sedikit pedas, sate ayam menjadi hidangan yang cocok disantap sebagai makanan utama atau camilan.\n" +
                "\n" +
                "Sate ayam adalah simbol kelezatan kuliner Indonesia yang sederhana namun kaya rasa. Hidangan ini sering ditemukan di berbagai acara atau sebagai makanan jalanan, menjadikannya favorit di segala kesempatan.\n"+"\n"+"Sate ayam adalah hidangan khas Indonesia yang sangat populer dengan cita rasa gurih manis dan aroma bakaran yang khas. Berikut resepnya:\n" +
                "Bahan Utama:\n" +
                "\n" +
                "    500 gram daging ayam fillet (bagian dada atau paha), potong dadu kecil\n" +
                "    10-15 tusuk sate (rendam dalam air agar tidak mudah terbakar)\n" +
                "\n" +
                "Bumbu Marinasi:\n" +
                "\n" +
                "    4 siung bawang putih, haluskan\n" +
                "    2 sdm kecap manis\n" +
                "    1 sdm air jeruk nipis\n" +
                "    1 sdt ketumbar bubuk\n" +
                "    1/2 sdt garam\n" +
                "    1/4 sdt merica bubuk\n" +
                "\n" +
                "Bumbu Kacang:\n" +
                "\n" +
                "    150 gram kacang tanah, goreng hingga matang, lalu haluskan\n" +
                "    3 siung bawang putih, goreng\n" +
                "    5 buah cabai merah keriting (sesuaikan tingkat pedasnya)\n" +
                "    2 lembar daun jeruk, sobek-sobek\n" +
                "    250 ml air\n" +
                "    2 sdm kecap manis\n" +
                "    1 sdt garam\n" +
                "    1 sdm gula merah\n" +
                "\n" +
                "Pelengkap:\n" +
                "\n" +
                "    Lontong atau nasi putih\n" +
                "    Bawang goreng\n" +
                "    Acar mentimun dan wortel\n" +
                "\n" +
                "Cara Membuat:\n" +
                "1. Marinasi Daging:\n" +
                "\n" +
                "    Campurkan daging ayam dengan bumbu marinasi.\n" +
                "    Aduk hingga rata, diamkan selama 30 menit agar bumbu meresap.\n" +
                "\n" +
                "2. Siapkan Bumbu Kacang:\n" +
                "\n" +
                "    Tumis bawang putih, cabai merah, dan daun jeruk hingga harum.\n" +
                "    Blender bersama kacang tanah goreng hingga halus.\n" +
                "    Masak campuran kacang dengan air, tambahkan kecap manis, garam, dan gula merah. Masak hingga mengental.\n" +
                "\n" +
                "3. Tusuk dan Panggang:\n" +
                "\n" +
                "    Tusukkan daging ayam ke dalam tusuk sate (isi 4-5 potong per tusuk).\n" +
                "    Panggang sate di atas bara api atau grill pan sambil sesekali diolesi bumbu kacang dan kecap. Bolak-balik hingga matang dan harum.\n" +
                "\n" +
                "4. Penyajian:\n" +
                "\n" +
                "    Sajikan sate ayam bersama bumbu kacang, lontong, bawang goreng, dan acar.\n" +
                "\n" +
                "Tips:\n" +
                "\n" +
                "    Jika tidak punya waktu untuk memanggang, sate juga bisa dimasak di teflon anti-lengket.\n" +
                "    Tambahkan perasan jeruk limau di atas sate untuk rasa segar.\n" +
                "\n" +
                "Selamat mencoba!";

        bio.chapters.add(chapter10);
        bio.chapters.add(chapter11);
        bio.chapters.add(chapter12);


        subjects.add(physics);
        subjects.add(chem);
        subjects.add(bio);

        return subjects;
    }
}
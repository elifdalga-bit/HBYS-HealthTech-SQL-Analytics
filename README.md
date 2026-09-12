# 🏥 Hastane Bilgi Yönetim Sistemi (HBYS) SQL Analiz Projesi

Bu proje, **Sağlık Yönetimi** ve **Yönetim Bilişim Sistemleri (YBS)** disiplinlerini birleştirerek simüle edilmiş bir hastane veri tabanı üzerinde operasyonel verimlilik, klinik kullanım ve finansal performans analizleri gerçekleştirmek amacıyla hazırlanmıştır.

## 🛠️ Kullanılan Teknolojiler
* **Veri Tabanı:** SQLite / PostgreSQL / MySQL
* **Yetenekler:** Relational Database Design (DDL/DML), Advanced JOINs, Aggregations, Conditional Aggregations (`CASE WHEN`), Window Functions (`DENSE_RANK`).

## 📊 Öne Çıkan Analizler ve Bulgular

1. **Poliklinik Gelir Analizi:** Kardiyoloji polikliniğinin en yüksek toplam ciroyu (51.700 TL) ürettiği tespit edilmiştir.
2. **Randevu Katılım & İptal Takibi:** `CASE WHEN` yapısı ile doktor bazlı randevu sadakati ve iptal oranları raporlanmıştır.
3. **Geriatri (65+ Yaş) Maliyet ve Yatış Analizi:** 65 yaş ve üstü hastaların ortalama yatış süresinin (4 gün), 65 yaş altı gruptan (1 gün) 4 kat daha fazla olduğu görülmüştür.
4. **Branş İçi Performans Sıralaması:** `DENSE_RANK() OVER (PARTITION BY ...)` kullanılarak her branşın kendi içerisindeki ciro lideri doktorlar sıralanmıştır.

## 📁 Proje Dosyaları
* `hbys_analysis.sql`: Tablo şemaları, örnek veriler ve 4 ana iş analizi sorgusu.

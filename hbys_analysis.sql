-- ============================================================
-- HASTANE BİLGİ YÖNETİM SİSTEMİ (HBYS) SQL ANALİZ PROJESİ
-- Yazar: Elif Dalga
-- Açıklama: Tablo Şemaları, Örnek Veri Seti ve İş Analizi Sorguları
-- ============================================================

-- ------------------------------------------------------------
-- 1. BÖLÜM: TABLO OLUŞTURMA (DDL)
-- ------------------------------------------------------------

CREATE TABLE Hastalar (
    Hasta_ID INT PRIMARY KEY,
    Ad VARCHAR(50),
    Soyad VARCHAR(50),
    Yas INT,
    Cinsiyet VARCHAR(10),
    Sigorta_Turu VARCHAR(20)
);

CREATE TABLE Doktorlar (
    Doktor_ID INT PRIMARY KEY,
    Ad VARCHAR(50),
    Soyad VARCHAR(50),
    Brans VARCHAR(50),
    Unvan VARCHAR(20)
);

CREATE TABLE Randevular (
    Randevu_ID INT PRIMARY KEY,
    Hasta_ID INT,
    Doktor_ID INT,
    Tarih DATE,
    Poliklinik VARCHAR(50),
    Durum VARCHAR(20),
    FOREIGN KEY (Hasta_ID) REFERENCES Hastalar(Hasta_ID),
    FOREIGN KEY (Doktor_ID) REFERENCES Doktorlar(Doktor_ID)
);

CREATE TABLE Tedaviler_Fatura (
    Fatura_ID INT PRIMARY KEY,
    Hasta_ID INT,
    Doktor_ID INT,
    Teshis_Kodu VARCHAR(10),
    Tutar DECIMAL(10, 2),
    Yatis_Suresi_Gun INT,
    FOREIGN KEY (Hasta_ID) REFERENCES Hastalar(Hasta_ID),
    FOREIGN KEY (Doktor_ID) REFERENCES Doktorlar(Doktor_ID)
);

-- ------------------------------------------------------------
-- 2. BÖLÜM: ÖRNEK VERİ YÜKLEME (DML)
-- ------------------------------------------------------------

INSERT INTO Hastalar VALUES 
(1, 'Ahmet', 'Yılmaz', 45, 'Erkek', 'SGK'),
(2, 'Ayşe', 'Kaya', 68, 'Kadın', 'Özel'),
(3, 'Mehmet', 'Demir', 32, 'Erkek', 'SGK'),
(4, 'Fatma', 'Çelik', 72, 'Kadın', 'SGK'),
(5, 'Ali', 'Öztürk', 28, 'Erkek', 'Yok'),
(6, 'Zeynep', 'Aydın', 55, 'Kadın', 'Özel'),
(7, 'Mustafa', 'Arslan', 66, 'Erkek', 'SGK'),
(8, 'Elif', 'Yıldız', 19, 'Kadın', 'SGK'),
(9, 'Hüseyin', 'Şahin', 70, 'Erkek', 'Özel'),
(10, 'Büşra', 'Yıldırım', 39, 'Kadın', 'SGK');

INSERT INTO Doktorlar VALUES
(101, 'Can', 'Aksoy', 'Dahiliye', 'Uzm. Dr.'),
(102, 'Selin', 'Erbil', 'Kardiyoloji', 'Prof. Dr.'),
(103, 'Burak', 'Karasu', 'Göz', 'Op. Dr.'),
(104, 'Deniz', 'Yılmaz', 'Dahiliye', 'Doç. Dr.'),
(105, 'Merve', 'Kılıç', 'Kardiyoloji', 'Uzm. Dr.');

INSERT INTO Randevular VALUES
(1001, 1, 101, '2026-09-01', 'Dahiliye', 'Geldi'),
(1002, 2, 102, '2026-09-01', 'Kardiyoloji', 'Geldi'),
(1003, 3, 103, '2026-09-02', 'Göz', 'Geldi'),
(1004, 4, 101, '2026-09-02', 'Dahiliye', 'Geldi'),
(1005, 5, 104, '2026-09-03', 'Dahiliye', 'İptal'),
(1006, 6, 102, '2026-09-03', 'Kardiyoloji', 'Geldi'),
(1007, 7, 105, '2026-09-04', 'Kardiyoloji', 'Geldi'),
(1008, 8, 103, '2026-09-04', 'Göz', 'Gelmedi'),
(1009, 9, 101, '2026-09-05', 'Dahiliye', 'Geldi'),
(1010, 10, 104, '2026-09-05', 'Dahiliye', 'Geldi'),
(1011, 2, 105, '2026-09-06', 'Kardiyoloji', 'Geldi'),
(1012, 4, 102, '2026-09-06', 'Kardiyoloji', 'İptal');

INSERT INTO Tedaviler_Fatura VALUES
(5001, 1, 101, 'E11', 1500.00, 0),
(5002, 2, 102, 'I10', 8500.00, 3),
(5003, 3, 103, 'H52', 800.00, 0),
(5004, 4, 101, 'E11', 12500.00, 5),
(5005, 6, 102, 'I20', 18000.00, 4),
(5006, 7, 105, 'I10', 3200.00, 1),
(5007, 9, 101, 'J18', 14000.00, 6),
(5008, 10, 104, 'E11', 1800.00, 0),
(5009, 2, 105, 'I20', 22000.00, 5);

-- ------------------------------------------------------------
-- 3. BÖLÜM: YÖNETİMSEL VE ANALİTİK SORGU RAPORLARI
-- ------------------------------------------------------------

-- Analiz 1: Poliklinik Bazında Toplam Gelir ve Randevu Hacmi
SELECT 
    r.Poliklinik,
    COUNT(r.Randevu_ID) AS Gerçekleşen_Randevu_Sayısı,
    SUM(tf.Tutar) AS Toplam_Gelir,
    ROUND(AVG(tf.Tutar), 2) AS Ortalama_Fatura_Tutarı
FROM Randevular r
JOIN Tedaviler_Fatura tf 
    ON r.Hasta_ID = tf.Hasta_ID 
   AND r.Doktor_ID = tf.Doktor_ID
WHERE r.Durum = 'Geldi'
GROUP BY r.Poliklinik
ORDER BY Toplam_Gelir DESC;

-- Analiz 2: Doktor Bazında Randevu Katılım ve İptal Analizi (CASE WHEN)
SELECT 
    d.Ad || ' ' || d.Soyad AS Doktor_Adı,
    d.Brans,
    COUNT(r.Randevu_ID) AS Toplam_Randevu,
    SUM(CASE WHEN r.Durum = 'Geldi' THEN 1 ELSE 0 END) AS Geldi,
    SUM(CASE WHEN r.Durum = 'İptal' THEN 1 ELSE 0 END) AS Iptal,
    SUM(CASE WHEN r.Durum = 'Gelmedi' THEN 1 ELSE 0 END) AS Gelmedi
FROM Doktorlar d
LEFT JOIN Randevular r ON d.Doktor_ID = r.Doktor_ID
GROUP BY d.Doktor_ID, d.Ad, d.Soyad, d.Brans
ORDER BY Toplam_Randevu DESC;

-- Analiz 3: Yaş Demografisine Göre Yatış Süresi ve Maliyet Analizi (ALOS)
SELECT 
    CASE 
        WHEN h.Yas >= 65 THEN '65+ Yaş (Geriatri/Yaşlı)'
        ELSE '65 Yaş Altı'
    END AS Yaş_Grubu,
    COUNT(tf.Fatura_ID) AS Toplam_Tedavi_Sayısı,
    ROUND(AVG(tf.Yatis_Suresi_Gun), 1) AS Ort_Yatış_Günü,
    SUM(tf.Tutar) AS Toplam_Ciro,
    ROUND(AVG(tf.Tutar), 2) AS Ort_Fatura_Tutarı
FROM Hastalar h
JOIN Tedaviler_Fatura tf ON h.Hasta_ID = tf.Hasta_ID
GROUP BY 
    CASE 
        WHEN h.Yas >= 65 THEN '65+ Yaş (Geriatri/Yaşlı)'
        ELSE '65 Yaş Altı'
    END;

-- Analiz 4: İleri Seviye Branş İçi Doktor Sıralaması (Window Functions)
SELECT 
    d.Brans,
    d.Ad || ' ' || d.Soyad AS Doktor_Adı,
    SUM(tf.Tutar) AS Toplam_Ciro,
    DENSE_RANK() OVER (
        PARTITION BY d.Brans 
        ORDER BY SUM(tf.Tutar) DESC
    ) AS Branş_İçi_Sıra
FROM Doktorlar d
JOIN Tedaviler_Fatura tf ON d.Doktor_ID = tf.Doktor_ID
GROUP BY d.Brans, d.Doktor_ID, d.Ad, d.Soyad
ORDER BY d.Brans, Branş_İçi_Sıra;

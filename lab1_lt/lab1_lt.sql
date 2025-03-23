CREATE TABLE khoa (
    khoa_id     SERIAL PRIMARY KEY,
    ten_khoa    VARCHAR(20) NOT NULL,
    nam         INTEGER,
    phong       INTEGER,
    dien_thoai  CHAR(11),
    truong_khoa INTEGER
);

CREATE TABLE bo_mon (
    bo_mon_id   SERIAL PRIMARY KEY,
    ten_bo_mon  VARCHAR(20) NOT NULL,
    phong       INTEGER,
    dien_thoai  CHAR(11),
    khoa_id     INTEGER REFERENCES khoa(khoa_id) ON DELETE CASCADE,
    truong_bo_mon INTEGER
);

CREATE TABLE giang_vien (
    giang_vien_id   SERIAL PRIMARY KEY,
    ho_va_ten       VARCHAR(40),
    gioi_tinh       CHAR(1) CHECK (gioi_tinh IN ('M', 'F')),
    ngay_sinh       DATE,
    tham_gia        CHAR(1) DEFAULT '1',
    bo_mon_id       INTEGER REFERENCES bo_mon(bo_mon_id) ON DELETE CASCADE,
    quan_ly         INTEGER REFERENCES giang_vien(giang_vien_id) ON DELETE SET NULL
);

ALTER TABLE khoa
ADD CONSTRAINT fk_truong_khoa
FOREIGN KEY (truong_khoa) REFERENCES giang_vien(giang_vien_id) ON DELETE CASCADE;

ALTER TABLE bo_mon
ADD CONSTRAINT fk_truong_bo_mon
FOREIGN KEY (truong_bo_mon) REFERENCES giang_vien(giang_vien_id) ON DELETE SET NULL;

CREATE TABLE chu_de_nckh (
    chu_de_id   SERIAL PRIMARY KEY,
    ten_chu_de  VARCHAR(100) NOT NULL
);

CREATE TABLE de_tai (
    de_tai_id   SERIAL PRIMARY KEY,
    ten_de_tai  VARCHAR(100),
    kinh_phi    INTEGER,
    cap_quan_li VARCHAR(20),
    ngay_bat_dau    DATE,
    ngay_ket_thuc   DATE,
    chu_de_id   INTEGER REFERENCES chu_de_nckh(chu_de_id) ON DELETE CASCADE,
    chu_nhiem   INTEGER REFERENCES giang_vien(giang_vien_id) ON DELETE SET NULL
);

CREATE TABLE cong_viec (
    cong_viec_id    SERIAL PRIMARY KEY,
    de_tai_id       INTEGER REFERENCES de_tai(de_tai_id) ON DELETE CASCADE,
    ten_cong_viec   VARCHAR(20),
    ngay_bat_dau    DATE,
    ngay_ket_thuc   DATE
);

CREATE TABLE danh_gia (
    cong_viec_id    INTEGER REFERENCES cong_viec(cong_viec_id) ON DELETE CASCADE,
    giang_vien_id   INTEGER REFERENCES giang_vien(giang_vien_id) ON DELETE CASCADE,
    phu_cap         INTEGER CHECK (phu_cap >= 0),
    ket_qua         BOOLEAN,
    PRIMARY KEY (cong_viec_id, giang_vien_id)
);
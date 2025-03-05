with J as (select thuebao_id, donvi_id from CSS.v_dbtb_dv@dataguard where loaidv_id = 5)
            , hk as (select xl.ketqua_xl, n.kqxl_id, m.thuebao_id, row_number() over (partition by thuebao_id order by n.kqxl_id) rnk
                                                            from CSS.v_giaophieu@dataguard n, CSS.v_hd_thuebao@dataguard m, CSS.v_ketqua_xl@dataguard xl
                                                            where n.hdtb_id= m.hdtb_id and m.loaitb_id = 61 and m.kieuld_id = 875 and n.kqxl_id = xl.kqxl_id (+)
                                                                            and (n.vthuhoi_tbi in (1) or n.tt_thuhoi in (0,1,2) or n.kqxl_id in (1,2,3)) --group by  m.thuebao_id
                                                    )
            , hk1 as (select zz.ma_gd, m.hdtb_id, kqxl_id, m.thuebao_id, row_number() over (partition by thuebao_id, kqxl_id order by n.hdtb_id) rnk
                                                            from CSS.v_giaophieu@dataguard n, CSS.v_hd_thuebao@dataguard m, CSS.v_hd_khachhang@dataguard zz
                                                            where n.hdtb_id= m.hdtb_id and m.loaitb_id = 61 and m.hdkh_id = zz.hdkh_id
                                                                            and (vthuhoi_tbi in (1) or tt_thuhoi in (0,1,2) or kqxl_id in (1,2,3)) --group by  kqxl_id, m.thuebao_id
                                                )
            , hk2 as (select xl.ketqua_xl,
            n.kqxl_id, m.thuebao_id, row_number() over (partition by thuebao_id order by n.kqxl_id desc) rnk
                                                            from CSS.v_giaophieu@dataguard n, CSS.v_hd_thuebao@dataguard m, CSS.v_ketqua_xl@dataguard xl
                                                            where n.hdtb_id= m.hdtb_id and m.loaitb_id = 61 and n.kqxl_id = xl.kqxl_id (+)
                                                                                and (n.vthuhoi_tbi in (1) or n.tt_thuhoi in (0,1,2) or n.kqxl_id in (1,2,3)) --group by  m.thuebao_id
                                                    )
            , hk3 as (select zz.ma_gd, m.hdtb_id, kqxl_id, m.thuebao_id, row_number() over (partition by thuebao_id, kqxl_id order by n.hdtb_id desc) rnk
                                                            from CSS.v_giaophieu@dataguard n, CSS.v_hd_thuebao@dataguard m, CSS.v_hd_khachhang@dataguard zz
                                                            where n.hdtb_id= m.hdtb_id and m.loaitb_id = 61 and m.hdkh_id = zz.hdkh_id
                                                                            and (vthuhoi_tbi in (1) or tt_thuhoi in (0,1,2) or kqxl_id in (1,2,3)) --group by  kqxl_id, m.thuebao_id
                                                )
            , hd as (select x.ma_gd, y.thuebao_id, z.trangbi_id,  z.thietbidc_id
                                                        from CSS.v_hd_khachhang@dataguard x, CSS.v_hd_thuebao@dataguard y, CSS.v_hdtb_adsl@dataguard z
                                                            where x.hdkh_id = y.hdkh_id and y.loaitb_id = 61 and y.hdtb_id = z.hdtb_id and x.loaihd_id = 1 and y.tthd_id = 6 and y.kieuld_id <> 280
                                                            )
      /*      , kj as (select ma_gd, hdtb_id from css_hcm.hd_thuebao yy, css_hcm.hd_khachhang zz
                                                where yy.hdkh_id = zz.hdkh_id and yy.loaitb_id = 61
                                            )
            , kj1 as (select ma_gd, hdtb_id from css_hcm.hd_thuebao yy, css_hcm.hd_khachhang zz
                                                where yy.hdkh_id = zz.hdkh_id and yy.loaitb_id = 61
                                            )
    */
select to_number(to_char(a.ngay_sd, 'yyyymm')) thang, a.ma_tb, a.ten_tb
                                        , td.thuonghieu
                                        , tt.trangthai_tb
                                  --      , decode(skm.tyle_tb, null, f.cuoc_tb, 0, f.cuoc_tb - skm.cuoc_tb, (100 - skm.tyle_tb) * f.cuoc_tb/100) cuoc_saukm
                                        , dt.ten_dt doituongtb
                                        , a.ngay_sd, a.ngay_td, a.ngay_cat, round(months_between(a.ngay_cat, a.ngay_sd), 1) tg_sd_stb
                                        , hd.ma_gd ma_gd_dauvao
                                        , tbi.tentrangbi kieu_tbi_dauvao
                                        , tbi1.tentrangbi kieu_tbi_hientai
                                        , decode (hd.trangbi_id, null, null, b.trangbi_id, 0, 1) Thaydoi_trangbi
                                        , dc.ten_tbi thietbi_dauvao
                                        , dc1.ten_tbi thietbi_hientai
                                        , hk.ketqua_xl Thuhoi_tbi_thaydoiMYTV_ldau
                                        , hk1.ma_gd ma_gd_trabi_thdoi_ldau
                                        , hk2.ketqua_xl Thuhoi_tbi_Chem_thly_lcuoi
                                        , hk3.ma_gd ma_gd_trabi_lcuoi
                                        , hk1.hdtb_id, a.thuebao_id, hk2.kqxl_id, hd.trangbi_id, a.trangthaitb_id
                                     --   , b.trangbi_id, b.thietbidc_id
                                        , dv.ten_dv, dv1.ten_dv To_vt
                        from CSS.v_db_thuebao@dataguard a
                                left join hk on a.thuebao_id = hk.thuebao_id and hk.rnk = 1
                                left join hk1 on hk.kqxl_id = hk1.kqxl_id and hk.thuebao_id = hk1.thuebao_id and hk1.rnk = 1
                                ------thue bao chem hoac thanh ly---
                                left join hk2 on a.thuebao_id = hk2.thuebao_id and hk2.rnk = 1
                                left join hk3 on hk2.kqxl_id = hk3.kqxl_id and hk2.thuebao_id = hk3.thuebao_id and hk3.rnk = 1

                              --    left join (select thuebao_id, pbh_ql_id from ttkd_bct.db_thuebao_ttkd) j on a.thuebao_id = j.thuebao_id
                                  left join hd on a.thuebao_id = hd.thuebao_id
                          --      left join  (select distinct thuebao_id, loaitbi_id from css_hcm.sudung_tbi) tbi on a.thuebao_id = tbi.thuebao_id
                                  join CSS.v_db_adsl@dataguard b on a.thuebao_id = b.thuebao_id
                                  left join admin.v_donvi@dataguard dv on a.donvi_id = dv.donvi_id
                                  left join j on a.thuebao_id = j.thuebao_id
                                  left join admin.v_donvi@dataguard dv1 on j.donvi_id = dv1.donvi_id
                                  left join CSS.tocdo_adsl@dataguard td on td.tocdo_id = b.tocdo_id
                                  left join CSS.trangthai_tb@dataguard tt on tt.trangthaitb_id = a.trangthaitb_id
                                  left join CSS.v_doituong@dataguard dt on dt.doituong_id = a.doituong_id
                                  left join CSS.trangbi@dataguard tbi on tbi.trangbi_id = hd.trangbi_id
                                  left join CSS.trangbi@dataguard tbi1 on tbi1.trangbi_id = b.trangbi_id
                                  left join CSS.tbi_daucuoi@dataguard dc on dc.thietbidc_id = hd.thietbidc_id
                                  left join CSS.tbi_daucuoi@dataguard dc1 on dc1.thietbidc_id = b.thietbidc_id
                            --      left join css_hcm.ketqua_xl xl on xl.kqxl_id = hk.kqxl_id
                           --       left join css_hcm.ketqua_xl xl1 on xl1.kqxl_id = hk2.kqxl_id
                              --    left join kj on kj.hdtb_id = hk1.hdtb_id
                              --    left join kj1 on kj1.hdtb_id = hk3.hdtb_id
                        where a.loaitb_id = 61 --and a.trangthaitb_id in (5,6,7,9)
                                        and b.chuquan_id = 145 and ((to_number(to_char(a.ngay_cat, 'yyyymm'))  =202501 and a.trangthaitb_id in (7, 9)) or (to_number(to_char(a.ngay_td, 'yyyymm')) =202501 and a.trangthaitb_id in (5,6)))

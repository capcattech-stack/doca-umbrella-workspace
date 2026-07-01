-- SQL script to insert/upsert new products into Supabase public.products table
INSERT INTO public.products (slug, name, category, price, wholesale_price, affiliate_url, image_url, quote)
VALUES
  ('hat-cho-meo-mr-vet-1kg', 'Hạt cho mèo Mr.Vet 1kg', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/9KfxZJuvK2', NULL, 'Bữa hạt giòn tan, chăm chút hệ tiêu hóa nhạy cảm để con luôn khỏe mạnh, tràn đầy năng lượng.'),
  ('hat-cho-meo-whiskas-1-1kg', 'Hạt cho mèo Whiskas 1,1kg', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/18ISGGcTZ', NULL, 'Hương vị đại dương thơm ngon hấp dẫn, mang đến niềm vui thích thú trong từng bữa ăn của con.'),
  ('vien-tay-giun-san-cho-meo-fivevet', 'Viên tẩy giun sán chó mèo Fivevet', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/AUruxeRQKo', NULL, 'Chăm sóc sức khỏe toàn diện từ bên trong để con thoải mái vui đùa, chạy nhảy lớn khôn.'),
  ('sua-tam-cho-thu-cung', 'Sữa tắm', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/BRiepCgTK', NULL, 'Làn bọt êm ái xoa dịu làn da nhạy cảm, giữ cho bộ lông con luôn bông mềm và thơm mát.'),
  ('khu-mui-nuoc-tieu-mui-hoi-thu-cung-kanoo-pet', 'Khử mùi nước tiểu, mùi hôi thú cưng Kanoo Pet', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/1Vx6FMs7ff', NULL, 'Khử sạch mùi hôi khó chịu, trả lại bầu không khí trong lành, ấm cúng và thư thái cho cả nhà.'),
  ('pate-meo-moi-lua-tuoi-catchy-400g', 'Pate mèo mọi lứa tuổi Catchy 400g', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/7fXjawyXdL', NULL, 'Pate thơm ngậy giàu dinh dưỡng, đánh thức mọi giác quan của con ngay khi mở nắp.'),
  ('pate-sua-de-bite-of-wild-bich-70g-cho-meo-tu-2-thang-tuoi', 'Pate sữa dê cao cấp Bite of Wild bịch 70g, mèo từ 2 tháng tuổi', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/1Vx6FitCi4', NULL, 'Sự kết hợp ngọt lành từ sữa dê thanh mát, nuôi dưỡng thể trạng cho con trong giai đoạn phát triển đầu đời.'),
  ('pate-sua-de-bite-of-wild-hop-12-goi-70g', 'Pate sữa dê cao cấp Bite of Wild hộp 12 gói 70g', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/1qZwkMLaAE', NULL, 'Hộp quà dinh dưỡng tiện lợi chăm sóc từng bữa ăn ngon cho con luôn khỏe khoắn.'),
  ('hat-cho-meo-con-bite-of-wild-1kg', 'Hạt cho mèo con Bite of Wild 1kg', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/BRifIMHSh', NULL, 'Hạt giàu đạm tự nhiên nâng niu đề kháng, đồng hành cùng con lớn khôn khỏe mạnh mỗi ngày.'),
  ('pate-lon-cho-meo-400g-mr-vet', 'Pate lon cho mèo 400g Mr.Vet', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/1gGWSC1f0g', NULL, 'Bữa ăn ướt sánh mịn hấp dẫn, cung cấp độ ẩm cần thiết giữ cho cơ thể con luôn cân bằng, khỏe khoắn.'),
  ('khan-tam-sieu-hut-nuoc-cho-meo-mastercare', 'Khăn tắm siêu hút nước chó mèo Mastercare', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/4LHHd9SJTX', NULL, 'Cái ôm ấm áp siêu thấm hút sau khi tắm, bảo vệ con yêu khỏi những cơn cảm lạnh bất chợt.'),
  ('dau-ca-hoi-giam-rung-long-gympet', 'Dầu cá hồi cho chó mèo, giảm rụng lông GYMPET', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/2g98TexmeC', NULL, 'Nuôi dưỡng bộ lông bóng mượt, giảm rụng từ gốc để Boss luôn kiêu kỳ, đáng yêu.'),
  ('luoc-chai-long-hoi-nuoc-thu-cung', 'Lược chải lông hơi nước cho thú cưng', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/9zvjDdATZG', NULL, 'Hơi nước dịu nhẹ giúp loại bỏ lông rụng và massage thư giãn, vuốt ve làn da của bé.'),
  ('may-say-long-cho-meo-3in1-600w', 'Máy sấy lông chó mèo 3in1 công suất 600W', 'phu_kien', 0.0, NULL, 'https://s.shopee.vn/7fXoRk4veE', NULL, 'Sấy khô dịu nhẹ, tạo kiểu bồng bềnh sau mỗi lần tắm để Boss luôn ấm áp, thơm tho.'),
  ('luoc-chai-long-petgravity-3in1', 'Lược chải lông cho chó mèo 3 trong 1 Petgravity', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/1qa1UrearQ', NULL, 'Lược đa năng chải gỡ rối và massage êm ái, cho Boss những phút giây thư giãn yên lành.'),
  ('long-say-long-khu-khuan-ozone-yimaida', 'Lồng sấy lông chó mèo khử khuẩn Ozone YIMAIDA', 'phu_kien', 0.0, NULL, 'https://s.shopee.vn/8V6vRjqWUk', NULL, 'Không gian sấy ấm áp, êm ái tích hợp ozone khử khuẩn cho Boss cảm giác thư thái tuyệt đối.'),
  ('balo-cho-cho-meo-thoang-khi-luna', 'Balo cho chó mèo thoáng khí Luna', 'phu_kien', 0.0, NULL, 'https://s.shopee.vn/6Aj0fjxuS8', NULL, 'Chiếc phi thuyền thoáng đãng cùng Sen chu du khắp thế gian, ôm trọn tầm nhìn thế giới.'),
  ('chai-xit-khu-mui-diet-khuan-biopro', 'Chai xịt khử mùi, diệt khuẩn khu vực nuôi thú cưng Biopro', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/3B5P6t0T4d', NULL, 'Không gian sống trong lành, sạch mát để bảo vệ sức khỏe của Boss lẫn Sen thương yêu.'),
  ('nuoc-lau-san-phong-giun-san-mastercare', 'Nước lau sàn phòng ngừa lây giun sán sang người 1 Lít Mastercare', 'vat_pham', 0.0, NULL, 'https://s.shopee.vn/4fuCu1yOpM', NULL, 'Sạch khuẩn tối đa, phòng ngừa giun sán hiệu quả cho cả nhà luôn an tâm đùa vui.'),
  ('gan-bo-say-kho-mastercare-90g', 'Gan bò sấy khô chó mèo giảm rụng lông, sáng mắt, tốt tim mạch 90g Masercare', 'thuc_an', 0.0, NULL, 'https://s.shopee.vn/5fmk61vZUk', NULL, 'Món ngon giòn sấy giàu dưỡng chất, bổ mắt tốt tim để Boss ăn vặt trạng đầy năng lượng.')
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  wholesale_price = EXCLUDED.wholesale_price,
  affiliate_url = EXCLUDED.affiliate_url,
  image_url = EXCLUDED.image_url,
  quote = EXCLUDED.quote;
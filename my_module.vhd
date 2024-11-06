## Authorization System

  module authorization_system(
    input [7:0] username,       // 8-bit kullanıcı adı
    input [7:0] password,       // 8-bit şifre
    output reg authorized       // Yetkilendirme sinyali
);

    // Sabit kullanıcı adı ve şifre belirleyelim
    parameter [7:0] USERNAME = 8'h55;  // Örneğin, kullanıcı adı: 0x55
    parameter [7:0] PASSWORD = 8'hAA;  // Örneğin, şifre: 0xAA

    // Yetkilendirme işlemi
    always @(*) begin
        if (username == USERNAME && password == PASSWORD)
            authorized = 1'b1;  // Kullanıcı adı ve şifre doğru ise yetkilendir
        else
            authorized = 1'b0;  // Yanlış ise yetkilendirme yok
    end

endmodule


## General Managament System

      module general_management_system(
    input [7:0] user_id,             // 8-bit kullanıcı kimliği
    input [1:0] role,                // 2-bit rol (00: User, 01: Admin, 10: Supervisor)
    input [1:0] operation,           // 2-bit işlem türü (00: Read, 01: Write, 10: Delete)
    output reg access_granted,       // Erişim izni
    output reg operation_success     // İşlem başarısı
);

    // Önceden tanımlanmış kullanıcı kimliği ve rolleri
    parameter [7:0] VALID_USER_ID = 8'hA5; // Sabit kullanıcı kimliği
    parameter [1:0] USER = 2'b00;
    parameter [1:0] ADMIN = 2'b01;
    parameter [1:0] SUPERVISOR = 2'b10;

    // Erişim kontrolü ve işlemi gerçekleştirme
    always @(*) begin
        // Varsayılan olarak izinleri kapat
        access_granted = 1'b0;
        operation_success = 1'b0;

        // Kimlik doğrulama
        if (user_id == VALID_USER_ID) begin
            access_granted = 1'b1;  // Kimlik doğrulandı, erişim izni ver
            case (role)
                USER: begin
                    // USER sadece okuma yapabilir
                    if (operation == 2'b00)
                        operation_success = 1'b1;  // Okuma başarılı
                end

                ADMIN: begin
                    // ADMIN okuma ve yazma yapabilir
                    if (operation == 2'b00 || operation == 2'b01)
                        operation_success = 1'b1;  // İşlem başarılı
                end

                SUPERVISOR: begin
                    // SUPERVISOR tüm işlemleri yapabilir (okuma, yazma, silme)
                    operation_success = 1'b1;  // İşlem başarılı
                end

                default: begin
                    // Geçersiz rol durumunda işlem başarısız
                    operation_success = 1'b0;
                end
            endcase
        end
    end

endmodule


      ## Smart Lighting System

      module smart_lighting_system(
    input light_sensor,            // Ortam ışık sensörü (1: karanlık, 0: aydınlık)
    input motion_sensor,           // Hareket sensörü (1: hareket var, 0: hareket yok)
    input manual_switch,           // Manuel açma-kapama düğmesi (1: açık, 0: kapalı)
    input [3:0] hour,              // Saat bilgisi (0-23 arası)
    output reg light               // Işık durumu (1: açık, 0: kapalı)
);

    // Belirli saatler için zamanlayıcı sınırları
    parameter NIGHT_START = 4'd18; // Akşam 18:00
    parameter NIGHT_END = 4'd6;    // Sabah 6:00

    // Akıllı aydınlatma kontrolü
    always @(*) begin
        // Manuel düğme açık ise ışığı aç
        if (manual_switch) begin
            light = 1'b1;
        end
        // Manuel düğme kapalı ve ışık sensörü karanlıkta ise
        else if (light_sensor) begin
            // Hareket varsa ışığı aç (harekete duyarlı)
            if (motion_sensor) begin
                light = 1'b1;
            end
            // Zamanlayıcıya bağlı ışık kontrolü (sadece gece saatlerinde açılır)
            else if ((hour >= NIGHT_START) || (hour < NIGHT_END)) begin
                light = 1'b1;
            end
            else begin
                light = 1'b0;
            end
        end
        // Diğer durumlarda ışığı kapat
        else begin
            light = 1'b0;
        end
    end

endmodule


      ## White Goods Control

      module white_goods_control(
    input manual_laundry,           // Çamaşır makinesi manuel açma (1: açık, 0: kapalı)
    input manual_dishwasher,        // Bulaşık makinesi manuel açma (1: açık, 0: kapalı)
    input manual_oven,              // Fırın manuel açma (1: açık, 0: kapalı)
    input [3:0] hour,               // Günün saat bilgisi (0-23)
    output reg laundry_on,          // Çamaşır makinesi durumu
    output reg dishwasher_on,       // Bulaşık makinesi durumu
    output reg oven_on              // Fırın durumu
);

    // Otomatik başlatma saatleri
    parameter LAUNDRY_AUTO_START = 4'd7;     // Çamaşır makinesi için otomatik başlatma saati (7:00)
    parameter DISHWASHER_AUTO_START = 4'd22; // Bulaşık makinesi için otomatik başlatma saati (22:00)
    parameter OVEN_AUTO_START = 4'd18;       // Fırın için otomatik başlatma saati (18:00)

    // Beyaz eşya kontrol sistemi
    always @(*) begin
        // Çamaşır Makinesi Kontrolü
        if (manual_laundry || (hour == LAUNDRY_AUTO_START)) begin
            laundry_on = 1'b1;  // Manuel açılmış veya otomatik saatinde
        end else begin
            laundry_on = 1'b0;  // Diğer durumlarda kapalı
        end

        // Bulaşık Makinesi Kontrolü
        if (manual_dishwasher || (hour == DISHWASHER_AUTO_START)) begin
            dishwasher_on = 1'b1;  // Manuel açılmış veya otomatik saatinde
        end else begin
            dishwasher_on = 1'b0;  // Diğer durumlarda kapalı
        end

        // Fırın Kontrolü
        if (manual_oven || (hour == OVEN_AUTO_START)) begin
            oven_on = 1'b1;  // Manuel açılmış veya otomatik saatinde
        end else begin
            oven_on = 1'b0;  // Diğer durumlarda kapalı
        end
    end

endmodule

      ## Smart Home Control

      module smart_home_control(
    input sunlight_sensor,         // Güneş ışığı sensörü (1: güneş var, 0: güneş yok)
    input temp_sensor,             // Sıcaklık sensörü (1: sıcak, 0: soğuk)
    input air_quality_sensor,      // Hava kalitesi sensörü (1: iyi, 0: kötü)
    input manual_curtain,          // Perde manuel açma-kapama (1: açık, 0: kapalı)
    input manual_window,           // Pencere manuel açma-kapama (1: açık, 0: kapalı)
    input manual_door_lock,        // Kapı manuel kilitleme (1: kilitle, 0: aç)
    output reg curtain_open,       // Perde durumu (1: açık, 0: kapalı)
    output reg window_open,        // Pencere durumu (1: açık, 0: kapalı)
    output reg door_locked         // Kapı durumu (1: kilitli, 0: açık)
);

    // Perde Kontrolü
    always @(*) begin
        // Manuel kontrol: Kullanıcı perdeyi açmak istiyorsa
        if (manual_curtain) begin
            curtain_open = 1'b1;
        end
        // Otomatik kontrol: Güneş yoksa perdeyi aç, varsa kapat
        else if (!sunlight_sensor) begin
            curtain_open = 1'b1;  // Güneş yok, perdeyi aç
        end else begin
            curtain_open = 1'b0;  // Güneş var, perdeyi kapat
        end
    end

    // Pencere Kontrolü
    always @(*) begin
        // Manuel kontrol: Kullanıcı pencereyi açmak istiyorsa
        if (manual_window) begin
            window_open = 1'b1;
        end
        // Otomatik kontrol: Sıcaksa ve hava kalitesi iyiyse pencereyi aç
        else if (temp_sensor && air_quality_sensor) begin
            window_open = 1'b1;  // Sıcak ve hava iyi, pencereyi aç
        end else begin
            window_open = 1'b0;  // Diğer durumlarda pencereyi kapat
        end
    end

    // Kapı Kontrolü
    always @(*) begin
        // Manuel kontrol: Kullanıcı kapıyı kilitlemek istiyorsa
        if (manual_door_lock) begin
            door_locked = 1'b1;  // Kapıyı kilitle
        end else begin
            door_locked = 1'b0;  // Kapıyı aç
        end
    end

endmodule

      ## Climate Control System

      module climate_control_system(
    input [7:0] temp,               // Sıcaklık değeri (8-bit, örneğin 0-255 arasında)
    input [7:0] humidity,           // Nem değeri (8-bit, örneğin 0-255 arasında)
    input manual_heater,            // Manuel ısıtıcı kontrolü (1: açık, 0: kapalı)
    input manual_ac,                // Manuel klima kontrolü (1: açık, 0: kapalı)
    input manual_humidifier,        // Manuel nemlendirici kontrolü (1: açık, 0: kapalı)
    input manual_dehumidifier,      // Manuel nem giderici kontrolü (1: açık, 0: kapalı)
    output reg heater_on,           // Isıtıcı durumu (1: açık, 0: kapalı)
    output reg ac_on,               // Klima durumu (1: açık, 0: kapalı)
    output reg humidifier_on,       // Nemlendirici durumu (1: açık, 0: kapalı)
    output reg dehumidifier_on      // Nem giderici durumu (1: açık, 0: kapalı)
);

    // Sıcaklık ve nem için ideal aralıklar
    parameter [7:0] TEMP_LOW_THRESHOLD = 8'd18;      // Minimum sıcaklık (örn: 18°C)
    parameter [7:0] TEMP_HIGH_THRESHOLD = 8'd26;     // Maksimum sıcaklık (örn: 26°C)
    parameter [7:0] HUMIDITY_LOW_THRESHOLD = 8'd30;  // Minimum nem (%30)
    parameter [7:0] HUMIDITY_HIGH_THRESHOLD = 8'd60; // Maksimum nem (%60)

    // Isıtıcı Kontrolü
    always @(*) begin
        if (manual_heater) begin
            heater_on = 1'b1; // Manuel olarak ısıtıcıyı aç
        end
        else if (temp < TEMP_LOW_THRESHOLD) begin
            heater_on = 1'b1; // Sıcaklık düşük, ısıtıcıyı aç
        end
        else begin
            heater_on = 1'b0; // Diğer durumlarda ısıtıcı kapalı
        end
    end

    // Klima (AC) Kontrolü
    always @(*) begin
        if (manual_ac) begin
            ac_on = 1'b1; // Manuel olarak klimayı aç
        end
        else if (temp > TEMP_HIGH_THRESHOLD) begin
            ac_on = 1'b1; // Sıcaklık yüksek, klimayı aç
        end
        else begin
            ac_on = 1'b0; // Diğer durumlarda klima kapalı
        end
    end

    // Nemlendirici Kontrolü
    always @(*) begin
        if (manual_humidifier) begin
            humidifier_on = 1'b1; // Manuel olarak nemlendiriciyi aç
        end
        else if (humidity < HUMIDITY_LOW_THRESHOLD) begin
            humidifier_on = 1'b1; // Nem düşük, nemlendiriciyi aç
        end
        else begin
            humidifier_on = 1'b0; // Diğer durumlarda nemlendirici kapalı
        end
    end

    // Nem Giderici Kontrolü
    always @(*) begin
        if (manual_dehumidifier) begin
            dehumidifier_on = 1'b1; // Manuel olarak nem gidericiyi aç
        end
        else if (humidity > HUMIDITY_HIGH_THRESHOLD) begin
            dehumidifier_on = 1'b1; // Nem yüksek, nem gidericiyi aç
        end
        else begin
            dehumidifier_on = 1'b0; // Diğer durumlarda nem giderici kapalı
        end
    end

endmodule

      ## AC Control

      module ac_control(
    input [7:0] temp,             // Sıcaklık değeri (8-bit, örneğin 0-255 arasında)
    input [7:0] target_temp_low,  // Hedef sıcaklık alt sınırı
    input [7:0] target_temp_high, // Hedef sıcaklık üst sınırı
    input manual_ac,              // Manuel klima kontrolü (1: açık, 0: kapalı)
    output reg ac_on              // Klima durumu (1: açık, 0: kapalı)
);

    // Klima kontrolü
    always @(*) begin
        // Manuel kontrol: Eğer kullanıcı klimayı açmak istemişse
        if (manual_ac) begin
            ac_on = 1'b1; // Klima manuel olarak açık
        end
        // Otomatik kontrol: Sıcaklık, hedef sıcaklık aralığının dışındaysa klima açılır
        else if (temp > target_temp_high) begin
            ac_on = 1'b1; // Sıcaklık yüksek, klima açılır
        end
        else if (temp < target_temp_low) begin
            ac_on = 1'b0; // Sıcaklık düşük, klima kapalı
        end
        else begin
            ac_on = 1'b0; // Sıcaklık ideal aralıkta, klima kapalı
        end
    end

endmodule

      ## Heating System Control

      module heating_system_control(
    input [7:0] temp,               // Mevcut sıcaklık (8-bit)
    input [7:0] target_temp_low,    // Hedef sıcaklık alt sınırı
    input [7:0] target_temp_high,   // Hedef sıcaklık üst sınırı
    input manual_heater,            // Manuel ısıtıcı kontrolü (1: aç, 0: kapat)
    output reg heater_on            // Isıtıcı durumu (1: açık, 0: kapalı)
);

    // Isıtıcı kontrolü
    always @(*) begin
        // Manuel kontrol: Kullanıcı ısıtıcıyı manuel olarak açtıysa
        if (manual_heater) begin
            heater_on = 1'b1; // Isıtıcı manuel olarak açık
        end
        // Otomatik kontrol: Sıcaklık hedef alt sınırın altındaysa ısıtıcı açılır
        else if (temp < target_temp_low) begin
            heater_on = 1'b1; // Sıcaklık düşük, ısıtıcı açılır
        end
        // Sıcaklık hedef üst sınıra ulaştığında ısıtıcı kapanır
        else if (temp >= target_temp_high) begin
            heater_on = 1'b0; // Sıcaklık yeterli, ısıtıcı kapanır
        end
        else begin
            // Diğer durumlarda mevcut durumu koru
            heater_on = heater_on;
        end
    end

endmodule

      ## Safety System

      module SafetySystem(
    input wire motion_sensor,     // Hareket algılayıcı sinyali (1: hareket var, 0: hareket yok)
    input wire arm_system,        // Güvenlik sistemi aktiflik sinyali (1: aktif, 0: pasif)
    output reg alarm              // Alarm sinyali (1: alarm çalıyor, 0: alarm kapalı)
);

// Sistem logicini tanımlayalım
always @(motion_sensor or arm_system) begin
    if (arm_system && motion_sensor) begin
        alarm <= 1;               // Güvenlik sistemi aktif ve hareket algılandıysa alarm çalsın
    end else begin
        alarm <= 0;               // Aksi durumda alarm kapalı olsun
    end
end

endmodule

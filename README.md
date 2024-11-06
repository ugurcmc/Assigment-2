# Assigment-2

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

## General Management System

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

import '../domain/entities/guide.dart';

class GuideConstants {
  GuideConstants._();

  static const Guide vinNumberGuide = Guide(
    position: [
      TextParagraph(
        'Thường nằm ở một trong các vị trí: góc dưới kính chắn gió (bên lái), sườn trong cửa tài xế, khoang động cơ, hoặc dưới ghế phụ.',
      ),
    ],
    requirement: [
      TextParagraph(
        'Chụp ảnh đảm bảo dãy số hiển thị trọn vẹn, rõ nét từng ký tự và không bị lóa sáng. Nếu số khung bị bẩn, vui lòng lau nhẹ trước khi chụp.',
      ),
    ],
    samplePhotoUrls: [
      'assets/images/img_vin_guide.png',
    ], // Fallback or mock asset path
    capturePhotoUrls: [],
  );

  static const Guide regStampGuide = Guide(
    position: [
      TextParagraph('Ở góc trên bên phải (bên ghế phụ) kính chắn gió trước.'),
    ],
    requirement: [
      TextParagraph(
        'Chọn nơi có bóng râm, tránh phản chiếu ánh sáng làm mờ thông tin. Đặt máy ảnh vuông góc với tem, canh tem ở giữa khung hình.',
      ),
    ],
    samplePhotoUrls: [
      'assets/images/img_reg_stamp.png',
    ], // Fallback or mock asset path
    capturePhotoUrls: [],
  );

  static const Guide regCertGuide = Guide(
    position: [],
    requirement: [
      TextParagraph(
        'Hãy đặt sổ đăng kiểm trên nền phẳng, chụp rõ 2 mặt vuông góc từ trên xuống, đảm bảo chữ không bị loá, mờ hay che khuất.',
      ),
    ],
    samplePhotoUrls: [
      'assets/images/img_reg_cert_1.png',
      'assets/images/img_reg_cert_2.png',
    ], // Fallback or mock asset path
    capturePhotoUrls: [],
  );

  static const Guide taploGuide = Guide(
    position: [
      TextParagraph(
        'Để ghi nhận tình trạng nội thất và số Kilomet (ODO), vui lòng chụp bao quát khu vực Taplo (nằm ngay dưới kính chắn gió). Tuỳ thuộc vào loại xe, Taplo thường ở vị trí sau:\n',
      ),
      BulletGroup([
        BulletPoint(
          prefix: 'Xe thông thường:',
          content: 'Cụm đồng hồ hiển thị nằm ngay phía sau vô lăng.',
        ),
        BulletPoint(
          prefix: 'Một số dòng xe điện/đời mới:',
          content: 'Màn hình hiển thị thông số nằm ở chính giữa xe.',
        ),
      ]),
    ],
    requirement: [
      TextParagraph(
        'Hãy đặt sổ đăng kiểm trên nền phẳng, chụp rõ 2 mặt vuông góc từ trên xuống, đảm bảo chữ không bị loá, mờ hay che khuất.',
      ),
    ],
    samplePhotoUrls: [
      'assets/images/img_odo.png',
      'assets/images/img_dashboard.png',
    ], // Fallback or mock asset path
    capturePhotoUrls: [],
  );
}

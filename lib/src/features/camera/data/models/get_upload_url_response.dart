class GetUploadUrlResponse {
  final List<UploadUrlItem>? urls;

  GetUploadUrlResponse({this.urls});

  factory GetUploadUrlResponse.fromJson(Map<String, dynamic> json) {
    return GetUploadUrlResponse(
      urls: (json['urls'] as List?)
          ?.map((e) => UploadUrlItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'urls': urls?.map((e) => e.toJson()).toList()};
  }
}

class UploadUrlItem {
  final String? uploadUrl;
  final String? filePath;

  UploadUrlItem({this.uploadUrl, this.filePath});

  factory UploadUrlItem.fromJson(Map<String, dynamic> json) {
    return UploadUrlItem(
      uploadUrl: json['uploadUrl'] as String?,
      filePath: json['filePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uploadUrl': uploadUrl, 'filePath': filePath};
  }
}

class AssistantReplyModel {
  final String reply;

  const AssistantReplyModel({required this.reply});

  factory AssistantReplyModel.fromJson(Map<String, dynamic> json) {
    return AssistantReplyModel(
      reply: json['reply'] as String? ?? 'No reply received.',
    );
  }
}

class AssistantMessage {
  final String sender; // 'user' أو 'bot'
  final String text;

  AssistantMessage({required this.sender, required this.text});

  factory AssistantMessage.fromJson(Map<String, dynamic> json) =>
      AssistantMessage(
        sender: json["sender"] ?? "",
        text: json["text"] ?? "",
      );

  Map<String, dynamic> toJson() => {"sender": sender, "text": text};
}
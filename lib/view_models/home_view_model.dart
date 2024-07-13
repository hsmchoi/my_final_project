// home_view_model.dart
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/utilities.dart' as analyzer;
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  // 추출된 키워드를 저장할 리스트
  List<String> _extractedKeywords = [];
  List<String> get extractedKeywords => _extractedKeywords;

  // 입력 필드 컨트롤러
  final TextEditingController _answerController = TextEditingController();

  // 생성자
  HomeViewModel() {
    _answerController.addListener(_extractKeywords);
  }

  // 키워드 추출 함수
  void _extractKeywords() {
    _extractedKeywords = extractKeywords(_answerController.text);
    notifyListeners();
  }

  // _answerController를  외부에서  접근할  수  있도록  getter를  추가합니다.
  TextEditingController get answerController => _answerController;

  // 키워드 추출 로직 (analyzer 패키지 사용)
  List<String> extractKeywords(String text) {
    final parseResult = analyzer.parseString(content: text);
    final keywords = <String>[];

    void visitNode(AstNode node) {
      if (node is SimpleIdentifier) {
        final token = node.token;
        if (token.isKeyword) {
          keywords.add(token.lexeme);
        }
      }
      for (var child in node.childEntities) {
        visitNode(child as AstNode); // SyntacticEntity를 AstNode로 변경합니다.
      }
    }

    visitNode(parseResult.unit);

    return keywords.toSet().toList();
  }
}

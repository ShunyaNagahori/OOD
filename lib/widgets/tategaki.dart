import 'package:flutter/material.dart';

class Tategaki extends StatelessWidget {
  const Tategaki(
    this.text, {super.key, 
    this.style,
    this.space = 12,
    this.lineSpace,
    this.fontSize,
    this.fontWeight,
  });

  final String text;
  final TextStyle? style;
  final double space;
  final double? lineSpace;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final splitText = text.split("\n");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        for (var s in splitText) _textBox(s.runes),
      ],
    );
  }

  Widget _textBox(Runes runes) {
    return Wrap(
      textDirection: TextDirection.rtl,
      direction: Axis.vertical,
      children: [
        for (var rune in runes)
          Row(
            children: [
              SizedBox(
                width: space,
                height: lineSpace,
              ),
              _character(String.fromCharCode(rune)),
            ],
          )
      ],
    );
  }

  Widget _character(String char) {
    if (VerticalRotated.map[char] != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 3.5),
        child: Text(
          VerticalRotated.map[char]!,
          style: _buildTextStyle(),
        ),
      );
    } else if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.5, bottom: 4.5),
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            char,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 3.5),
        child: Text(
          char,
          style: _buildTextStyle(),
        ),
      );
    }
  }

  TextStyle _buildTextStyle() {
    return style?.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ) ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        );
  }
}

class VerticalRotated {
  static const map = {
    ' ': '　',
    '↑': '→',
    '↓': '←',
    '←': '↑',
    '→': '↓',
    '。': '︒',
    '、': '︑',
    'ー': '丨',
    '─': '丨',
    '-': '丨',
    'ｰ': '丨',
    '_': '丨 ',
    '−': '丨',
    '－': '丨',
    '—': '丨',
    '〜': '丨',
    '～': '丨',
    '／': '＼',
    '…': '︙',
    '‥': '︰',
    '︙': '…',
    '：': '︓',
    ':': '︓',
    '；': '︔',
    ';': '︔',
    '＝': '॥',
    '=': '॥',
    '（': '︵',
    '(': '︵',
    '）': '︶',
    ')': '︶',
    '［': '﹇',
    "[": '﹇',
    '］': '﹈',
    ']': '﹈',
    '｛': '︷',
    '{': '︷',
    '＜': '︿',
    '<': '︿',
    '＞': '﹀',
    '>': '﹀',
    '｝': '︸',
    '}': '︸',
    '「': '﹁',
    '」': '﹂',
    '『': '﹃',
    '』': '﹄',
    '【': '︻',
    '】': '︼',
    '〖': '︗',
    '〗': '︘',
    '｢': '﹁',
    '｣': '﹂',
    ',': '︐',
    '､': '︑',
    '1': '１',
    '2': '２',
    '3': '３',
    '4': '４',
    '5': '５',
    '6': '６',
    '7': '７',
    '8': '８',
    '9': '９',
    'a': 'ａ',
    'b': 'ｂ',
    'c': 'ｃ',
    'd': 'ｄ',
    'e': 'ｅ',
    'f': 'ｆ',
    'g': 'ｇ',
    'h': 'ｈ',
    'i': 'ｉ',
    'j': 'ｊ',
    'k': 'ｋ',
    'l': 'ｌ',
    'm': 'ｍ',
    'n': 'ｎ',
    'o': 'ｏ',
    'p': 'ｐ',
    'q': 'ｑ',
    'r': 'ｒ',
    's': 'ｓ',
    't': 'ｔ',
    'u': 'ｕ',
    'v': 'ｖ',
    'w': 'ｗ',
    'x': 'ｘ',
    'y': 'ｙ',
    'z': 'ｚ',
  };
}

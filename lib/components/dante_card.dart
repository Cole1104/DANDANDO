import 'package:flutter/material.dart';
import '../theme/responsive.dart';
class DanteCard extends StatelessWidget {
  const DanteCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    final imageSize =
    Responsive.imageSize(context);

    final quoteSize =
    Responsive.quoteSize(context);

    final padding =
    Responsive.cardPadding(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 상단
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "DANTE · 실망",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 단테 PNG 자리
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: const Center(
                    child: Text(
                      "DANTE\nPNG",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// 대사
            Text(
              '"오늘도\n보고할 내용이 없군."',
              style: TextStyle(
                fontSize: quoteSize,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "마지막 완료 : 2일 전",
              style: TextStyle(
                color: Colors.white.withOpacity(0.45),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 36),

            Divider(
              color: Colors.white.withOpacity(0.08),
            ),

            const SizedBox(height: 20),

            /// 하단 정보
            Row(
              children: [

                Expanded(
                  child: _InfoItem(
                    title: "신뢰도",
                    value: "78",
                  ),
                ),

                Expanded(
                  child: _InfoItem(
                    title: "미이행",
                    value: "2일",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// 업무 착수 버튼
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  child: Text(
                    "업무 착수",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
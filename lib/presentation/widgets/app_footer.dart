import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Website-style footer with dummy data
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.charcoal,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FooterColumn(
                title: 'Shop',
                links: const [
                  ('Rings', '/'),
                  ('Necklaces', '/'),
                  ('Bracelets', '/'),
                  ('Earrings', '/'),
                ],
              ),
              _FooterColumn(
                title: 'Support',
                links: const [
                  ('Payment & Delivery', '/'),
                  ('Contact Us', '/'),
                  ('FAQs', '/'),
                ],
              ),
              _FooterColumn(
                title: 'Company',
                links: const [
                  ('About Us', '/'),
                  ('Careers', '/'),
                  ('Privacy Policy', '/'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.facebook, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2025 Gold Jewelry. All rights reserved.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<(String, String)> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {},
              child: Text(
                e.$1,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

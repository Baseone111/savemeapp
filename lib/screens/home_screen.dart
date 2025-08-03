import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/Logo.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'saveMe.',
              style: GoogleFonts.poppins(
                color: Color(0xFF1A1D29),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Color(0xFF1A1D29)),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi Jenifer!',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1D29),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Good Morning',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEF476F), Color(0xFFFF9A8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to saveMe.',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your safety is our priority. Report incidents, stay informed, and help protect your community.',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D29),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildAction(context, 'Report Incident', Icons.report,
                          Color(0xFFFF6B6B), '/report'),
                      const SizedBox(height: 16),
                      _buildAction(context, 'Emergency Help', Icons.emergency,
                          Color(0xFFEF233C), '/emergency'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      _buildAction(context, 'Missing Person',
                          Icons.person_search, Color(0xFF6C63FF), '/missing'),
                      const SizedBox(height: 16),
                      _buildAction(context, 'Safety Resources', Icons.menu_book,
                          Color(0xFF06D6A0), '/resources'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildSectionHeader('Recent Alerts', onTap: () {}),
            const SizedBox(height: 12),
            _buildAlertCard('High Risk Area Alert',
                'Downtown area - increased vigilance advised', '2h ago'),
            _buildAlertCard('Missing Person Update',
                'John Okello - last seen near Central Park', '5h ago'),
            const SizedBox(height: 30),
            _buildSectionHeader('Safety Tips'),
            const SizedBox(height: 12),
            _buildTipCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context, String label, IconData icon,
      Color color, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1D29),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1D29),
          ),
        ),
        if (onTap != null)
          TextButton(
            onPressed: onTap,
            child: Text('View All', style: TextStyle(color: Color(0xFFEF476F))),
          ),
      ],
    );
  }

  Widget _buildAlertCard(String title, String subtitle, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: Colors.orange[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(time,
              style:
                  GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber[600]),
              const SizedBox(width: 10),
              Text(
                'Tip of the Day',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1A1D29),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Trust your instincts. If something feels wrong, it probably is. Don’t hesitate to report suspicious activities.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }
}

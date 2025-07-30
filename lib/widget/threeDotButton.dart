import 'package:flutter/material.dart';

class ThreeDotPopupMenu extends StatefulWidget {
  final Function() onTidakDikunjungi;
  final Function() onBatalVerifikasi;

  const ThreeDotPopupMenu({
    Key? key,
    required this.onTidakDikunjungi,
    required this.onBatalVerifikasi,
  }) : super(key: key);

  @override
  _ThreeDotPopupMenuState createState() => _ThreeDotPopupMenuState();
}

class _ThreeDotPopupMenuState extends State<ThreeDotPopupMenu> {
  bool _showPopupMenu = false;
  final GlobalKey _buttonKey = GlobalKey(); // Key untuk mendapatkan posisi tombol
  Offset _buttonPosition = Offset.zero;
  Size _buttonSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getButtonPosition();
    });
  }

  void _getButtonPosition() {
    if (_buttonKey.currentContext != null) {
      final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
      _buttonSize = renderBox.size;
      _buttonPosition = renderBox.localToGlobal(Offset.zero);
      setState(() {}); // Perbarui UI setelah mendapatkan posisi
    }
  }

  void _togglePopupMenu() {
    setState(() {
      _showPopupMenu = !_showPopupMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Tombol Tiga Titik
        Positioned(
          left: _buttonPosition.dx,
          top: _buttonPosition.dy,
          child: GestureDetector(
            key: _buttonKey,
            onTap: _togglePopupMenu,
            child: Container(
              width: 48, // Sesuaikan ukuran
              height: 48, // Sesuaikan ukuran
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Popup Menu (Muncul jika _showPopupMenu true)
        if (_showPopupMenu)
          Positioned(
            left: _buttonPosition.dx - 100, // Sesuaikan posisi X
            top: _buttonPosition.dy - 120, // Sesuaikan posisi Y agar muncul di atas tombol
            child: _buildPopupMenu(context),
          ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Material(
      color: Colors.transparent, // Penting agar bayangan terlihat
      child: Stack(
        alignment: Alignment.bottomCenter, // Untuk penempatan 'ekor' segitiga
        children: [
          Container(
            width: 200, // Lebar pop-up
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Penting agar Column tidak mengambil ruang penuh
              children: [
                _buildMenuItem(
                  icon: Icons.not_interested, // Ganti dengan ikon yang sesuai
                  text: 'Tidak Dikunjungi',
                  onTap: () {
                    _togglePopupMenu();
                    widget.onTidakDikunjungi();
                  },
                  iconColor: Colors.orange,
                  textColor: Colors.orange,
                ),
                const Divider(color: Colors.grey, height: 1), // Garis pemisah
                _buildMenuItem(
                  icon: Icons.cancel, // Ganti dengan ikon yang sesuai
                  text: 'Batal Verifikasi',
                  onTap: () {
                    _togglePopupMenu();
                    widget.onBatalVerifikasi();
                  },
                  iconColor: Colors.orange,
                  textColor: Colors.orange,
                ),
              ],
            ),
          ),
          // 'Ekor' Segitiga (Arrow)
          Positioned(
            bottom: -8, // Sesuaikan posisi agar menyentuh tombol
            child: CustomPaint(
              painter: _ArrowPainter(Colors.white), // Sesuaikan warna dengan background pop-up
              size: const Size(16, 16), // Ukuran segitiga
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter untuk membuat bentuk segitiga (arrow)
class _ArrowPainter extends CustomPainter {
  final Color color;

  _ArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    // Tambahkan border jika pop-up memiliki border
    final Paint borderPaint = Paint()
      ..color = Colors.grey[200]! // Warna border pop-up
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final Path borderPath = Path();
    borderPath.moveTo(size.width / 2, size.height);
    borderPath.lineTo(0, 0);
    borderPath.lineTo(size.width, 0);
    borderPath.close();
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
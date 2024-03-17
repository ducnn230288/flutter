part of 'index.dart';

class _FloatingButton extends StatelessWidget {
  final Function() location;
  final Function() zoomIn;
  final Function() zoomOut;

  const _FloatingButton({required this.location, required this.zoomIn, required this.zoomOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Container(
            height: 65,
            width: 30,
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: CColor.black.shade300, width: 0.8),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: zoomIn,
                  child: const SizedBox(height: 30.75, child: Icon(Icons.add)),
                ),
                line(),
                InkWell(
                  onTap: zoomOut,
                  child: const SizedBox(height: 30.75, child: Icon(Icons.remove)),
                ),
              ],
            ),
          ),
          Container(
            height: 45,
            width: 45,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.8)),
            child: InkWell(
              onTap: location,
              child: const Icon(Icons.near_me_outlined, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

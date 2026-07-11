import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme/app_theme.dart';

class NotificationsBell extends StatefulWidget {
  const NotificationsBell({super.key});

  @override
  State<NotificationsBell> createState() => _NotificationsBellState();
}

class _NotificationsBellState extends State<NotificationsBell> {
  late List<bool> _unread =
      MockData.notifications.map((n) => n.unread).toList();
  final GlobalKey _anchorKey = GlobalKey();

  int get _unreadCount => _unread.where((u) => u).length;

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final topLeft =
        box.localToGlobal(Offset(0, box.size.height + 8), ancestor: overlay);
    final topRight = box.localToGlobal(
        Offset(box.size.width, box.size.height + 8),
        ancestor: overlay);

    await showMenu<void>(
      context: context,
      position: RelativeRect.fromLTRB(
          topRight.dx - 340, topLeft.dy, overlay.size.width - topRight.dx, 0),
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      constraints: const BoxConstraints(minWidth: 340, maxWidth: 340),
      items: [
        PopupMenuItem<void>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (context, setMenuState) {
              return SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notificaciones',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                                color: AppColors.textDark),
                          ),
                          TextButton(
                            onPressed: () {
                              setMenuState(() =>
                                  _unread = List.filled(_unread.length, false));
                              setState(() {});
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Marcar leídas',
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.mintDark,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    for (int i = 0; i < MockData.notifications.length; i++)
                      InkWell(
                        onTap: () => setMenuState(() => _unread[i] = false),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _unread[i]
                                      ? AppColors.mint
                                      : Colors.transparent,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      MockData.notifications[i].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.5,
                                          color: AppColors.textDark),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      MockData.notifications[i].subtitle,
                                      style: TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.textMuted,
                                          height: 1.4),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      MockData.notifications[i].time,
                                      style: TextStyle(
                                          fontSize: 10.5,
                                          color: AppColors.textMuted,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      key: _anchorKey,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: _openMenu,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_outlined,
                  size: 20, color: AppColors.textDark),
              if (_unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints:
                        const BoxConstraints(minWidth: 15, minHeight: 15),
                    decoration: const BoxDecoration(
                        color: AppColors.coral, shape: BoxShape.circle),
                    child: Text(
                      '$_unreadCount',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

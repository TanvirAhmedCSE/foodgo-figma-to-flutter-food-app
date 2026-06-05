import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';

class CustomerChatPage extends StatefulWidget {
  const CustomerChatPage({super.key});

  @override
  State<CustomerChatPage> createState() => _CustomerChatPageState();
}

class _CustomerChatPageState extends State<CustomerChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _currentRole = 'customer';
  Color _customerBubbleColor = AppTheme.primaryRed;
  Color _employeeBubbleColor = AppTheme.primaryRed;

  bool _isInitializing = true;

  static const String _greetingFirst = 'Hi, how can I help you?';

  Color get _myBubbleColor =>
      _currentRole == 'customer' ? _customerBubbleColor : _employeeBubbleColor;

  final List<Color> _availableColors = [
    AppTheme.primaryRed,
    const Color(0xFF1A73E8),
    const Color(0xFF0F9D58),
    const Color(0xFF9C27B0),
    const Color(0xFFFF6D00),
    const Color(0xFF00ACC1),
  ];

  CollectionReference get _messagesRef => _firestore
      .collection('support_chat')
      .doc('room_1')
      .collection('messages');

  @override
  void initState() {
    super.initState();
    _sendGreetingIfEmpty();
  }

  Future<void> _sendGreetingIfEmpty() async {
    if (mounted) setState(() => _isInitializing = true);

    final snapshot = await _messagesRef.limit(1).get();

    if (snapshot.docs.isEmpty) {
      await _messagesRef.add({
        'text': _greetingFirst,
        'sender': 'employee',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      final countSnapshot = await _messagesRef.limit(2).get();
      if (countSnapshot.docs.length == 1) {
        final data = countSnapshot.docs.first.data() as Map<String, dynamic>;
        final sender = data['sender'] as String? ?? '';
        final text = data['text'] as String? ?? '';

        if (sender == 'employee' && text == _greetingFirst) {
          await countSnapshot.docs.first.reference.delete();
          await _messagesRef.add({
            'text': _greetingFirst,
            'sender': 'employee',
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
    }

    if (mounted) setState(() => _isInitializing = false);
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();

    await _messagesRef.add({
      'text': text,
      'sender': _currentRole,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildAvatar({
    required String imagePath,
    required double radius,
    Color bgColor = AppTheme.brown,
  }) {
    final isProfile = imagePath.contains('profile.png');

    if (isProfile) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: CircleAvatar(
          radius: radius,
          backgroundColor: bgColor,
          backgroundImage: AssetImage(imagePath),
        ),
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: Center(
          child: Image.asset(
            imagePath,
            height: radius,
            width: radius,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Color selectedColor = _myBubbleColor;

            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.transparent),
                ),
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Chat Bubble Color',
                            style: AppTheme.foodTitleStyle.copyWith(
                              fontSize: 18,
                              color: AppTheme.darkText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Choose your message bubble color',
                            style: AppTheme.foodSubtitleStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: _availableColors.map((color) {
                              final isSelected = selectedColor == color;
                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() => selectedColor = color);
                                  setState(() {
                                    if (_currentRole == 'customer') {
                                      _customerBubbleColor = color;
                                    } else {
                                      _employeeBubbleColor = color;
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: isSelected
                                        ? Border.all(
                                            color: AppTheme.darkText,
                                            width: 3,
                                          )
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : null,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          Divider(color: AppTheme.lightGrayBg, height: 1),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _currentRole = _currentRole == 'customer'
                                    ? 'employee'
                                    : 'customer';
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.lightGrayBg,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _currentRole == 'customer'
                                        ? Icons.support_agent_rounded
                                        : Icons.person_rounded,
                                    color: AppTheme.darkText,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _currentRole == 'customer'
                                        ? 'Chat as Employee'
                                        : 'Chat as Customer',
                                    style: AppTheme.bodyStyle.copyWith(
                                      color: AppTheme.darkText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: AppTheme.bodyStyle.copyWith(
                                color: AppTheme.grayText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMessage(Map<String, dynamic> data) {
    final sender = data['sender'] as String? ?? 'customer';
    final isMe = sender == _currentRole;
    final text = data['text'] ?? '';
    final timestamp = data['timestamp'] as Timestamp?;

    final bubbleColor = isMe ? _myBubbleColor : AppTheme.lightGrayBg;

    final String myAvatarPath = _currentRole == 'customer'
        ? 'assets/images/profile.png'
        : 'assets/images/employee.png';

    final String otherAvatarPath = _currentRole == 'customer'
        ? 'assets/images/employee.png'
        : 'assets/images/profile.png';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              _buildAvatar(
                imagePath: otherAvatarPath,
                radius: 20,
                bgColor: AppTheme.brown,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                      boxShadow: isMe ? AppTheme.messageBubbleShadow : null,
                    ),
                    child: Text(
                      text,
                      style: AppTheme.bodyStyle.copyWith(
                        color: isMe ? AppTheme.white : AppTheme.darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  if (timestamp != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: 4,
                        left: isMe ? 0 : 4, // if not me (employee) left shift
                        right: isMe ? 4 : 0, // if me (customer) right shift
                      ),
                      child: Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          _formatTime(timestamp.toDate()),
                          style: AppTheme.foodSubtitleStyle.copyWith(
                            fontSize: 11,
                            color: AppTheme.grayText,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 8),
              _buildAvatar(
                imagePath: myAvatarPath,
                radius: 20,
                bgColor: AppTheme.brown,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inSeconds < 30) {
      return 'Just now';
    } else if (diff.inSeconds < 60) {
      final s = diff.inSeconds;
      return '$s seconds ago';
    } else if (diff.inMinutes < 60) {
      final m = diff.inMinutes;
      return m == 1 ? '1 minute ago' : '$m minutes ago';
    } else if (diff.inHours < 24) {
      final h = diff.inHours;
      return h == 1 ? '1 hour ago' : '$h hours ago';
    } else if (diff.inDays < 7) {
      final d = diff.inDays;
      return d == 1 ? '1 day ago' : '$d days ago';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: false,
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/arrow-left.png',
                height: 22,
                width: 22,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _showSettingsDialog,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/images/more.png',
                height: 18,
                width: 18,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _isInitializing
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppTheme.primaryRed,
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: _messagesRef
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Map<String, dynamic>> messages = [];

                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      messages.addAll(
                        docs.map((d) => d.data() as Map<String, dynamic>),
                      );
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 12, bottom: 105),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessage(messages[index]);
                      },
                    );
                  },
                ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildInputBar()),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 12 + bottomPadding,
      ),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppTheme.messageBubbleShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: AppTheme.bodyStyle.copyWith(
                  color: AppTheme.darkText,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Type here...',
                  hintStyle: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.grayText.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: _myBubbleColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/paper-plane.png',
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

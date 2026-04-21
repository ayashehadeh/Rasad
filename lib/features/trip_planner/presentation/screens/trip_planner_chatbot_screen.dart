import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constatnts/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/trip_planner_bloc.dart';
import '../bloc/trip_planner_event.dart';
import '../bloc/trip_planner_state.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = _inputController.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    context.read<TripPlannerBloc>().add(TripPlannerMessageSent(text));
    _scrollToBottom();
  }

  void _tapSuggestion(String s) {
    context.read<TripPlannerBloc>().add(TripPlannerSuggestionTapped(s));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripPlannerBloc, TripPlannerState>(
      listener: (context, state) {
        if (state is TripPlannerActive) _scrollToBottom();
      },
      builder: (context, state) {
        final active = state is TripPlannerActive ? state : null;

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          appBar: _buildAppBar(context, active),
          body: Column(
            children: [
              Expanded(
                child: active == null
                    ? const _EmptyState()
                    : _ChatList(
                        messages: active.messages,
                        isBotTyping: active.isBotTyping,
                        scrollController: _scrollController,
                      ),
              ),
              if (active != null && active.quickSuggestions.isNotEmpty)
                _SuggestionChips(
                  suggestions: active.quickSuggestions,
                  onTap: _tapSuggestion,
                ),
              _InputBar(
                controller: _inputController,
                hasText: _hasText,
                isTyping: active?.isBotTyping ?? false,
                onSend: _send,
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    TripPlannerActive? state,
  ) {
    return AppBar(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🗺️', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rasad AI Planner', style: AppTextStyles.headlineSmall),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    state?.isBotTyping == true ? 'Typing...' : 'Online',
                    style: AppTextStyles.caption.copyWith(
                      color: state?.isBotTyping == true
                          ? AppColors.accentGold
                          : AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (state != null && state.messages.isNotEmpty)
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () =>
                context.read<TripPlannerBloc>().add(const TripPlannerChatCleared()),
            tooltip: 'New conversation',
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _ChatList extends StatelessWidget {
  final List<ChatMessage> messages;
  final bool isBotTyping;
  final ScrollController scrollController;

  const _ChatList({
    required this.messages,
    required this.isBotTyping,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = messages.length + (isBotTyping ? 1 : 0);
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        if (i == messages.length && isBotTyping) {
          return const _TypingIndicator();
        }
        return _MessageBubble(message: messages[i]);
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  bool get _isUser => message.sender == MessageSender.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!_isUser) ...[_BotAvatar(), const SizedBox(width: 8)],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                _buildBubbleContent(),
                const SizedBox(height: 3),
                Text(
                  _formatTime(message.timestamp),
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubbleContent() {
    if (!_isUser && message.responseType == BotResponseType.plan) {
      return _PlanBubble(message: message);
    }
    return _TextBubble(message: message, isUser: _isUser);
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _BotAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: Text('🗺️', style: TextStyle(fontSize: 14))),
    );
  }
}

class _TextBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;
  const _TextBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.backgroundCard,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isUser ? 16 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 16),
        ),
        border: isUser ? null : Border.all(color: AppColors.border, width: 1),
      ),
      child: Text(
        message.text,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isUser ? AppColors.textOnPrimary : AppColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }
}

class _PlanBubble extends StatelessWidget {
  final ChatMessage message;
  const _PlanBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.82,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(16),
        ),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (message.planItems ?? [])
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(item, style: AppTextStyles.bodySmall),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          _BotAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onTap;

  const _SuggestionChips({
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => onTap(suggestions[i]),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Text(suggestions[i], style: AppTextStyles.labelMedium),
            ),
          );
        },
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final bool isTyping;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.hasText,
    required this.isTyping,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: !isTyping,
              decoration: InputDecoration(
                hintText: isTyping ? 'Rasad AI is thinking...' : 'Ask about Jordan...',
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: AppConstants.animFast,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: hasText && !isTyping
                  ? AppColors.primary
                  : AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: IconButton(
              onPressed: hasText && !isTyping ? onSend : null,
              icon: const Icon(Icons.send_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🗺️', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text('Rasad AI Planner', style: AppTextStyles.headlineMedium),
        ],
      ),
    );
  }
}

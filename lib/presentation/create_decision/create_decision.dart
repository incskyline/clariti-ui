import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emotion_chip_widget.dart';
import './widgets/voice_input_widget.dart';

class CreateDecision extends StatefulWidget {
  const CreateDecision({super.key});

  @override
  State<CreateDecision> createState() => _CreateDecisionState();
}

class _CreateDecisionState extends State<CreateDecision>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ScrollController _emotionScrollController = ScrollController();

  String _selectedEmotion = '';
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  late AnimationController _loadingAnimationController;
  late AnimationController _emotionAnimationController;
  late AnimationController _textAnimationController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _emotionAnimation;
  late Animation<double> _textAnimation;

  final int _maxCharacters = 280;

  final List<Map<String, dynamic>> _emotions = [
    {
      'name': 'Anxious',
      'icon': 'psychology',
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': 'Curious',
      'icon': 'lightbulb',
      'color': const Color(0xFF4ECDC4),
    },
    {
      'name': 'Confident',
      'icon': 'trending_up',
      'color': const Color(0xFF45B7D1),
    },
    {
      'name': 'Overwhelmed',
      'icon': 'waves',
      'color': const Color(0xFF96CEB4),
    },
    {
      'name': 'Hopeful',
      'icon': 'wb_sunny',
      'color': const Color(0xFFFECA57),
    },
    {
      'name': 'Uncertain',
      'icon': 'help',
      'color': const Color(0xFF6C5CE7),
    },
    {
      'name': 'Excited',
      'icon': 'celebration',
      'color': const Color(0xFFFF9FF3),
    },
    {
      'name': 'Worried',
      'icon': 'sentiment_worried',
      'color': const Color(0xFFA0A0A0),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _emotionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    _emotionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _emotionAnimationController,
      curve: Curves.elasticOut,
    ));

    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOut,
    ));

    _textController.addListener(_onTextChanged);

    // Start entrance animations
    _textAnimationController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _emotionAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _textFocusNode.dispose();
    _emotionScrollController.dispose();
    _loadingAnimationController.dispose();
    _emotionAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasUnsavedChanges =
          _textController.text.isNotEmpty || _selectedEmotion.isNotEmpty;
    });
  }

  void _onEmotionSelected(String emotion) {
    setState(() {
      _selectedEmotion = emotion;
      _hasUnsavedChanges = true;
    });

    // Enhanced haptic feedback
    HapticFeedback.mediumImpact();

    // Add celebratory animation for first emotion selection
    if (_emotionAnimationController.isCompleted) {
      _emotionAnimationController.reverse().then((_) {
        _emotionAnimationController.forward();
      });
    }
  }

  void _onVoiceInput(String text) {
    setState(() {
      _textController.text = text;
      _hasUnsavedChanges = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges) {
      return await _showUnsavedChangesDialog();
    }
    return true;
  }

  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Unsaved Changes',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            content: Text(
              'You have unsaved changes. Are you sure you want to leave?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _generateOutcomes() async {
    if (_textController.text.trim().isEmpty || _selectedEmotion.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _loadingAnimationController.repeat();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _loadingAnimationController.stop();

      // Navigate to decision results
      Navigator.pushNamed(context, '/decision-results');
    }
  }

  Color _getSelectedEmotionColor() {
    if (_selectedEmotion.isEmpty) return AppTheme.primaryLight;

    final emotion = _emotions.firstWhere(
      (e) => e['name'] == _selectedEmotion,
      orElse: () => _emotions[0],
    );
    return emotion['color'] as Color;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.of(context).pop();
              }
            },
            icon: CustomIconWidget(
              iconName: 'close',
              color: Theme.of(context).colorScheme.onSurface,
              size: 24,
            ),
          ),
          title: Text(
            'New Decision',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      _buildQuestionInput(),
                      SizedBox(height: 5.h),
                      _buildEmotionSelector(),
                      SizedBox(height: 5.h),
                      if (_isLoading) _buildLoadingIndicator(),
                    ],
                  ),
                ),
              ),
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionInput() {
    return AnimatedBuilder(
      animation: _textAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _textAnimation.value)),
          child: Opacity(
            opacity: _textAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'psychology',
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'What\'s on your mind?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: 18.h,
                    maxHeight: 35.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedEmotion.isNotEmpty
                          ? _getSelectedEmotionColor().withValues(alpha: 0.4)
                          : Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _selectedEmotion.isNotEmpty
                            ? _getSelectedEmotionColor().withValues(alpha: 0.1)
                            : AppTheme.shadowLight,
                        blurRadius: _selectedEmotion.isNotEmpty ? 8 : 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          focusNode: _textFocusNode,
                          maxLength: _maxCharacters,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16.sp,
                                    height: 1.6,
                                  ),
                          decoration: InputDecoration(
                            hintText: 'What if I...',
                            hintStyle:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 16.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(5.w),
                            counterText: '',
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          onChanged: (text) {
                            // Add gentle haptic feedback while typing
                            if (text.length % 10 == 0 && text.isNotEmpty) {
                              HapticFeedback.selectionClick();
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            VoiceInputWidget(
                              onVoiceInput: _onVoiceInput,
                              selectedEmotionColor: _getSelectedEmotionColor(),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.w),
                              decoration: BoxDecoration(
                                color: _textController.text.length >
                                        _maxCharacters * 0.9
                                    ? AppTheme.error.withValues(alpha: 0.1)
                                    : Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_textController.text.length}/$_maxCharacters',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: _textController.text.length >
                                              _maxCharacters * 0.9
                                          ? AppTheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmotionSelector() {
    return AnimatedBuilder(
      animation: _emotionAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _emotionAnimation.value)),
          child: Opacity(
            opacity: _emotionAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: _selectedEmotion.isNotEmpty
                            ? _getSelectedEmotionColor().withValues(alpha: 0.2)
                            : Theme.of(context).colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'sentiment_satisfied',
                        color: _selectedEmotion.isNotEmpty
                            ? _getSelectedEmotionColor()
                            : Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'How are you feeling?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    if (_selectedEmotion.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color:
                              _getSelectedEmotionColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getSelectedEmotionColor()
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          _selectedEmotion,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getSelectedEmotionColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  height: 7.h,
                  child: ListView.separated(
                    controller: _emotionScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _emotions.length,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      final emotion = _emotions[index];
                      return EmotionChipWidget(
                        emotion: emotion['name'] as String,
                        icon: emotion['icon'] as String,
                        color: emotion['color'] as Color,
                        isSelected: _selectedEmotion == emotion['name'],
                        onTap: () =>
                            _onEmotionSelected(emotion['name'] as String),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingAnimation.value * 2 * 3.14159,
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: _getSelectedEmotionColor(),
                  size: 40,
                ),
              );
            },
          ),
          SizedBox(height: 3.h),
          Text(
            'Thinking through your scenario...',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _getSelectedEmotionColor(),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    final bool isEnabled = _textController.text.trim().isNotEmpty &&
        _selectedEmotion.isNotEmpty &&
        !_isLoading;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        child: ElevatedButton(
          onPressed: isEnabled ? _generateOutcomes : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? _getSelectedEmotionColor()
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.5.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: isEnabled ? 4 : 0,
            shadowColor: isEnabled
                ? _getSelectedEmotionColor().withValues(alpha: 0.4)
                : Colors.transparent,
          ),
          child: _isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Analyzing...',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Generate Outcomes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// ParkFlex Admin Support Bot Assistant
///
/// A smart customer support chatbot for the ParkFlex parking app.
/// Provides step-by-step guidance for users on booking, payments, and troubleshooting.
class ParkFlexSupportBot {
  static const String appName = "ParkFlex";
  static const List<String> paymentMethods = [
    "MTN Mobile Money",
    "Airtel Money",
    "Visa Card",
    "Mastercard"
  ];

  static const List<String> keyScreens = [
    "Home Dashboard",
    "Find Parking",
    "Booking Screen",
    "Payment Screen",
    "Profile Screen",
    "Notifications"
  ];

  static const List<String> specialFeatures = [
    "Real-time slot availability",
    "24/7 parking booking",
    "Multiple payment options",
    "Booking history tracking",
    "Push notifications",
    "Weather integration",
    "Dark/Light mode"
  ];

  /// Main support response handler
  static String getResponse(String userMessage) {
    final message = userMessage.toLowerCase().trim();

    // Booking related queries
    if (_containsAny(message, ['book', 'booking', 'reserve', 'reservation'])) {
      return _getBookingHelp(message);
    }

    // Payment related queries
    if (_containsAny(message,
        ['pay', 'payment', 'money', 'card', 'momo', 'airtel', 'mtn'])) {
      return _getPaymentHelp(message);
    }

    // Parking slot selection
    if (_containsAny(
        message, ['slot', 'space', 'parking', 'available', 'select'])) {
      return _getParkingSlotHelp(message);
    }

    // Account and login issues
    if (_containsAny(
        message, ['login', 'account', 'register', 'sign', 'profile'])) {
      return _getAccountHelp(message);
    }

    // Notification issues
    if (_containsAny(message, ['notification', 'alert', 'reminder'])) {
      return _getNotificationHelp(message);
    }

    // History and tracking
    if (_containsAny(message, ['history', 'past', 'previous', 'track'])) {
      return _getHistoryHelp(message);
    }

    // Troubleshooting
    if (_containsAny(message,
        ['problem', 'issue', 'error', 'bug', 'not working', 'broken'])) {
      return _getTroubleshootingHelp(message);
    }

    // App navigation
    if (_containsAny(message, ['how to use', 'navigate', 'find', 'where is'])) {
      return _getNavigationHelp(message);
    }

    // General app info
    if (_containsAny(message, ['what is', 'about', 'features', 'help'])) {
      return _getGeneralInfo();
    }

    // Default response for unclear queries
    return _getDefaultResponse();
  }

  static String _getBookingHelp(String message) {
    if (_containsAny(message, ['how', 'steps'])) {
      return """
📱 **How to Book Parking:**

1. Open ParkFlex app
2. Tap "Find Parking" on home screen
3. Search or browse available locations
4. Select a parking lot with available slots
5. Choose your preferred slot
6. Enter vehicle number plate
7. Select date and time
8. Choose duration (1hr, 2hr, 3hr, or All Day)
9. Tap "Book Now"
10. Complete payment

✅ You'll get a confirmation notification!

Need help with any specific step?
      """;
    }

    if (_containsAny(message, ['cancel', 'modify', 'change'])) {
      return """
🔄 **Managing Your Booking:**

**To Cancel:**
1. Go to "Reserve" tab
2. Find your booking
3. Tap on it
4. Select "Cancel Booking"

**To Modify:**
- You can extend duration during active parking
- Contact support for other changes

**Refund Policy:**
- Cancel 1+ hours before: Full refund
- Cancel within 1 hour: 50% refund
- No-show: No refund

Need more help?
      """;
    }

    return """
🅿️ **Booking Help:**

I can help you with:
• Step-by-step booking guide
• Canceling or modifying bookings  
• Choosing the right parking duration
• Understanding booking status

What specifically do you need help with?
    """;
  }

  static String _getPaymentHelp(String message) {
    if (_containsAny(message, ['methods', 'options', 'how to pay'])) {
      return """
💳 **Payment Methods Available:**

1. **MTN Mobile Money**
   - Enter your MTN number
   - Confirm with PIN

2. **Airtel Money**
   - Enter your Airtel number  
   - Confirm with PIN

3. **Visa Card**
   - Enter card details
   - Secure 3D verification

4. **Mastercard**
   - Enter card details
   - Secure 3D verification

💡 **Payment Steps:**
1. After selecting parking slot
2. Tap "Proceed to Payment"
3. Choose payment method
4. Enter required details
5. Confirm payment

All payments are secure and encrypted! 🔒
      """;
    }

    if (_containsAny(message, ['failed', 'error', 'problem', 'not working'])) {
      return """
❌ **Payment Issues? Try This:**

1. **Check Internet Connection**
   - Ensure stable internet

2. **Verify Payment Details**
   - Correct phone number for MoMo
   - Valid card details for cards

3. **Check Account Balance**
   - Sufficient funds in account

4. **Try Different Method**
   - Switch to another payment option

5. **Restart App**
   - Close and reopen ParkFlex

Still having issues? Contact support with error details.
      """;
    }

    return """
💰 **Payment Help:**

Available payment methods:
• MTN Mobile Money
• Airtel Money  
• Visa Card
• Mastercard

What payment issue can I help you with?
    """;
  }

  static String _getParkingSlotHelp(String message) {
    return """
🅿️ **Selecting Parking Slots:**

1. **Browse Available Locations**
   - Use search bar or browse list
   - Check availability (green = available)

2. **Choose Your Spot**
   - Slots shown in real-time
   - Price displayed per hour
   - Distance from entrance

3. **Slot Information**
   - 🟢 Available slots
   - 🔴 Occupied slots  
   - 🟡 Reserved slots

4. **Smart Selection Tips**
   - Book popular locations early
   - Check weather for outdoor spots
   - Consider walking distance

**Current Locations:**
• Acacia Mall Parking
• Garden City Parking
• Kampala Road Parking
• And more!

Need help finding a specific location?
    """;
  }

  static String _getAccountHelp(String message) {
    if (_containsAny(message, ['create', 'register', 'sign up'])) {
      return """
👤 **Creating Your Account:**

1. Open ParkFlex app
2. Tap "Sign Up"
3. Enter your details:
   - Full name
   - Email address
   - Phone number
   - Password
4. Verify phone number (SMS code)
5. Complete profile setup

**Login Issues?**
1. Tap "Forgot Password"
2. Enter your email
3. Check email for reset link
4. Create new password

**Profile Management:**
- Go to Profile tab
- Update personal info
- Change password
- Manage notifications

Need help with a specific account issue?
      """;
    }

    return """
👤 **Account Help:**

I can help you with:
• Creating new account
• Login problems
• Password reset
• Profile updates
• Account verification

What account issue do you have?
    """;
  }

  static String _getNotificationHelp(String message) {
    return """
🔔 **Notification Settings:**

**Enable Notifications:**
1. Go to Profile → Settings
2. Tap "Notifications"
3. Enable desired alerts:
   - Booking confirmations
   - Payment receipts
   - Parking reminders
   - Expiry warnings

**Notification Types:**
• 📅 Booking confirmations
• 💳 Payment receipts
• ⏰ Parking time reminders
• ⚠️ Expiry warnings
• 🎉 Special offers

**Troubleshooting:**
- Check phone notification settings
- Ensure app permissions enabled
- Update app to latest version

**View Notifications:**
- Tap bell icon on home screen
- Mark as read or delete
- Clear all notifications

Need help with specific notification issues?
    """;
  }

  static String _getHistoryHelp(String message) {
    return """
📋 **Booking History:**

**View Your History:**
1. Go to "Reserve" tab
2. Scroll to "History" section
3. See all past bookings

**History Details Include:**
• Parking location
• Date and time
• Duration parked
• Amount paid
• Payment status
• Booking ID

**Filter Options:**
- By date range
- By location
- By payment status

**Download Receipts:**
- Tap any completed booking
- Select "Download Receipt"
- PDF saved to your device

**Export History:**
- Go to Profile → Settings
- Tap "Export Data"
- Choose date range

Need help finding a specific booking?
    """;
  }

  static String _getTroubleshootingHelp(String message) {
    if (_containsAny(message, ['app', 'crash', 'slow', 'loading'])) {
      return """
🔧 **App Issues? Try These Steps:**

**App Crashes/Freezes:**
1. Force close app completely
2. Restart your phone
3. Update app from store
4. Clear app cache
5. Reinstall if needed

**Slow Loading:**
1. Check internet connection
2. Close other apps
3. Restart app
4. Update to latest version

**Login Problems:**
1. Check email/password
2. Reset password if needed
3. Clear app data
4. Try different network

**Booking Issues:**
1. Refresh parking list
2. Check payment method
3. Verify account details
4. Contact support

Still having problems? Share error details with support.
      """;
    }

    return """
🛠️ **Common Issues & Solutions:**

**Can't Find Parking:**
- Refresh the parking list
- Try different time/date
- Check nearby locations

**Payment Failed:**
- Verify payment details
- Check account balance
- Try different method

**App Not Working:**
- Update to latest version
- Restart your device
- Check internet connection

**Booking Disappeared:**
- Check "Reserve" tab
- Look in History section
- Contact support with booking ID

What specific problem are you experiencing?
    """;
  }

  static String _getNavigationHelp(String message) {
    return """
🧭 **App Navigation Guide:**

**Main Screens:**
1. **Home Dashboard**
   - Quick parking search
   - Weather info
   - Recent locations

2. **Find Parking Tab**
   - Browse all locations
   - Real-time availability
   - Filter and search

3. **Reserve Tab**
   - Active bookings
   - Upcoming reservations
   - Booking history

4. **Payment Tab**
   - Payment methods
   - Transaction history
   - Receipts

5. **Profile Tab**
   - Account settings
   - Preferences
   - Support

**Quick Actions:**
- 🔍 Search: Top of parking screen
- 🔔 Notifications: Bell icon
- ⚙️ Settings: Profile → Settings
- 📱 Dark Mode: Settings toggle

**Navigation Tips:**
- Swipe between tabs
- Pull down to refresh
- Use back button to return

Where do you need help navigating?
    """;
  }

  static String _getGeneralInfo() {
    return """
🅿️ **Welcome to ParkFlex!**

**What is ParkFlex?**
Smart parking solution for Uganda. Find, book, and pay for parking spots easily.

**Key Features:**
• 🔍 Real-time slot availability
• 📱 24/7 booking system
• 💳 Multiple payment options
• 📊 Booking history tracking
• 🔔 Smart notifications
• 🌤️ Weather integration
• 🌙 Dark/Light mode

**Payment Methods:**
• MTN Mobile Money
• Airtel Money
• Visa & Mastercard

**Popular Locations:**
• Acacia Mall, Kololo
• Garden City, Kira Road
• Kampala Road Central
• And many more!

**Need Help With:**
• Booking parking
• Making payments
• Account issues
• App navigation

How can I assist you today?
    """;
  }

  static String _getDefaultResponse() {
    return """
🤖 **ParkFlex Support Assistant**

I'm here to help you with ParkFlex! Try asking me:

**📱 Booking Questions:**
• "How do I book parking?"
• "How to select a parking slot?"
• "Can I cancel my booking?"

**💳 Payment Questions:**
• "What payment methods do you accept?"
• "My payment failed, what should I do?"
• "How do I pay for parking?"

**🔧 Common Issues:**
• "App is not working"
• "I can't find parking slots"
• "How do I reset my password?"

**📍 App Help:**
• "How to use the app?"
• "Where is my booking history?"
• "How do notifications work?"

**Quick Examples:**
Just type: "book parking" or "payment help" or "app problems"

What would you like help with? 😊
    """;
  }

  /// Helper method to check if message contains any of the keywords
  static bool _containsAny(String message, List<String> keywords) {
    for (String keyword in keywords) {
      if (message.contains(keyword.toLowerCase())) {
        print('🎯 Matched keyword: "$keyword" in message: "$message"');
        return true;
      }
    }
    return false;
  }

  /// Get contextual help based on current screen
  static String getContextualHelp(String currentScreen) {
    switch (currentScreen.toLowerCase()) {
      case 'booking':
        return """
📱 **Booking Screen Help:**

**Current Step:** Complete your booking

1. ✅ Verify parking location
2. ✅ Enter vehicle plate number
3. ✅ Select date and time  
4. ✅ Choose duration
5. 👉 Tap "Book Now" to proceed

**Need to Change Something?**
- Tap back to modify details
- All fields can be updated

Ready to complete your booking?
        """;

      case 'payment':
        return """
💳 **Payment Screen Help:**

**Available Methods:**
• MTN Mobile Money
• Airtel Money
• Visa Card
• Mastercard

**Steps:**
1. Select payment method
2. Enter required details
3. Confirm payment
4. Wait for confirmation

**Security:** All payments are encrypted and secure 🔒

Having payment issues? Let me know!
        """;

      case 'dashboard':
        return """
🏠 **Dashboard Help:**

**Quick Actions:**
• Search parking locations
• View weather info
• Check notifications
• Access recent bookings

**Navigation:**
- Swipe between tabs
- Use search bar to find locations
- Tap weather widget for details

**Tabs Available:**
• Parking: Find and book
• Reserve: Manage bookings  
• Payment: Transaction history
• Profile: Account settings

What would you like to do?
        """;

      default:
        return _getDefaultResponse();
    }
  }

  /// Smart response with follow-up questions
  static Map<String, dynamic> getSmartResponse(String userMessage,
      {String? context}) {
    final response = getResponse(userMessage);
    final followUpQuestions = _generateFollowUpQuestions(userMessage);

    return {
      'response': response,
      'followUpQuestions': followUpQuestions,
      'quickActions': _getQuickActions(userMessage),
      'relatedHelp': _getRelatedHelp(userMessage),
    };
  }

  static List<String> _generateFollowUpQuestions(String message) {
    final msg = message.toLowerCase();

    if (_containsAny(msg, ['book', 'booking'])) {
      return [
        "Need help selecting a parking location?",
        "Having trouble with payment?",
        "Want to know about cancellation policy?"
      ];
    }

    if (_containsAny(msg, ['payment', 'pay'])) {
      return [
        "Which payment method are you using?",
        "Getting a specific error message?",
        "Need help with mobile money?"
      ];
    }

    if (_containsAny(msg, ['problem', 'issue', 'error'])) {
      return [
        "What error message do you see?",
        "When did this problem start?",
        "Have you tried restarting the app?"
      ];
    }

    return [
      "Is there anything else I can help you with?",
      "Do you need more detailed steps?",
      "Would you like me to explain any specific feature?"
    ];
  }

  static List<String> _getQuickActions(String message) {
    final msg = message.toLowerCase();

    if (_containsAny(msg, ['book', 'booking'])) {
      return ["📱 Start Booking", "📍 Find Locations", "💳 Payment Help"];
    }

    if (_containsAny(msg, ['payment'])) {
      return [
        "💳 Payment Methods",
        "📊 Transaction History",
        "🔧 Fix Payment Issue"
      ];
    }

    return ["🏠 Go to Dashboard", "📞 Contact Support", "❓ More Help"];
  }

  static List<String> _getRelatedHelp(String message) {
    final msg = message.toLowerCase();

    if (_containsAny(msg, ['book', 'booking'])) {
      return [
        "How to select parking slots",
        "Payment methods guide",
        "Booking cancellation policy"
      ];
    }

    if (_containsAny(msg, ['payment'])) {
      return [
        "Mobile money setup",
        "Card payment security",
        "Transaction history"
      ];
    }

    return [
      "App navigation guide",
      "Account management",
      "Troubleshooting tips"
    ];
  }
}

/// Widget implementation for the support bot UI
class SupportBotWidget extends StatefulWidget {
  final String? currentScreen;

  const SupportBotWidget({super.key, this.currentScreen});

  @override
  State<SupportBotWidget> createState() => _SupportBotWidgetState();
}

class _SupportBotWidgetState extends State<SupportBotWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addBotMessage(ParkFlexSupportBot._getDefaultResponse());
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add({
        'text': message,
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _addUserMessage(message);
    _messageController.clear();

    // Get bot response
    final response = ParkFlexSupportBot.getResponse(message);

    // Simulate typing delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.support_agent,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ParkFlex Support',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online now',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, theme);
              },
            ),
          ),
          _buildMessageInput(theme),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, ThemeData theme) {
    final isUser = message['isUser'] as bool;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message['text'],
          style: TextStyle(
            color: isUser ? Colors.white : theme.colorScheme.onSurface,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

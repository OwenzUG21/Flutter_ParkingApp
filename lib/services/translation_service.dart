import 'package:flutter/material.dart';
import 'language_service.dart';

class TranslationService {
  static final Map<String, Map<String, String>> _translations = {
    'en': {
      // App General
      'app_name': 'ParkFlex',
      'welcome': 'Welcome',
      'continue': 'Continue',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'done': 'Done',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',

      // Authentication
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'create_account': 'Create Account',
      'already_have_account': 'Already have an account?',
      'dont_have_account': "Don't have an account?",

      // Navigation
      'home': 'Home',
      'search': 'Search',
      'bookings': 'Bookings',
      'profile': 'Profile',
      'settings': 'Settings',

      // Parking
      'find_parking': 'Find Parking',
      'book_now': 'Book Now',
      'parking_spots': 'Parking Spots',
      'available': 'Available',
      'occupied': 'Occupied',
      'reserved': 'Reserved',

      // Settings
      'language': 'Language',
      'select_language': 'Select Language',
      'theme': 'Theme',
      'notifications': 'Notifications',
      'about': 'About',
      'logout': 'Logout',

      // Tabs and Navigation
      'community': 'Community',
      'parking': 'Parking',
      'reserve': 'Reserve',
      'payment': 'Payment',
      'reserves': 'Reserves',

      // Drawer Items
      'dark_mode': 'Dark Mode',
      'logout': 'Logout',

      // Parking Details
      'select_parking_slot': 'Select Your Parking Slot',
      'tap_available_slot': 'Tap on an available slot to proceed with booking',
      'price': 'Price',
      'per_hour': 'per hour',
      'capacity': 'Capacity',
      'total_slots': 'total slots',
      'occupancy': 'Occupancy',
      'occupied_subtitle': 'occupied',
      'available_slots': 'Available',
      'limited': 'Limited',
      'almost_full': 'Almost Full',
      'selected': 'Selected',

      // Search and Filters
      'search_parking_locations': 'Search parking locations...',
      'current_location': 'Current Location',
      'no_parking_found': 'No parking locations found',
      'try_different_search': 'Try a different search term',
      'favorites': 'Favorites',

      // Booking Status
      'active_sessions': 'Active Sessions',
      'active': 'Active',
      'upcoming': 'Upcoming',
      'history': 'History',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'pending': 'Pending',
      'paid': 'Paid',
      'unpaid': 'Unpaid',
      'pay_now': 'Pay Now',
      'confirm_pay': 'Confirm & Pay',

      // Onboarding
      'onboarding_title_1': 'Find Parking Easily',
      'onboarding_desc_1':
          'Discover available parking spots near you with real-time updates',
      'onboarding_title_2': 'Easy Booking',
      'onboarding_desc_2': 'Book your parking spot in advance and save time',
      'onboarding_title_3': 'Safe & Secure',
      'onboarding_desc_3':
          'Your vehicle is safe with our verified parking partners',
      'get_started': 'Get Started',
      'skip': 'Skip',
    },
    'sw': {
      // App General
      'app_name': 'ParkFlex',
      'welcome': 'Karibu',
      'continue': 'Endelea',
      'cancel': 'Ghairi',
      'save': 'Hifadhi',
      'delete': 'Futa',
      'edit': 'Hariri',
      'done': 'Imekwisha',
      'loading': 'Inapakia...',
      'error': 'Hitilafu',
      'success': 'Mafanikio',
      'ok': 'Sawa',
      'yes': 'Ndiyo',
      'no': 'Hapana',

      // Authentication
      'login': 'Ingia',
      'signup': 'Jisajili',
      'email': 'Barua pepe',
      'password': 'Nenosiri',
      'confirm_password': 'Thibitisha Nenosiri',
      'forgot_password': 'Umesahau nenosiri?',
      'create_account': 'Unda Akaunti',
      'already_have_account': 'Una akaunti tayari?',
      'dont_have_account': 'Huna akaunti?',

      // Navigation
      'home': 'Nyumbani',
      'search': 'Tafuta',
      'bookings': 'Mahifadhi',
      'profile': 'Wasifu',
      'settings': 'Mipangilio',

      // Parking
      'find_parking': 'Tafuta Maegesho',
      'book_now': 'Hifadhi Sasa',
      'parking_spots': 'Maegesho ya Magari',
      'available': 'Inapatikana',
      'occupied': 'Imechukuliwa',
      'reserved': 'Imehifadhiwa',

      // Settings
      'language': 'Lugha',
      'select_language': 'Chagua Lugha',
      'theme': 'Mandhari',
      'notifications': 'Arifa',
      'about': 'Kuhusu',
      'logout': 'Toka',

      // Tabs and Navigation
      'community': 'Jamii',
      'parking': 'Maegesho',
      'reserve': 'Hifadhi',
      'payment': 'Malipo',
      'reserves': 'Mahifadhi',

      // Drawer Items
      'dark_mode': 'Hali ya Giza',
      'logout': 'Toka',

      // Parking Details
      'select_parking_slot': 'Chagua Nafasi Yako ya Kuegesha',
      'tap_available_slot': 'Gusa nafasi iliyopo ili uendelee na uhifadhi',
      'price': 'Bei',
      'per_hour': 'kwa saa',
      'capacity': 'Uwezo',
      'total_slots': 'nafasi zote',
      'occupancy': 'Utumiaji',
      'occupied_subtitle': 'imechukuliwa',
      'available_slots': 'Inapatikana',
      'limited': 'Mdogo',
      'almost_full': 'Karibu Kujaa',
      'selected': 'Imechaguliwa',

      // Search and Filters
      'search_parking_locations': 'Tafuta maegesho...',
      'current_location': 'Mahali Ulipo',
      'no_parking_found': 'Hakuna maegesho yaliyopatikana',
      'try_different_search': 'Jaribu neno lingine la utafutaji',
      'favorites': 'Vipendwa',

      // Booking Status
      'active_sessions': 'Vipindi Vya Sasa',
      'active': 'Hai',
      'upcoming': 'Zinazokuja',
      'history': 'Historia',
      'completed': 'Imekamilika',
      'cancelled': 'Imeghairiwa',
      'pending': 'Inasubiri',
      'paid': 'Imelipwa',
      'unpaid': 'Haijalipiwa',
      'pay_now': 'Lipa Sasa',
      'confirm_pay': 'Thibitisha na Lipa',

      // Onboarding
      'onboarding_title_1': 'Tafuta Maegesho Kwa Urahisi',
      'onboarding_desc_1':
          'Gundua maegesho yaliyopo karibu nawe kwa masasisho ya wakati halisi',
      'onboarding_title_2': 'Uhifadhi Rahisi',
      'onboarding_desc_2':
          'Hifadhi nafasi yako ya kuegesha mapema na uokoe muda',
      'onboarding_title_3': 'Salama na Imara',
      'onboarding_desc_3':
          'Gari lako ni salama na washirika wetu wa kuegesha walioidhinishwa',
      'get_started': 'Anza',
      'skip': 'Ruka',
    },
    'fr': {
      // App General
      'app_name': 'ParkFlex',
      'welcome': 'Bienvenue',
      'continue': 'Continuer',
      'cancel': 'Annuler',
      'save': 'Sauvegarder',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'done': 'Terminé',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'ok': 'OK',
      'yes': 'Oui',
      'no': 'Non',

      // Authentication
      'login': 'Connexion',
      'signup': "S'inscrire",
      'email': 'Email',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'forgot_password': 'Mot de passe oublié?',
      'create_account': 'Créer un compte',
      'already_have_account': 'Vous avez déjà un compte?',
      'dont_have_account': "Vous n'avez pas de compte?",

      // Navigation
      'home': 'Accueil',
      'search': 'Rechercher',
      'bookings': 'Réservations',
      'profile': 'Profil',
      'settings': 'Paramètres',

      // Parking
      'find_parking': 'Trouver un parking',
      'book_now': 'Réserver maintenant',
      'parking_spots': 'Places de parking',
      'available': 'Disponible',
      'occupied': 'Occupé',
      'reserved': 'Réservé',

      // Settings
      'language': 'Langue',
      'select_language': 'Sélectionner la langue',
      'theme': 'Thème',
      'notifications': 'Notifications',
      'about': 'À propos',
      'logout': 'Déconnexion',

      // Tabs and Navigation
      'community': 'Communauté',
      'parking': 'Parking',
      'reserve': 'Réserver',
      'payment': 'Paiement',
      'reserves': 'Réserves',

      // Drawer Items
      'dark_mode': 'Mode Sombre',
      'logout': 'Déconnexion',

      // Parking Details
      'select_parking_slot': 'Sélectionnez votre place de parking',
      'tap_available_slot':
          'Appuyez sur une place disponible pour procéder à la réservation',
      'price': 'Prix',
      'per_hour': 'par heure',
      'capacity': 'Capacité',
      'total_slots': 'places totales',
      'occupancy': 'Occupation',
      'occupied_subtitle': 'occupé',
      'available_slots': 'Disponible',
      'limited': 'Limité',
      'almost_full': 'Presque Plein',
      'selected': 'Sélectionné',

      // Search and Filters
      'search_parking_locations': 'Rechercher des parkings...',
      'current_location': 'Position Actuelle',
      'no_parking_found': 'Aucun parking trouvé',
      'try_different_search': 'Essayez un autre terme de recherche',
      'favorites': 'Favoris',

      // Booking Status
      'active_sessions': 'Sessions Actives',
      'active': 'Actif',
      'upcoming': 'À Venir',
      'history': 'Historique',
      'completed': 'Terminé',
      'cancelled': 'Annulé',
      'pending': 'En Attente',
      'paid': 'Payé',
      'unpaid': 'Non Payé',
      'pay_now': 'Payer Maintenant',
      'confirm_pay': 'Confirmer et Payer',

      // Onboarding
      'onboarding_title_1': 'Trouvez facilement un parking',
      'onboarding_desc_1':
          'Découvrez les places de parking disponibles près de vous avec des mises à jour en temps réel',
      'onboarding_title_2': 'Réservation facile',
      'onboarding_desc_2':
          'Réservez votre place de parking à l\'avance et gagnez du temps',
      'onboarding_title_3': 'Sûr et sécurisé',
      'onboarding_desc_3':
          'Votre véhicule est en sécurité avec nos partenaires de parking vérifiés',
      'get_started': 'Commencer',
      'skip': 'Passer',
    },
    'es': {
      // App General
      'app_name': 'ParkFlex',
      'welcome': 'Bienvenido',
      'continue': 'Continuar',
      'cancel': 'Cancelar',
      'save': 'Guardar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'done': 'Hecho',
      'loading': 'Cargando...',
      'error': 'Error',
      'success': 'Éxito',
      'ok': 'OK',
      'yes': 'Sí',
      'no': 'No',

      // Authentication
      'login': 'Iniciar sesión',
      'signup': 'Registrarse',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'confirm_password': 'Confirmar contraseña',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'create_account': 'Crear cuenta',
      'already_have_account': '¿Ya tienes una cuenta?',
      'dont_have_account': '¿No tienes una cuenta?',

      // Navigation
      'home': 'Inicio',
      'search': 'Buscar',
      'bookings': 'Reservas',
      'profile': 'Perfil',
      'settings': 'Configuración',

      // Parking
      'find_parking': 'Encontrar estacionamiento',
      'book_now': 'Reservar ahora',
      'parking_spots': 'Espacios de estacionamiento',
      'available': 'Disponible',
      'occupied': 'Ocupado',
      'reserved': 'Reservado',

      // Settings
      'language': 'Idioma',
      'select_language': 'Seleccionar idioma',
      'theme': 'Tema',
      'notifications': 'Notificaciones',
      'about': 'Acerca de',
      'logout': 'Cerrar sesión',

      // Tabs and Navigation
      'community': 'Comunidad',
      'parking': 'Estacionamiento',
      'reserve': 'Reservar',
      'payment': 'Pago',
      'reserves': 'Reservas',

      // Drawer Items
      'dark_mode': 'Modo Oscuro',
      'logout': 'Cerrar Sesión',

      // Parking Details
      'select_parking_slot': 'Selecciona tu espacio de estacionamiento',
      'tap_available_slot':
          'Toca un espacio disponible para proceder con la reserva',
      'price': 'Precio',
      'per_hour': 'por hora',
      'capacity': 'Capacidad',
      'total_slots': 'espacios totales',
      'occupancy': 'Ocupación',
      'occupied_subtitle': 'ocupado',
      'available_slots': 'Disponible',
      'limited': 'Limitado',
      'almost_full': 'Casi Lleno',
      'selected': 'Seleccionado',

      // Search and Filters
      'search_parking_locations': 'Buscar estacionamientos...',
      'current_location': 'Ubicación Actual',
      'no_parking_found': 'No se encontraron estacionamientos',
      'try_different_search': 'Prueba con otro término de búsqueda',
      'favorites': 'Favoritos',

      // Booking Status
      'active_sessions': 'Sesiones Activas',
      'active': 'Activo',
      'upcoming': 'Próximas',
      'history': 'Historial',
      'completed': 'Completado',
      'cancelled': 'Cancelado',
      'pending': 'Pendiente',
      'paid': 'Pagado',
      'unpaid': 'Sin Pagar',
      'pay_now': 'Pagar Ahora',
      'confirm_pay': 'Confirmar y Pagar',

      // Onboarding
      'onboarding_title_1': 'Encuentra estacionamiento fácilmente',
      'onboarding_desc_1':
          'Descubre espacios de estacionamiento disponibles cerca de ti con actualizaciones en tiempo real',
      'onboarding_title_2': 'Reserva fácil',
      'onboarding_desc_2':
          'Reserva tu espacio de estacionamiento con anticipación y ahorra tiempo',
      'onboarding_title_3': 'Seguro y protegido',
      'onboarding_desc_3':
          'Tu vehículo está seguro con nuestros socios de estacionamiento verificados',
      'get_started': 'Comenzar',
      'skip': 'Saltar',
    },
    'ar': {
      // App General
      'app_name': 'بارك فليكس',
      'welcome': 'مرحباً',
      'continue': 'متابعة',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'done': 'تم',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'success': 'نجح',
      'ok': 'موافق',
      'yes': 'نعم',
      'no': 'لا',

      // Authentication
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'create_account': 'إنشاء حساب',
      'already_have_account': 'لديك حساب بالفعل؟',
      'dont_have_account': 'ليس لديك حساب؟',

      // Navigation
      'home': 'الرئيسية',
      'search': 'بحث',
      'bookings': 'الحجوزات',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',

      // Parking
      'find_parking': 'العثور على موقف',
      'book_now': 'احجز الآن',
      'parking_spots': 'أماكن الوقوف',
      'available': 'متاح',
      'occupied': 'مشغول',
      'reserved': 'محجوز',

      // Settings
      'language': 'اللغة',
      'select_language': 'اختر اللغة',
      'theme': 'المظهر',
      'notifications': 'الإشعارات',
      'about': 'حول',
      'logout': 'تسجيل الخروج',

      // Tabs and Navigation
      'community': 'المجتمع',
      'parking': 'الوقوف',
      'reserve': 'حجز',
      'payment': 'الدفع',
      'reserves': 'الحجوزات',

      // Drawer Items
      'dark_mode': 'الوضع المظلم',
      'logout': 'تسجيل الخروج',

      // Parking Details
      'select_parking_slot': 'اختر مكان الوقوف الخاص بك',
      'tap_available_slot': 'اضغط على مكان متاح للمتابعة مع الحجز',
      'price': 'السعر',
      'per_hour': 'في الساعة',
      'capacity': 'السعة',
      'total_slots': 'إجمالي الأماكن',
      'occupancy': 'الإشغال',
      'occupied_subtitle': 'مشغول',
      'available_slots': 'متاح',
      'limited': 'محدود',
      'almost_full': 'شبه ممتلئ',
      'selected': 'محدد',

      // Search and Filters
      'search_parking_locations': 'البحث عن مواقف...',
      'current_location': 'الموقع الحالي',
      'no_parking_found': 'لم يتم العثور على مواقف',
      'try_different_search': 'جرب مصطلح بحث مختلف',
      'favorites': 'المفضلة',

      // Booking Status
      'active_sessions': 'الجلسات النشطة',
      'active': 'نشط',
      'upcoming': 'قادمة',
      'history': 'التاريخ',
      'completed': 'مكتمل',
      'cancelled': 'ملغي',
      'pending': 'معلق',
      'paid': 'مدفوع',
      'unpaid': 'غير مدفوع',
      'pay_now': 'ادفع الآن',
      'confirm_pay': 'تأكيد والدفع',

      // Onboarding
      'onboarding_title_1': 'اعثر على موقف بسهولة',
      'onboarding_desc_1':
          'اكتشف أماكن الوقوف المتاحة بالقرب منك مع التحديثات الفورية',
      'onboarding_title_2': 'حجز سهل',
      'onboarding_desc_2': 'احجز مكان الوقوف مسبقاً ووفر الوقت',
      'onboarding_title_3': 'آمن ومحمي',
      'onboarding_desc_3': 'مركبتك آمنة مع شركائنا المعتمدين للوقوف',
      'get_started': 'ابدأ',
      'skip': 'تخطي',
    },
    'zh': {
      // App General
      'app_name': 'ParkFlex',
      'welcome': '欢迎',
      'continue': '继续',
      'cancel': '取消',
      'save': '保存',
      'delete': '删除',
      'edit': '编辑',
      'done': '完成',
      'loading': '加载中...',
      'error': '错误',
      'success': '成功',
      'ok': '确定',
      'yes': '是',
      'no': '否',

      // Authentication
      'login': '登录',
      'signup': '注册',
      'email': '邮箱',
      'password': '密码',
      'confirm_password': '确认密码',
      'forgot_password': '忘记密码？',
      'create_account': '创建账户',
      'already_have_account': '已有账户？',
      'dont_have_account': '没有账户？',

      // Navigation
      'home': '首页',
      'search': '搜索',
      'bookings': '预订',
      'profile': '个人资料',
      'settings': '设置',

      // Parking
      'find_parking': '寻找停车位',
      'book_now': '立即预订',
      'parking_spots': '停车位',
      'available': '可用',
      'occupied': '已占用',
      'reserved': '已预订',

      // Settings
      'language': '语言',
      'select_language': '选择语言',
      'theme': '主题',
      'notifications': '通知',
      'about': '关于',
      'logout': '退出',

      // Tabs and Navigation
      'community': '社区',
      'parking': '停车',
      'reserve': '预订',
      'payment': '支付',
      'reserves': '预订记录',

      // Drawer Items
      'dark_mode': '深色模式',
      'logout': '退出',

      // Parking Details
      'select_parking_slot': '选择您的停车位',
      'tap_available_slot': '点击可用停车位以继续预订',
      'price': '价格',
      'per_hour': '每小时',
      'capacity': '容量',
      'total_slots': '总停车位',
      'occupancy': '占用率',
      'occupied_subtitle': '已占用',
      'available_slots': '可用',
      'limited': '有限',
      'almost_full': '几乎满了',
      'selected': '已选择',

      // Search and Filters
      'search_parking_locations': '搜索停车位...',
      'current_location': '当前位置',
      'no_parking_found': '未找到停车位',
      'try_different_search': '尝试不同的搜索词',
      'favorites': '收藏',

      // Booking Status
      'active_sessions': '活跃会话',
      'active': '活跃',
      'upcoming': '即将到来',
      'history': '历史',
      'completed': '已完成',
      'cancelled': '已取消',
      'pending': '待处理',
      'paid': '已付款',
      'unpaid': '未付款',
      'pay_now': '立即支付',
      'confirm_pay': '确认并支付',

      // Onboarding
      'onboarding_title_1': '轻松找到停车位',
      'onboarding_desc_1': '实时发现您附近的可用停车位',
      'onboarding_title_2': '轻松预订',
      'onboarding_desc_2': '提前预订停车位，节省时间',
      'onboarding_title_3': '安全可靠',
      'onboarding_desc_3': '您的车辆在我们认证的停车合作伙伴那里很安全',
      'get_started': '开始',
      'skip': '跳过',
    },
    'de': {
      // App General
      'app_name': 'ParkFlex',
      'welcome': 'Willkommen',
      'continue': 'Weiter',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'delete': 'Löschen',
      'edit': 'Bearbeiten',
      'done': 'Fertig',
      'loading': 'Lädt...',
      'error': 'Fehler',
      'success': 'Erfolg',
      'ok': 'OK',
      'yes': 'Ja',
      'no': 'Nein',

      // Authentication
      'login': 'Anmelden',
      'signup': 'Registrieren',
      'email': 'E-Mail',
      'password': 'Passwort',
      'confirm_password': 'Passwort bestätigen',
      'forgot_password': 'Passwort vergessen?',
      'create_account': 'Konto erstellen',
      'already_have_account': 'Haben Sie bereits ein Konto?',
      'dont_have_account': 'Haben Sie kein Konto?',

      // Navigation
      'home': 'Startseite',
      'search': 'Suchen',
      'bookings': 'Buchungen',
      'profile': 'Profil',
      'settings': 'Einstellungen',

      // Parking
      'find_parking': 'Parkplatz finden',
      'book_now': 'Jetzt buchen',
      'parking_spots': 'Parkplätze',
      'available': 'Verfügbar',
      'occupied': 'Belegt',
      'reserved': 'Reserviert',

      // Settings
      'language': 'Sprache',
      'select_language': 'Sprache auswählen',
      'theme': 'Design',
      'notifications': 'Benachrichtigungen',
      'about': 'Über',
      'logout': 'Abmelden',

      // Tabs and Navigation
      'community': 'Gemeinschaft',
      'parking': 'Parken',
      'reserve': 'Reservieren',
      'payment': 'Zahlung',
      'reserves': 'Reservierungen',

      // Drawer Items
      'dark_mode': 'Dunkler Modus',
      'logout': 'Abmelden',

      // Parking Details
      'select_parking_slot': 'Wählen Sie Ihren Parkplatz',
      'tap_available_slot':
          'Tippen Sie auf einen verfügbaren Platz, um mit der Buchung fortzufahren',
      'price': 'Preis',
      'per_hour': 'pro Stunde',
      'capacity': 'Kapazität',
      'total_slots': 'Gesamtplätze',
      'occupancy': 'Belegung',
      'occupied_subtitle': 'belegt',
      'available_slots': 'Verfügbar',
      'limited': 'Begrenzt',
      'almost_full': 'Fast Voll',
      'selected': 'Ausgewählt',

      // Search and Filters
      'search_parking_locations': 'Parkplätze suchen...',
      'current_location': 'Aktueller Standort',
      'no_parking_found': 'Keine Parkplätze gefunden',
      'try_different_search': 'Versuchen Sie einen anderen Suchbegriff',
      'favorites': 'Favoriten',

      // Booking Status
      'active_sessions': 'Aktive Sitzungen',
      'active': 'Aktiv',
      'upcoming': 'Bevorstehend',
      'history': 'Verlauf',
      'completed': 'Abgeschlossen',
      'cancelled': 'Storniert',
      'pending': 'Ausstehend',
      'paid': 'Bezahlt',
      'unpaid': 'Unbezahlt',
      'pay_now': 'Jetzt Bezahlen',
      'confirm_pay': 'Bestätigen & Bezahlen',

      // Onboarding
      'onboarding_title_1': 'Parkplatz einfach finden',
      'onboarding_desc_1':
          'Entdecken Sie verfügbare Parkplätze in Ihrer Nähe mit Echtzeit-Updates',
      'onboarding_title_2': 'Einfache Buchung',
      'onboarding_desc_2':
          'Buchen Sie Ihren Parkplatz im Voraus und sparen Sie Zeit',
      'onboarding_title_3': 'Sicher und geschützt',
      'onboarding_desc_3':
          'Ihr Fahrzeug ist sicher bei unseren verifizierten Parkpartnern',
      'get_started': 'Loslegen',
      'skip': 'Überspringen',
    },
  };

  static String translate(String key, String languageCode) {
    final translations = _translations[languageCode] ?? _translations['en']!;
    return translations[key] ?? key;
  }

  static List<Locale> get supportedLocales {
    return _translations.keys.map((code) => Locale(code)).toList();
  }
}

// Extension to make translation easier to use
extension StringTranslation on String {
  String tr(BuildContext context) {
    final languageService = LanguageService();
    return TranslationService.translate(this, languageService.languageCode);
  }
}

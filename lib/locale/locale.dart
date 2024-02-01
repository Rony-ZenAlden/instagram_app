import 'package:get/get.dart';

class MyLocale implements Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'ar' : {
      '1': 'عربي',
      '2': 'انكليزي',
      'login': 'تسجيل دخول',
      'forgotPassword': 'نسيت كلمة المرور',
      'enterEmail': 'أدخل الايميل',
      'enterPassword': 'أدخل كلمة السر',
      'do not have': 'لا تملك حساب؟',
      'Sign in': 'أنشاء حساب',
      'Already have an': 'هل لديك حساب؟',
      'enterFullName': 'أدخل الاسم الكامل',
      'enterBio': 'أدخل السيرة الذاتية',
      'resetPassword':'إعادة تعيين كلمة المرور',
      'pleaseEnter':'الرجاء إدخال عنوان البريد الالكتروني الذي ترغب في إرسال معلومات إعادة تعيين كلمة مرور إليه',
      'success':'نجاح',
      'loginSuccess':'تم تسجيل الدخول بنجاح',
      'Account has been created':'تم إنشاء الجساب',
      'search':'بحث...',
      'Upload Posts':'تحميل البوستات',
      'Loading':'تحميل...',
      'following':'متابعهن',
      'followers':'متابعون',
      'posts':'البوستات',
      'signOut':'تسجيل خروج',
      'likes':'إعجابات',
      'View all':'رؤية جمع  التعليقات',
    },
    'en' : {
      '1': 'Arabic',
      '2': 'English',
      'login': 'Login',
      'forgotPassword': 'Forgot Password',
      'enterEmail': 'Enter Email Address',
      'enterPassword': 'Enter Password',
      'do not have': 'Don\'t have an account?',
      'Sign in': 'Sign in',
      'Already have an': 'Already have an account?',
      'enterFullName': 'Enter Full Name',
      'enterBio': 'Enter Bio',
      'resetPassword':'Reset Password',
      'pleaseEnter':'Please enter the email address you\'d like your password reset information sent to',
      'success':'Success',
      'loginSuccess':'Login Success',
      'Account has been created':'Account has been created',
      'search':'Search...',
      'Upload Posts':'Upload Posts',
      'Loading':'Loading...',
      'following':'Following',
      'followers':'Followers',
      'posts':'Posts',
      'signOut':'Sign Out',
      'likes':'Likes',
      'View all':'View all  Comments',
    }
  };

}
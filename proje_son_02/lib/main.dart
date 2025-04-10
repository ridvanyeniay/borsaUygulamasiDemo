import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool girisEkrani = true;

  final TextEditingController _kullaniciAdiKontrol = TextEditingController();
  final TextEditingController _sifreKontrol = TextEditingController();
  final TextEditingController _emailKontrol = TextEditingController();
  final TextEditingController _ikinciSifreKontrol = TextEditingController();

  Future<void> kullaniciyiKaydet(BuildContext context) async {
    final supabase = Supabase.instance.client;

    final username = _kullaniciAdiKontrol.text.trim();
    final email = _emailKontrol.text.trim();
    final password = _sifreKontrol.text.trim();
    final confirmPassword = _ikinciSifreKontrol.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreler uyuşmuyor')),
      );
      return;
    }

    final response = await supabase.from('users').insert({
      'username': username,
      'email': email,
      'password': password,
      'balance': 0,
      'created_ad': DateTime.now().toIso8601String(),
    }).execute();

    // Veriyi kontrol et
    if (response.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt başarılı')),
      );
      setState(() => girisEkrani = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kayıt sırasında bir hata oluştu')),
      );
    }
  }

  Future<void> girisYap(BuildContext context) async {
    final username = _kullaniciAdiKontrol.text.trim();
    final password = _sifreKontrol.text.trim();

    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('username', username)
        .eq('password', password)
        .single()
        .execute();

    // 
    if (response.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı')),
      );
      // buraya homapage yazılcak, borsa uygulamasının ana sayfası ya da portföy 
      ///
      ////// homapage yeri
      //////
      //////
      /////
      ///
      ///
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hatalı kullanıcı adı veya şifre')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red.shade700, Colors.purple.shade800],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _kullaniciAdiKontrol,
                      decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
                    ),
                    const SizedBox(height: 12),
                    if (!girisEkrani)
                      TextField(
                        controller: _emailKontrol,
                        decoration: const InputDecoration(labelText: 'E-posta'),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _sifreKontrol,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Şifre'),
                    ),
                    if (!girisEkrani) const SizedBox(height: 12),
                    if (!girisEkrani)
                      TextField(
                        controller: _ikinciSifreKontrol,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Şifre Tekrar'),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (girisEkrani) {
                              girisYap(context);
                            } else {
                              kullaniciyiKaydet(context);
                            }
                          },
                          child: Text(girisEkrani ? 'Giriş Yap' : 'Kayıt Ol'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              girisEkrani = !girisEkrani;
                            });
                          },
                          child: Text(girisEkrani ? 'Kayıt Ol' : 'Giriş Yap'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
